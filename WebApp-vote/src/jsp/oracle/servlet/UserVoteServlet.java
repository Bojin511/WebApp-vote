package jsp.oracle.servlet;

import java.io.*;
import java.util.Vector;

import javax.servlet.http.*;

import jsp.oracle.bean.AdminUser;

import jsp.oracle.bean.Question;

public class UserVoteServlet extends HttpServlet {

	private static final long serialVersionUID = 378216958170698920L;

	final static boolean VERBOSE = true;

	private HttpServletRequest vote_request = null;

	private HttpServletResponse vote_response = null;

	public void service(HttpServletRequest request, HttpServletResponse response) {
		vote_request = request;
		vote_response = response;
		
		String operation=vote_request.getParameter("operation");

		if(operation!=null&&operation.equals("vote"))
		{//User questionnaire
			try {
				
				this.vote();
				
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}

		}
	
	
	public void vote() throws IOException {
		
		int flag=1;//test if any error comes up,if flag is 0, the operation will not be processed
		HttpSession session = vote_request.getSession(true);
		AdminUser user=(AdminUser)session.getAttribute("adminUser");
		if(user==null)
		{
			flag=0;
			try {
				String msg="Sorry, you are not logged in and can not be a questionnaires!";
				vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
				}
				catch (Exception ex) 
			  {
				ex.printStackTrace();
			  }
		}
		int voteId=Integer.parseInt(vote_request.getParameter("voteId"));
		Question q=new Question();
		q.setVoteId(voteId);
		Vector qVector=null;
		try
		{
			qVector=q.getQuestionByVoteId();
			if(qVector==null)
			{
				flag=0;
				try {
					String msg="Sorry, there is no problem with the current questionnaire. Please try again later!";
					vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
					}
					catch (Exception ex) 
				  {
					ex.printStackTrace();
				  }
			}
		}
		catch (Exception ex) 
		  {
			   ex.printStackTrace();
		  }
		if(flag==1)
		{
		String userName=user.getUserName();
		//System.out.println(qVector.size());
		for(int i=0;i<qVector.size();i++)
		{
			q=(Question)qVector.get(i);
			String name=String.valueOf(q.getQuestionId());
			String answer=vote_request.getParameter(name);
			if(answer!=null&&!answer.trim().equals(""))
			{
				if(q.getUserChoice(userName)==-1)//The user has not answered the question yet
				{
//					System.out.println(answer);
					if(answer.length()==1)
						answer="0"+answer;
					//System.out.println(answer);
					q.setAnswerCount(q.getAnswerCount()+1);
					if(q.getAnswerUsers()==null)
						q.setAnswerUsers(userName+"#"+answer+"|");
					else
						q.setAnswerUsers(q.getAnswerUsers()+userName+"#"+answer+"|");
					
					//System.out.println(q.getAnswerUsers());
					//System.out.println(q.getUserChoice(userName));
					try
					{
				    		q.modifyQuestion();
					}
			    	catch(Exception e)
			    	{
						e.printStackTrace();
			    	}
				}
			}
		}
		try {
			String msg="The questionnaire was successful! Thank you for your participation!";
			vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
			}
			catch (Exception ex) 
		  {
				String msg="The questionnaire was successful! Thank you for your participation!";
				vote_response.sendRedirect("error.jsp?msg="+msg);

		  }
		
		}

	}

}
