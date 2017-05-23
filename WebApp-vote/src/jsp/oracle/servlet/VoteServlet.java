package jsp.oracle.servlet;

import java.io.*;

import javax.servlet.http.*;

import jsp.oracle.bean.AdminUser;
import jsp.oracle.bean.Vote;
import jsp.oracle.bean.Question;

public class VoteServlet extends HttpServlet {

	private static final long serialVersionUID = 478216958170698920L;

	final static boolean VERBOSE = true;

	private HttpServletRequest vote_request = null;

	private HttpServletResponse vote_response = null;

	public void service(HttpServletRequest request, HttpServletResponse response) {
		vote_request = request;
		vote_response = response;
		
		String operation=vote_request.getParameter("operation");
		
		if(operation!=null&&operation.equals("addVote"))
		{//Create a questionnaire
			try {
				
				this.addVote();
				
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		else if(operation!=null&&operation.equals("editVote"))
		{//Edit the questionnaire
			try {
				
				this.editVote();
				
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		else if(operation!=null&&operation.equals("addQuestion"))
		{//Add a question
			try {
				
				this.addQuestion();
				
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		else if(operation!=null&&operation.equals("editQuestion"))
		{//Edit the question
			try {
				
				this.editQuestion();
				
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		else if(operation!=null&&operation.equals("delQuestion"))
		{//Remove the problem
			try {
				
				this.delQuestion();
				
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		else if(operation!=null&&operation.equals("vote"))
		{//Remove the problem
			try {
				
				this.vote();
				
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}

		}


	public void addVote() throws IOException {
		int flag=1;//test if any error comes up,if flag is 0, the operation will not be processed
		String voteTitle=vote_request.getParameter("voteTitle");
		String voteDescription=vote_request.getParameter("voteDescription");
		String startDate=vote_request.getParameter("startDate");		
		String endDate=vote_request.getParameter("endDate");	
		String comments=vote_request.getParameter("comments");
		String createUser=vote_request.getParameter("createUser");
		AdminUser adminUser=new AdminUser();
		adminUser.setUserName(createUser);
		adminUser=adminUser.getAdminUserByUserName();
		if(adminUser==null)
		{
			flag=0;
			try {
				String msg="Sorry, did not find the applicant! Applicant must be a registered user!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
				}
				catch (Exception ex) 
			  {
				ex.printStackTrace();
			  }
		}
		String createTime=new java.sql.Timestamp(System.currentTimeMillis()).toString();
		if(!CheckDate(startDate))//The starting time format is not legal
		{
			flag=0;
			try {
			String msg="Sorry, please fill in the release time in the correct format!";
			vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
		  {
			ex.printStackTrace();
		  }
			}
		if(!CheckDate(endDate))//End time format is not legal
		{
			flag=0;
			try {
			String msg="Sorry, please fill in the end time in the correct format!";
			vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
		  {
			ex.printStackTrace();
		  }
			}
		
		if(startDate.substring(8,10).equals("31")&&("0204060911".indexOf(startDate.substring(5,7))!=-1))
		{
			flag=0;	
			try{
				String msg = "Sorry, the starting time you filled does not exist ("+startDate.substring(5,7)+"Is there 31st in the month? ), Please re-fill!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
			{
			ex.printStackTrace();
			}
			
		}
		else if(startDate.substring(5,7).equals("02")&&(startDate.substring(8,10).equals("30")||startDate.substring(8,10).equals("29")))
		{
			flag=0;
			try{
				String msg ="Sorry, the starting time you filled does not exist ("+startDate.substring(5,7)+"month has"+startDate.substring(8,10)+"? ), Please re-fill!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
			{
			ex.printStackTrace();
			}
		}
	
		if(endDate.substring(8,10).equals("31")&&("0204060911".indexOf(endDate.substring(5,7))!=-1))
		{
			flag=0;
			try{
				String msg = "Sorry, the end time you filled does not exist ("+endDate.substring(5,7)+"Is there 31st? ), Please re-fill!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
			{
			ex.printStackTrace();
			}
			
		}
		else if(endDate.substring(5,7).equals("02")&&(endDate.substring(8,10).equals("30")||endDate.substring(8,10).equals("29")))
		{
			flag=0;
			try{
				String msg ="Sorry, the end time you filled does not exist ("+endDate.substring(5,7)+"month has"+endDate.substring(8,10)+"? ), Please re-fill!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
			{
			ex.printStackTrace();
			}
		}
		
		createTime=createTime.substring(0,19);
		int compare=createTime.compareTo(endDate);
		if(compare>0)//The end time is still before
		{
			flag=0;
			try {
				
			String msg="Sorry, please fill in the correct end time (must be some time in the future)!";
			vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
		  {
			ex.printStackTrace();
		  }
		}
		compare=startDate.compareTo(endDate);
		if(compare>=0)//The start time is later than the end time, or the same
		{
			flag=0;
			try {
				
			String msg="Sorry, please fill in the correct end time (must be later than the start time, not the same or earlier)!";
			vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
		  {
			ex.printStackTrace();
		  }
		}
		if(flag==1)
		{
	    HttpSession session = vote_request.getSession(true);		
		Vote vote=new Vote();
		vote.setComments(comments);
		vote.setCreateTime(createTime);
		vote.setCreateUser(createUser);
		vote.setEndTime(endDate);
		vote.setStartTime(startDate);
		vote.setVoteDescription(voteDescription);
		vote.setVoteTitle(voteTitle);
		 
	    try
		{
			vote.addVote();
			if(vote.getVoteId()!=-1)
			{
				if(adminUser.getUserVote()==null)
				{
					adminUser.setUserVote(String.valueOf(vote.getVoteId())+"|");
				}
				else
					adminUser.setUserVote(adminUser.getUserVote()+String.valueOf(vote.getVoteId())+"|");
			}
			
			adminUser.modifyAdminUser();
			session.setAttribute("adminUser",adminUser);//Update the adminUser information in the session
    	    session.setAttribute("message","Create a questionnaire successfully!");
			vote_request.getRequestDispatcher("userVote.jsp").forward(vote_request, vote_response);
		}
    	catch(Exception e)
    	{
    	    session.setAttribute("message","Create a questionnaire failed, please try again later!");
			vote_response.sendRedirect("createVote.jsp");
    	}
		}
	}

	public void editVote() throws IOException {
		//The length of time read from the database is generally greater than 19, so when compared with the time taken from the user and the readout time,
		//Need to read out the time of the substring (0,19)
		//If the questionnaire has already begun or is over, the questionnaire can not be modified
		int flag=1;//test if any error comes up,if flag is 0, the operation will not be processed
		String voteTitle=vote_request.getParameter("voteTitle");
		String voteDescription=vote_request.getParameter("voteDescription");
		String startDate=vote_request.getParameter("startDate");		
		String endDate=vote_request.getParameter("endDate");	
		String comments=vote_request.getParameter("comments");
		String createUser=vote_request.getParameter("createUser");
		AdminUser adminUser=new AdminUser();
		adminUser.setUserName(createUser);
		adminUser=adminUser.getAdminUserByUserName();
		if(adminUser==null)
		{
			flag=0;
			try {
				String msg="Sorry, did not find the applicant! Applicant must be an administrator!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
				}
				catch (Exception ex) 
			  {
				ex.printStackTrace();
			  }
		}
		if(!CheckDate(startDate))//The starting time format is not legal
		{
			flag=0;
			try {
			String msg="Sorry, please fill in the release time in the correct format!";
			vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
		  {
			ex.printStackTrace();
		  }
			}
		if(!CheckDate(endDate))//End time format is not legal
		{
			flag=0;
			try {
			String msg="Sorry, please fill in the end time in the correct format!";
			vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
		  {
			ex.printStackTrace();
		  }
			}
		if(startDate.substring(8,10).equals("31")&&("0204060911".indexOf(startDate.substring(5,7))!=-1))
		{
			flag=0;	
			try{
				String msg = "Sorry, the starting time you filled does not exist ("+startDate.substring(5,7)+"Is there 31st in the month? ), Please re-fill!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
			{
			ex.printStackTrace();
			}
			
		}
		else if(startDate.substring(5,7).equals("02")&&(startDate.substring(8,10).equals("30")||startDate.substring(8,10).equals("29")))
		{
			flag=0;
			try{
				String msg ="Sorry, the starting time you filled does not exist ("+startDate.substring(5,7)+"month has"+startDate.substring(8,10)+"? ), Please re-fill!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
			{
			ex.printStackTrace();
			}
		}
	
		if(endDate.substring(8,10).equals("31")&&("0204060911".indexOf(endDate.substring(5,7))!=-1))
		{
			flag=0;
			try{
				String msg = "Sorry, the end time you filled does not exist ("+endDate.substring(5,7)+"Is there 31at in the moneth? ), Please re-fill!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
			{
			ex.printStackTrace();
			}
			
		}
		else if(endDate.substring(5,7).equals("02")&&(endDate.substring(8,10).equals("30")||endDate.substring(8,10).equals("29")))
		{
			flag=0;
			try{
				String msg ="Sorry, the end time you filled does not exist ("+endDate.substring(5,7)+"month has"+endDate.substring(8,10)+"? ), Please re-fill!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
			{
			ex.printStackTrace();
			}
		}
		
		int voteId=Integer.parseInt(vote_request.getParameter("voteId"));
		Vote vote=new Vote();
		vote.setVoteId(voteId);
		try
		{
			vote=vote.getVoteByVoteId();			
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		String now=new java.sql.Timestamp(System.currentTimeMillis()).toString();
		now=now.substring(0,19);
		int compare=0;
		compare=startDate.compareTo(endDate);
		if(compare>=0)//The start time is later than the end time, or the same
		{
			flag=0;
			try {
				
			String msg="Sorry, please fill in the correct end time (must be later than the start time, not the same or earlier)!";
			vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
		  {
			ex.printStackTrace();
		  }
		}
		if(!startDate.equals(vote.getStartTime().substring(0,19)))//If the start time has changed
		{
			compare=now.compareTo(vote.getStartTime());
		if(compare>0&&adminUser.getUserRank()!=4)//Only the system administrator has the right to modify the questionnaires that have already begun
			//If the start time is now before, that is already started, and the operator is not a system administrator
		{
			flag=0;
			try {
				
			String msg="Sorry, the questionnaire has already begun and can not be modified again!";
			vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
		  {
			ex.printStackTrace();
		  }			
		}
		//The questionnaire was not yet started
		compare=now.compareTo(startDate);
		if(compare>0)//If you modify the start time, you can only modify it now
		{                                   
			flag=0;
			try {
				
			String msg="Sorry, the starting time of the start of the questionnaire can only be modified for some time in the future!";
			vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
		  {
			ex.printStackTrace();
		  }
		}
		}

		if(flag==1)
		{
	    HttpSession session = vote_request.getSession(true);		

		vote.setComments(comments);
		//vote.setCreateTime(createTime);
		vote.setCreateUser(createUser);
		vote.setEndTime(endDate);
		vote.setStartTime(startDate);
		vote.setVoteDescription(voteDescription);
		vote.setVoteTitle(voteTitle);
		 
	    try
		{
			vote.modifyVote();

    	    session.setAttribute("message","Modify the questionnaire successfully!");
			vote_request.getRequestDispatcher("editVote.jsp?voteId="+voteId).forward(vote_request, vote_response);
		}
    	catch(Exception e)
    	{
    	    session.setAttribute("message","Modify the questionnaire failed, please try again later!");
			vote_response.sendRedirect("editVote.jsp?voteId="+voteId);
			e.printStackTrace();
    	}
		}
	}
	
	
	public void addQuestion() throws IOException {
		int flag=1;//test if any error comes up,if flag is 0, the operation will not be processed
		String questionTitle=vote_request.getParameter("questionTitle");
		String [] answers=vote_request.getParameterValues("answers");

		if(questionTitle==null||questionTitle.equals(""))
		{
			flag=0;
			try {
				String msg="Sorry, the problem can not be empty!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
				}
				catch (Exception ex) 
			  {
				ex.printStackTrace();
			  }
		}
			
		String an=null;
		int num=0;
		int validNum=0;
					
		if(answers!=null&&answers.length>1)
		{
			num=answers.length;
			for(int i=0;i<num;i++)
			{

				if(!CheckCHN(answers[i],255))
				{
					flag=0;
					try {
						String msg="Sorry, the option can not appear illegal characters!";
						vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
						}
						catch (Exception ex) 
					  {
						ex.printStackTrace();
					  }
				}
				String chk="chkAppIt"+String.valueOf(i+1);
				String del=vote_request.getParameter(chk);//"Select the Delete option if checked, that is, del = null, is invalid
				if(answers[i]!=null&&!answers[i].trim().equals("")&&del==null)
				{
					validNum++;
					if(an==null)
						an=answers[i]+"|";
					else
						an=an+answers[i]+"|";
				}
				
			}
			//System.out.println(an);
		}
		if(validNum<2)
		{
			flag=0;
			try {
				String msg="Sorry, there is at least two options for a question!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
				}
				catch (Exception ex) 
			  {
				ex.printStackTrace();
			  }
		}
		if(flag==1)
		{
			int voteId=Integer.parseInt(vote_request.getParameter("voteId"));
			Question q=new Question();
			q.setAnswerCount(0);
			q.setAnswerNum(validNum);
			q.setAnswers(an);
			q.setAnswerUsers("");
			q.setQuestionTitle(questionTitle);
			q.setVoteId(voteId);
		    HttpSession session = vote_request.getSession(true);
		    try
			{
				q.addQuestion();
				
	    	    session.setAttribute("message","Add problem success!");
				vote_request.getRequestDispatcher("editVote.jsp?voteId="+voteId).forward(vote_request, vote_response);
			}
	    	catch(Exception e)
	    	{
	    	    session.setAttribute("message","Add problem failed, please try again later!");
				vote_response.sendRedirect("editVote.jsp?voteId="+voteId);
	    	}
		}

	}

	
	public void editQuestion() throws IOException {
		//If the questionnaire has already begun or has ended, you can not modify the question under the questionnaire
		int flag=1;//test if any error comes up,if flag is 0, the operation will not be processed
		int questionId=Integer.parseInt(vote_request.getParameter("questionId"));
		int voteId=Integer.parseInt(vote_request.getParameter("voteId"));
		//System.out.println(voteId);
		Vote vote=new Vote();
		vote.setVoteId(voteId);
		try{
			vote=vote.getVoteByVoteId();
			if(vote.getVoteStatus()!=1)//The questionnaire is in progress or is over
				flag=0;			
		}
		catch (Exception ex) 
		  {
			ex.printStackTrace();
		  }
		String questionTitle=vote_request.getParameter("questionTitle");
		String [] answers=vote_request.getParameterValues("answers");

//		Map map=vote_request.getParameterMap();
	//	int times=map.size()-2;

		//String [] chkAppIt=vote_request.getParameterValues("chkAppIt");
		/*for(int j=0;j<chkAppIt.length;j++)
		System.out.println(chkAppIt[j]);*/
		String an=null;
		int num=0;
		int validNum=0;
					
		if(answers!=null&&answers.length>1)
		{
			num=answers.length;
			for(int i=0;i<num;i++)
			{

				if(!CheckCHN(answers[i],255))
				{
					flag=0;
					try {
						String msg="Sorry, the option can not appear illegal characters!";
						vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
						}
						catch (Exception ex) 
					  {
						ex.printStackTrace();
					  }
				}
				String chk="chkAppIt"+String.valueOf(i+1);
				String del=vote_request.getParameter(chk);
				if(answers[i]!=null&&!answers[i].trim().equals("")&&del==null)
				{
					validNum++;
					if(an==null)
						an=answers[i]+"|";
					else
						an=an+answers[i]+"|";
				}
				
			}
			//System.out.println(an);
		}
		if(validNum<2)
		{
			flag=0;
			try {
				String msg="Sorry, there is at least two options for a question!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
				}
				catch (Exception ex) 
			  {
				ex.printStackTrace();
			  }
		}
		if(flag==1)
		{
			System.out.println(an);
			Question q=new Question();
			q.setQuestionId(questionId);
			q.setAnswerNum(validNum);
			q.setAnswers(an);
			q.setQuestionTitle(questionTitle);
			q.setVoteId(voteId);
		    HttpSession session = vote_request.getSession(true);
		    try
			{
				q.modifyQuestion();
				
	    	    session.setAttribute("message","Modify the problem successfully!");
				vote_request.getRequestDispatcher("editVote.jsp?voteId="+voteId).forward(vote_request, vote_response);
			}
	    	catch(Exception e)
	    	{
	    	    session.setAttribute("message","Modified question failed, please try again later!");
				vote_response.sendRedirect("editVote.jsp?voteId="+voteId);
	    	}
		}
		
	}
	
	
	public void delQuestion() throws IOException {
		
		int questionId=Integer.parseInt(vote_request.getParameter("questionId"));
		int voteId=Integer.parseInt(vote_request.getParameter("voteId"));
		Question q=new Question();
		q.setQuestionId(questionId);
		HttpSession session = vote_request.getSession(true);
		try
		{
			q.deleteQuestion();
			
    	    session.setAttribute("message","Remove the problem successfully!");
			vote_request.getRequestDispatcher("editVote.jsp?voteId="+voteId).forward(vote_request, vote_response);
		}
    	catch(Exception e)
    	{
    	    session.setAttribute("message","Delete the problem failed, please try again later!");
			vote_response.sendRedirect("editVote.jsp?voteId="+voteId);
    	}
		
	}
	
	public void vote() throws IOException {
		System.out.println("here now");
		String q0=vote_request.getParameter("q0");
		System.out.println(q0);
		String q1=vote_request.getParameter("q1");
		System.out.println(q1);
		HttpSession session = vote_request.getSession(true);
		int voteId=Integer.parseInt(vote_request.getParameter("voteId"));
		try
		{
    	    session.setAttribute("message","User Questionnaire Successful!");
			vote_response.sendRedirect("../vote.jsp?voteId="+voteId);
		}
    	catch(Exception e)
    	{
    	    session.setAttribute("message","User questionnaire failed, please try again later!");
			//vote_request.getRequestDispatcher("../vote.jsp?voteId="+voteId).forward(vote_request, vote_response);
    	}
	}
	
	public boolean CheckCHN(String item,int len)
    { 
	 String invalidChar="\"#\\|";
	 for(int i=0;i<item.length();i++)
		{
		 if(invalidChar.indexOf(item.charAt(i))!=-1)
			{return false;}
	    }
         if(item.length()>len)
              {return false;}
	 return true;
	}	
	
	
	public boolean CheckDate(String item)
    { 
		 String validChar="0123456789";
	     int i=0;
		 //Whether the test contains "-"
		 if(item.indexOf("-")==-1)
			{return false;}
		 //Intercepts the first "-" string before
		 String CheckYear=item.substring(0,item.indexOf("-"));
		 //To determine whether the length of the string is 4
		 if(CheckYear.length()!=4)
			{return false;}
		 //Judgment is not numerical
		 for(i=0;i<4;i++)
			{
			 if(validChar.indexOf(CheckYear.charAt(i))==-1)
				{return false;}
			}
		 //Determine the size of this value
	      if(Integer.parseInt(CheckYear)<1900||Integer.parseInt(CheckYear)>2100)
			{return false;}
		  //Truncate the string of the year
		  item=item.substring(5,item.length());
	     //Whether the test contains "-"
		 if(item.indexOf("-")==-1)
			{return false;}
		 //Intercept the first "-" before the string for the month
		 String CheckMonth=item.substring(0,item.indexOf("-"));
		 //To determine whether the string length is 1 or 2
		 if((CheckMonth.length()!=1)&&(CheckMonth.length()!=2))
			{return false;}
		 //Judgment is not numerical
		 for(i=0;i<CheckMonth.length();i++)
			{
			 if(validChar.indexOf(CheckMonth.charAt(i))==-1)
				{return false;}
			}
		 //Judge the size of this value is not more than 12
	      if(Integer.parseInt(CheckMonth)>12||Integer.parseInt(CheckMonth)<1)
			{return false;}
	     //Truncate the string to remove the month
		  item=item.substring((CheckMonth.length()+1),item.length());
	     //Does the test contain " "
		 if(item.indexOf(" ")==-1)
			{return false;}
		 //Intercept the first " " before the string for the day
		 String CheckDay=item.substring(0,item.indexOf(" "));
		 //To determine whether the string length is 1 or 2
		 if((CheckDay.length()!=1)&&(CheckDay.length()!=2))
			{return false;}
		 //Judgment is not numerical
		 for(i=0;i<CheckDay.length();i++)
			{
			 if(validChar.indexOf(CheckDay.charAt(i))==-1)
				{return false;}
			}
		 //Judge the size of this value is not more than 31
	      if(Integer.parseInt(CheckDay)>31||Integer.parseInt(CheckDay)<1)
			{return false;}
		  //Truncate the string to remove the day
		  item=item.substring((CheckDay.length()+1),item.length());
	     //Does the test contain ":"
		 if(item.indexOf(":")==-1)
			{return false;}
		 //Intercept the first ":" before the string is timed
		 String CheckHour=item.substring(0,item.indexOf(":"));
		 //To determine whether the string length is 1 or 2
		 if((CheckHour.length()!=1)&&(CheckHour.length()!=2))
			{return false;}
		 //Judgment is not numerical
		 for(i=0;i<CheckHour.length();i++)
			{
			 if(validChar.indexOf(CheckHour.charAt(i))==-1)
				{return false;}
			}
		 //To determine the size of this value is not more than 60
	      if(Integer.parseInt(CheckHour)>23||Integer.parseInt(CheckHour)<0)
			{return false;}
          //	Truncate the string to remove the hour
		  item=item.substring((CheckHour.length()+1),item.length());
	     //Does the test contain ":"
		 if(item.indexOf(":")==-1)
			{return false;}
		 //Intercept the first ":" before the string for the points
		 String CheckMinute=item.substring(0,item.indexOf(":"));
		 //To determine whether the string length is 1 or 2
		 if((CheckMinute.length()!=1)&&(CheckMinute.length()!=2))
			{return false;}
		 //Judgment is not numerical
		 for(i=0;i<CheckMinute.length();i++)
			{
			 if(validChar.indexOf(CheckMinute.charAt(i))==-1)
				{return false;}
			}
		 //To determine the size of this value is not more than 60
	      if(Integer.parseInt(CheckMinute)>60||Integer.parseInt(CheckMinute)<0)
			{return false;}
          //	Truncate the divided string
		  item=item.substring((CheckMinute.length()+1),item.length());
		  String CheckSecond=item;
		 //To determine whether the string length is 1 or 2
		 if((CheckSecond.length()!=1)&&(CheckSecond.length()!=2))
			{return false;}
		 //Judgment is not numerical
		 for(i=0;i<CheckSecond.length();i++)
			{
			 if(validChar.indexOf(CheckSecond.charAt(i))==-1)
				{return false;}
			}
		 //To determine the size of this value is not more than 60
	      if(Integer.parseInt(CheckSecond)>60||Integer.parseInt(CheckSecond)<0)
			{return false;}
	        return true;
		}

}
