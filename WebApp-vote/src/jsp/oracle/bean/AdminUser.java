package jsp.oracle.bean;

import java.io.IOException;
import java.sql.ResultSet;
import java.util.Vector;

import jsp.oracle.database.DBConnect;

public class AdminUser
{
	private String userName;		//username

	private String userPwd;			//user password

	private int userRank;			//user rank
	
	private String userVote;		//list of user's questionnaire ID numbers
	
	private int votePower;			//Number of Approved Questionnaire Management

	private int applyVote;			//The number of times the user has applied for the number of questionnaires to be approved

	public int getUserRank() {
		return userRank;
	}

	public void setUserRank(int userRank) {
		this.userRank = userRank;
	}

	public int getApplyVote() {
		return applyVote;
	}

	public void setApplyVote(int applyVote) {
		this.applyVote = applyVote;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getUserVote() {
		return userVote;
	}

	public void setUserVote(String userVote) {
		this.userVote = userVote;
	}

	public int getVotePower() {
		return votePower;
	}

	public void setVotePower(int votePower) {
		this.votePower = votePower;
	}

	/*
	*	Get all AdminUsers
	*	This function might used before managing AdminUsers
	*   like creating, deleting, modifying AdminUsers, etc
	*/
	public Vector getAllAdminUsers() throws IOException
	{
		String sql = "select * from voteuser";
		try
		{
			DBConnect dbc = new DBConnect();
			ResultSet rs = dbc.executeQuery(sql);
			Vector adminUserVector = new Vector();
			while(rs.next())
			{
				AdminUser adminUser = new AdminUser();
				adminUser.setUserName(rs.getString(1));
				adminUser.setUserPwd(rs.getString(2));
				adminUser.setUserRank(rs.getInt(3));
				adminUser.setUserVote(rs.getString(4));
				adminUser.setVotePower(rs.getInt(5));
				adminUser.setApplyVote(rs.getInt(6));

				adminUserVector.add(adminUser);
				}
				dbc.close();
				return adminUserVector;

		}catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}

	/*
	*	Get an AdminUser  by userName
	*	because userName is unique
	*	the retun value would be only one adminUser
	*/
	public AdminUser getAdminUserByUserName() throws IOException
	{
		String sql = "select * from voteuser where userName=?";
		try
		{
			DBConnect dbc = new DBConnect(sql);
			dbc.setString(1,userName);
			ResultSet rs= dbc.executeQuery();

			while(rs.next())
			{
				AdminUser adminUser = new AdminUser();
				adminUser.setUserName(rs.getString(1));
				adminUser.setUserPwd(rs.getString(2));
				adminUser.setUserRank(rs.getInt(3));
				adminUser.setUserVote(rs.getString(4));
				adminUser.setVotePower(rs.getInt(5));
				adminUser.setApplyVote(rs.getInt(6));

				dbc.close();
				return adminUser;
			}
			
		} catch (Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}

	/*
	*	Get AdminUsers by userRank
	*	the return value should be a Vector
	*/
	public Vector getAdminUsersByUserRank() throws IOException
	{
		String sql = "select * from voteuser where userRank=?";
		try
		{
			DBConnect dbc = new DBConnect(sql);
			dbc.setInt(1,userRank);
			ResultSet rs = dbc.executeQuery();
			Vector adminUserVector = new Vector();
			while(rs.next())
			{
				AdminUser adminUser = new AdminUser();
				adminUser.setUserName(rs.getString(1));
				adminUser.setUserPwd(rs.getString(2));
				adminUser.setUserRank(rs.getInt(3));
				adminUser.setUserVote(rs.getString(4));
				adminUser.setVotePower(rs.getInt(5));
				adminUser.setApplyVote(rs.getInt(6));

				adminUserVector.add(adminUser);
				}
				dbc.close();
				return adminUserVector;

		}catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}


	/*
	*	Create an AdminUser
	*	retun the number of records affected
	*/
	public int addAdminUser() throws Exception
	{
		String sql = "insert into voteuser(userName,userPwd,userRank,userVote,votePower,applyVote) "
		+" values(?,?,?,?,?,?)";       //6 in total
		DBConnect dbc = new DBConnect(sql);

		dbc.setString(1,userName);
		dbc.setString(2,userPwd);
		dbc.setInt(3,userRank);
		dbc.setString(4,userVote);
		dbc.setInt(5,votePower);
		dbc.setInt(6,applyVote);

		int flag = dbc.executeUpdate();

		dbc.close();
		return flag;
	}

	/*
	*	delete an AdminUser
	*	return the number of records affected
	*/
	public int deleteAdminUser() throws Exception
	{
		String sql = "delete from voteuser where userName=?";
		DBConnect dbc = new DBConnect(sql);
		dbc.setString(1,userName);
		int flag = dbc.executeUpdate();

		dbc.close();
		return flag;
	}

	/*
	*	modify the infomation of an AdminUser
	*	retunr the number of records affected
	*/
	public int modifyAdminUser() throws Exception
	{
		String sql = "update voteuser set userPwd=?,userRank=?,userVote=?,votePower=?,applyVote=?"
		+" where userName=?";  //userName 是不可以更改的,6 ? in total

		DBConnect dbc = new DBConnect(sql);

		dbc.setString(1,userPwd);
		dbc.setInt(2,userRank);
		dbc.setString(3,userVote);	
		dbc.setInt(4,votePower);
		dbc.setInt(5,applyVote);
		dbc.setString(6,userName);

		int flag = dbc.executeUpdate();

		dbc.close();
		return flag;
	}
	
	// verify the object user by matching with db data
	//determine whether the password is right 
	public int verifyAdminUser() throws IOException {
		int flag=0;
		try {
			String sql = "select userPwd from voteuser where userName=? and userPwd=?";
			DBConnect dbc = new DBConnect(sql);

			dbc.setString(1,userName);
			dbc.setString(2,userPwd);
			ResultSet rs=dbc.executeQuery();

			if (rs.next()) {			
						flag=1;
				}					
			dbc.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return flag;		
	}

	public Vector getApplyVoteAdminUsers() throws IOException                 //apply for vote manage
	{
		String sql = "select * from voteuser where applyVote != 0";
		try
		{
			DBConnect dbc = new DBConnect();
			ResultSet rs = dbc.executeQuery(sql);
			Vector adminUserVector = new Vector();
			while(rs.next())
			{
				AdminUser adminUser = new AdminUser();

				adminUser.setUserName(rs.getString(1));
				adminUser.setUserPwd(rs.getString(2));
				adminUser.setUserRank(rs.getInt(3));
				adminUser.setUserVote(rs.getString(4));
				adminUser.setVotePower(rs.getInt(5));
				adminUser.setApplyVote(rs.getInt(6));

				adminUserVector.add(adminUser);
				}
				dbc.close();
				return adminUserVector;

		}catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}

}