package jsp.oracle.servlet;
import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jsp.oracle.util.MD5;
import jsp.oracle.util.Signal;
import jsp.oracle.bean.AdminUser;


public class AdminServlet extends HttpServlet {

	private static final long serialVersionUID = 878216958170698920L;

	final static boolean VERBOSE = true;

	private HttpServletRequest vote_request = null;

	private HttpServletResponse vote_response = null;

	public void service(HttpServletRequest request, HttpServletResponse response) {
		vote_request = request;
		vote_response = response;
		String command = request.getParameter("cmd");
		try {
			switch (Signal.getCommand(command)) {

			case Signal.COMMAND_ADMINUSER_LOGIN:
				adminUserLogin();
				break;	

			case Signal.COMMAND_ADMINUSER_LOGOUT:
				adminUserLogout();
				break;		
		
			case Signal.COMMAND_ADMINUSER_PWDMODIFY:
				adminUserPwdModify();
				break;
				
			case Signal.COMMAND_ADMINUSER_ADD:
				createAdminUser();
				break;
				
			case Signal.COMMAND_ADMINUSER_EDITPWD:
				editAdminUserPwd();
				break;

			case Signal.COMMAND_ADMINUSER_APPLYVOTE:
				applyVote();
				break;

			case Signal.COMMAND_ADMINUSER_APPROVEVOTE:
				approveVote();
				break;

			default:
				vote_request.getRequestDispatcher("message.jsp?msg=System error, please try again later!").forward(vote_request, vote_response);
				break;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void adminUserLogin() throws IOException {
		    HttpSession session = vote_request.getSession(true);

			String userName = vote_request.getParameter("userName");
			String userPwd = vote_request.getParameter("userPwd");
			String msg = "System error!";
			AdminUser adminUser=new AdminUser();
			MD5 md5=new MD5();
			adminUser.setUserName(userName);
			adminUser.setUserPwd(md5.getMD5ofStr(userPwd));
			try {
				int result=adminUser.verifyAdminUser();
				if (result == 1) {
					
		            session.setAttribute("adminLogin", "true");
					AdminUser sessionUser = adminUser.getAdminUserByUserName();
					session.setAttribute("adminUser", sessionUser);
					vote_response.sendRedirect("index.jsp");
				} else
				{
					try
					{
						msg = "Username or password entered incorrectly, please log in again!";
						vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
					}
					catch (Exception ex) 
					{
					ex.printStackTrace();
					}    
				}
			} catch (Exception ex) {
				ex.printStackTrace();
			}
	}

	public void adminUserLogout() throws IOException {
		try {
			String msg = "System error!";
			HttpSession session = vote_request.getSession(true);
			String login = (String) session.getAttribute("adminLogin");
			if(login!=null && login.equals("true"))
			{
			session.invalidate();
			vote_response.sendRedirect("index.jsp");

			}
			else
			{
				msg = "Login time is too long, has automatically quit!";				
				vote_response.sendRedirect("error.jsp?msg="+msg);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void adminUserPwdModify() throws IOException 
	{
		try 
		{
			String msg = "System error!";
			HttpSession session = vote_request.getSession(true);
			AdminUser adminUser = new AdminUser();
			adminUser = (AdminUser) session.getAttribute("adminUser");
			String userPwd = vote_request.getParameter("userPwd");
			MD5 md5=new MD5();

			int result = adminUser.verifyAdminUser();
			
			if (result == 1)       //The user exists
			{
				try 
				{
				  if(userPwd != "")        //Need to change password
				  {
					String oldPwd = md5.getMD5ofStr(userPwd);
					
					String userNewPwd = vote_request.getParameter("userNewPwd");
					String userNewPwd1 = vote_request.getParameter("userNewPwd1");

					if(!oldPwd.equals(adminUser.getUserPwd()))   //The original password is wrong
					   {
				   			try
							{
								msg = "The original password input error, please enter the new!";
								vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
							}
							catch (Exception ex) 
							{
								ex.printStackTrace();
							}    
					   }						
					else if (!userNewPwd.equals(userNewPwd1)) 
					   {
				   			try
							{
								msg = "New password and password verification are inconsistent, please re-enter!";
								vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
							}
							catch (Exception ex) 
							{
								ex.printStackTrace();
							}    
					   }	
					else
						{
							adminUser.setUserPwd(md5.getMD5ofStr(userNewPwd));
						}
					int modResult = adminUser.modifyAdminUser();
					if (modResult == 1)
						{
						session.setAttribute("adminUser",adminUser);//Update the adminUser information in the session
								session.setAttribute("message","Password reset complete!");
								vote_response.sendRedirect("modifyPwd.jsp");
						}
					else
					   {
				   			try
							{
								msg = "Change password failed, please try again!";
								vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
							}
							catch (Exception ex) 
							{
								ex.printStackTrace();
							}    
					   }	
				   }
				}
				catch (Exception ex) 
				{
					ex.printStackTrace();
				}
			}
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}

	}
	
	public void editAdminUserPwd() throws IOException{
		String msg="";
		HttpSession session = vote_request.getSession(true);
		String adminUser = vote_request.getParameter("userName");
		AdminUser admin=new AdminUser();
		admin.setUserName(adminUser);
		admin=admin.getAdminUserByUserName();

		MD5 md5=new MD5();
		String userNewPwd = vote_request.getParameter("userNewPwd");
		String userNewPwd1 = vote_request.getParameter("userNewPwd1");
		if(userNewPwd!=null&&userNewPwd1!=null)
		{
			if (!userNewPwd.equals(userNewPwd1)) 
			   {
		   			try
					{
						msg = "New password and password verification are inconsistent, please re-enter!";
						vote_request.getRequestDispatcher("error.jsp?msg="+msg).forward(vote_request, vote_response);
					}
					catch (Exception ex) 
					{
						ex.printStackTrace();
					}    
			   }
			else
			{
					admin.setUserPwd(md5.getMD5ofStr(userNewPwd));
					try
					{
						int modResult = admin.modifyAdminUser();
						if (modResult == 1)
						{
								session.setAttribute("message","Password reset complete!");
								vote_response.sendRedirect("editAdminUser.jsp?userName="+adminUser);
						}
						else
						{
				   			try
							{
								msg = "Change password failed, please try again!";
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
				}
		   }
	}
	
	public void createAdminUser() throws IOException        //Add an administrator
	{
		try
		{
			String msg = "System error!";
			HttpSession session = vote_request.getSession(true);
			AdminUser adminUser = new AdminUser();
			adminUser = (AdminUser) session.getAttribute("adminUser");
			String userPwd = adminUser.getUserPwd();
			String userPwd1 = vote_request.getParameter("userPwd");
			MD5 md5 = new MD5();
			if(userPwd.equals(md5.getMD5ofStr(userPwd1)))         //System administrator identification
			{
				String pwd=vote_request.getParameter("userNewPwd");
				String pwd1=vote_request.getParameter("userNewPwd1");
				if(pwd!=null&&pwd1!=null&&pwd.equals(pwd1))
				{
					String userName = vote_request.getParameter("userName");
					AdminUser adminUser1 = new AdminUser();
					adminUser1.setUserName(userName);
					adminUser1 = adminUser1.getAdminUserByUserName();
					if(adminUser1 == null)       //Create a new article manager
					{
						adminUser1 = new AdminUser();
						adminUser1.setUserName(userName);
						adminUser1.setUserPwd(md5.getMD5ofStr(pwd));
						String rank=vote_request.getParameter("userRank");
						int userRank=Integer.parseInt(rank);
						adminUser1.setUserRank(userRank);
						int result = adminUser1.addAdminUser();
						try
						{
							if(result == 1)  //Added administrator success
							{
								if(userRank==0)
									session.setAttribute("message","Create general user success!");
								else
									session.setAttribute("message","Create a system administrator success!");
								vote_response.sendRedirect("createAdminUser.jsp");
							}
							else        //Failed to add administrator
						   {
					   			try
								{
									msg = "Create user, please try again!";
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
					}
					else
					{
						session.setAttribute("message","The user name already exists, please use another username!");
						vote_response.sendRedirect("createAdminUser.jsp");
					}
					
				}
				else
				{
					session.setAttribute("message","New user's password input is inconsistent, please re-enter!");
					vote_response.sendRedirect("createAdminUser.jsp");
					
				}
				
			}
			else
			{
	   			try
				{
					msg = "Create user password input error, please re-enter";
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
	}

	public void applyVote() throws IOException                         
	{
		try
		{
			HttpSession session = vote_request.getSession(true);
			AdminUser adminUser = (AdminUser)session.getAttribute("adminUser");
			int confirm = adminUser.verifyAdminUser();
			if(confirm == 1)
			{
				adminUser.setApplyVote(adminUser.getApplyVote()+1);
				int result = adminUser.modifyAdminUser();
				if(result ==1)
				{
					session.setAttribute("adminUser",adminUser);//Update the adminUser information in the session
					vote_request.getRequestDispatcher("error.jsp?msg=Application of survey questionnaire management success!").forward(vote_request, vote_response);
				}
				else
				{
					vote_request.getRequestDispatcher("error.jsp?msg=Apply for a questionnaire failure, please try again later!").forward(vote_request, vote_response);
				}
			}
			else
			{
				vote_request.getRequestDispatcher("error.jsp?msg=User does not exist!").forward(vote_request, vote_response);
			}
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}

	public void approveVote() throws IOException                       
	{
		try
		{
			HttpSession session = vote_request.getSession(true);
			AdminUser adminUser = (AdminUser)session.getAttribute("applicate");
			int voteCount = Integer.parseInt(vote_request.getParameter("voteCount"));
	
			int confirm = adminUser.verifyAdminUser();
			if(confirm == 1)
			{
				int applyVote = adminUser.getApplyVote();
				if(applyVote < voteCount || voteCount < 0)
				{
					vote_request.getRequestDispatcher("error.jsp?msg=Enter the number of applications approved for survey management Illegal!").forward(vote_request, vote_response);
				}
				else
				{
					adminUser.setVotePower(adminUser.getVotePower()+voteCount);
					adminUser.setApplyVote(applyVote-voteCount);
					int result = adminUser.modifyAdminUser();
					if(result ==1)
					{
						session.setAttribute("message","Approve the success of the questionnaire management authority!");
						vote_request.getRequestDispatcher("viewVoteApplication.jsp").forward(vote_request, vote_response);
					}
					else
					{
						vote_request.getRequestDispatcher("error.jsp?msg=Approved questionnaires permission application failed, please try again later!").forward(vote_request, vote_response);
					}
				}
			}
			else
			{
				vote_request.getRequestDispatcher("error.jsp?msg=User does not exist!").forward(vote_request, vote_response);
			}
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}

	
}
