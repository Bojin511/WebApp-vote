package jsp.oracle.util; 

public class Signal {
	
	
	public final static int COMMAND_ADMINUSER_LOGIN=11;
	
	public final static int COMMAND_ADMINUSER_LOGOUT=12;
	
	public final static int COMMAND_ADMINUSER_PWDMODIFY=13;
	
	public final static int COMMAND_ADMINUSER_EDITPWD=14;

	public final static int COMMAND_ADMINUSER_ADD=16;

	public final static int COMMAND_ADMINUSER_APPLYVOTE=31;                                  //8-22 marbo added Administrators apply for survey management rights

	public final static int COMMAND_ADMINUSER_APPROVEVOTE=32;                                  //8-22 marbo added administrator background approval questionnaire application

	//default when  errors come up 
	public final static int COMMAND_ERROR = 0 ;
	
	public static void main(String[] args) {

	}
	public final static int getCommand(String command)
	{
		
		if(command.equals("adminUserLogin"))
		{
			return COMMAND_ADMINUSER_LOGIN;
		}
		
		if(command.equals("adminUserLogout"))
		{
			return COMMAND_ADMINUSER_LOGOUT;
		}
		
		if(command.equals("adminUserPwdModify"))
		{
			return COMMAND_ADMINUSER_PWDMODIFY;
		}
		
		if(command.equals("editAdminUserPwd"))
		{
			return COMMAND_ADMINUSER_EDITPWD;
		}
		
		if(command.equals("createAdminUser"))
		{
			return COMMAND_ADMINUSER_ADD;
		}

		if(command.equals("applyVote"))                                                            //8-22 marbo-added
		{
			return COMMAND_ADMINUSER_APPLYVOTE;
		}

		if(command.equals("approveVote"))                                                  //8-22 marbo-added
		{
			return COMMAND_ADMINUSER_APPROVEVOTE;
		}
	
		return COMMAND_ERROR;
	}
}
