package jsp.oracle.bean;

import java.sql.*;
import java.util.Vector;

import jsp.oracle.database.DBConnect;

public class Vote{
	private int voteId;					//Questionnaire ID
	
	private String voteTitle;			//Questionnaire
	
	private String voteDescription;		//Questionnaire description / description
	
	private String createTime;			//Questionnaire creation time
	
	private String startTime;			//Questionnaire start time
	
	private String endTime;				//Questionnaire end time
	
	private String createUser;			//Questionnaire creator
	
	private String comments;			//Questionnaire notes


	public String getComments() {
		return comments;
	}


	public void setComments(String comments) {
		this.comments = comments;
	}


	public String getCreateTime() {
		return createTime;
	}


	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}


	public String getCreateUser() {
		return createUser;
	}


	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}


	public String getEndTime() {
		return endTime;
	}


	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}


	public String getStartTime() {
		return startTime;
	}


	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}


	public String getVoteDescription() {
		return voteDescription;
	}


	public void setVoteDescription(String voteDescription) {
		this.voteDescription = voteDescription;
	}


	public int getVoteId() {
		return voteId;
	}


	public void setVoteId(int voteId) {
		this.voteId = voteId;
	}


	public String getVoteTitle() {
		return voteTitle;
	}


	public void setVoteTitle(String voteTitle) {
		this.voteTitle = voteTitle;
	}

	public int addVote() throws Exception{
		String sql="insert into vote(voteId,voteTitle,voteDescription,"
		+"createTime,startTime,endTime,createUser,comments)"
		+" Values(vote_seq.nextval,?,?,to_date(?,'yyyy-mm-dd hh24:mi:ss')"
		+",to_date(?,'yyyy-mm-dd hh24:mi:ss'),to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,?)";//7 in total
		
		DBConnect dbc=new DBConnect(sql);

		dbc.setString(1,voteTitle);
		dbc.setString(2,voteDescription);
		dbc.setString(3,createTime);
		dbc.setString(4,startTime);
		dbc.setString(5,endTime);
		dbc.setString(6,createUser);
		dbc.setString(7,comments);
		int flag=dbc.executeUpdate();
		dbc.close();
		this.setVoteId(this.getInsertedVoteId());
		return flag;
	}
	
	public int deleteVote() throws Exception {
		String sql = "delete from vote where voteId=?";
		DBConnect dbc=new DBConnect(sql);
		dbc.setInt(1,voteId);
		int flag=dbc.executeUpdate();
		
		dbc.close();
		return flag;

	}
	
	public int modifyVote() throws Exception{
		String sql="update vote set voteTitle=?,voteDescription=?,createTime=to_date(substr(?,1,19),'yyyy-mm-dd hh24:mi:ss'),"
		+"startTime=to_date(substr(?,1,19),'yyyy-mm-dd hh24:mi:ss'),endTime=to_date(substr(?,1,19),'yyyy-mm-dd hh24:mi:ss')"
		+",createUser=?,comments=? where voteId=?"; //8 ? in total
		DBConnect dbc=new DBConnect(sql);
		dbc.setString(1,voteTitle);
		dbc.setString(2,voteDescription);
		dbc.setString(3,createTime);
		dbc.setString(4,startTime);
		dbc.setString(5,endTime);
		dbc.setString(6,createUser);
		dbc.setString(7,comments);
		dbc.setInt(8,voteId);
		int flag=dbc.executeUpdate();
		dbc.close();
		return flag;
	}
	
	public int getInsertedVoteId() throws Exception{
		String sql="select voteId from vote where to_char(createTime,'yyyy-mm-dd hh24:mi:ss')=? and createUser=?";

		try
		{
			DBConnect dbc = new DBConnect(sql);
			dbc.setString(1,createTime);
			dbc.setString(2,createUser);
			ResultSet rs=dbc.executeQuery();
			while (rs.next()) {
				//vote.setVoteId(rs.getInt(1));
				int id=rs.getInt(1);
				dbc.close();
				//System.out.println(id);
				return id;
			}			
		}
         catch (Exception ex) {
		     ex.printStackTrace();
	      }

	return -1;	
	}
	
	//Status of the questionnaire: 0 - in progress; 1 - unpublished; 2 - ended
	public int getVoteStatus()
	{
		String now=new java.sql.Timestamp(System.currentTimeMillis()).toString();
		int s=startTime.compareTo(now);
		int e=now.compareTo(endTime);
		if(s>0)//The start time is after now
			return 1;
		if(s<=0&&e<0)//The start time is before now, and the end time is after now
			return 0;
		if(e>=0)//The end time is before now
			return 2;
		return 0;
	}
	
	public Vote getVoteByVoteId() throws Exception{
		String sql = "select voteId,voteTitle,voteDescription,createTime,"
		+"startTime,endTime,createUser,comments from vote where voteId=?";
		Vote vote = new Vote();
		
		try {
			DBConnect dbc = new DBConnect(sql);
			dbc.setInt(1,voteId);
			ResultSet rs=dbc.executeQuery();
			while (rs.next()) {
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				dbc.close();
				return vote;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return null;	

	}
	
	public Vote getVoteByVoteTitle() throws Exception{
		String sql = "select voteId,voteTitle,voteDescription,createTime,"
		+"startTime,endTime,createUser,comments from vote where voteTitle=?";
		Vote vote = new Vote();
		
		try{
			DBConnect dbc = new DBConnect(sql);
			dbc.setString(1,voteTitle);
			ResultSet rs=dbc.executeQuery();
			while(rs.next()){
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				dbc.close();
				return vote;
			}
		}catch(Exception e){
			e.printStackTrace();
			throw e;
		}
		return null;
	}
	
	public Vector getVoteByCreateUser() throws Exception{
		String sql = "select voteId,voteTitle,voteDescription,createTime,"
		+"startTime,endTime,createUser,comments from vote where createUser=?";

		
		try{
			DBConnect dbc = new DBConnect(sql);
			dbc.setString(1,createUser);
			ResultSet rs=dbc.executeQuery();
			Vector voteVector=new Vector();
			while(rs.next()){
				Vote vote = new Vote();
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				voteVector.add(vote);

			}
			dbc.close();
			return voteVector;
		}catch(Exception e){
			e.printStackTrace();

		}
		return null;
	}
	
	
	//*******************************************************
	//The following methods handle a user's questionnaire management
	public Vector getCurrentVoteByCreateUser() throws Exception{
		String sql = "select voteId,voteTitle,voteDescription,createTime,"
			+"startTime,endTime,createUser,comments from vote" +
					" where startTime<=sysdate and endTime>sysdate " +
					" and createUser=?" +
					" order by startTime desc";
		try {
			DBConnect dbc=new DBConnect(sql);
			dbc.setString(1,createUser);
			ResultSet rs=dbc.executeQuery();
			Vector voteVector=new Vector();
			while (rs.next()) {
				Vote vote = new Vote();
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				voteVector.add(vote);
				//System.out.println(vote.getStartTime());
				//System.out.println(vote.getEndTime());
			}
			dbc.close();
			return voteVector;
		}catch(Exception e){
			e.printStackTrace();

		}
		return null;		
	}
	
	public Vector getUnvalidVoteByCreateUser() throws Exception{
		String sql = "select voteId,voteTitle,voteDescription,createTime,"
			+"startTime,endTime,createUser,comments from vote" +
					" where startTime>sysdate " +
					" and createUser=? " +
					"order by startTime asc";
		try {
			DBConnect dbc=new DBConnect(sql);
			dbc.setString(1,createUser);
			ResultSet rs=dbc.executeQuery();
			Vector voteVector=new Vector();
			while (rs.next()) {
				Vote vote = new Vote();
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				voteVector.add(vote);
			}
			dbc.close();
			return voteVector;
		}catch(Exception e){
			e.printStackTrace();

		}
		return null;		
	}	
	

	
	public Vector getOldVoteByCreateUser() throws Exception{
		String sql = "select voteId,voteTitle,voteDescription,createTime,"
			+"startTime,endTime,createUser,comments from vote" +
					" where startTime<=sysdate and endTime<=sysdate " +
					" and createUser=? " +
					"order by endTime desc";
		try {
			DBConnect dbc=new DBConnect(sql);
			dbc.setString(1,createUser);
			ResultSet rs=dbc.executeQuery();
			Vector voteVector=new Vector();
			while (rs.next()) {
				Vote vote = new Vote();
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				voteVector.add(vote);
			}
			dbc.close();
			return voteVector;
		}catch(Exception e){
			e.printStackTrace();

		}
		return null;		
	}
	
	
	public Vector getAllVoteByCreateUser() throws Exception{
		String sql = "select voteId,voteTitle,voteDescription,createTime,"
		+"startTime,endTime,createUser,comments from vote" +
		" where createUser=?" +
		" order by startTime desc";
		
		try {
			DBConnect dbc=new DBConnect(sql);
			dbc.setString(1,createUser);
			ResultSet rs=dbc.executeQuery();
			Vector voteVector=new Vector();
			while (rs.next()) {
				Vote vote = new Vote();
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				voteVector.add(vote);
			}
			dbc.close();
			return voteVector;
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	//The above method handles all of the user's questionnaires
	//*******************************************************
	
	//*******************************************************
	//The following methods handle all survey management, which is used by the system administrator
	public Vector getCurrentVote() throws Exception{
		String sql = "select voteId,voteTitle,voteDescription,createTime,"
			+"startTime,endTime,createUser,comments from vote" +
					" where startTime<=sysdate and endTime>sysdate " +
					" order by startTime desc";
		try {
			DBConnect dbc=new DBConnect();
			ResultSet rs=dbc.executeQuery(sql);
			Vector voteVector=new Vector();
			while (rs.next()) {
				Vote vote = new Vote();
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				voteVector.add(vote);
				//System.out.println(vote.getStartTime());
				//System.out.println(vote.getEndTime());
			}
			dbc.close();
			return voteVector;
		}catch(Exception e){
			e.printStackTrace();

		}
		return null;		
	}
	
	public Vector getUnvalidVote() throws Exception{
		String sql = "select voteId,voteTitle,voteDescription,createTime,"
			+"startTime,endTime,createUser,comments from vote" +
					" where startTime>sysdate " +
					"order by startTime asc";
		try {
			DBConnect dbc=new DBConnect();
			ResultSet rs=dbc.executeQuery(sql);
			Vector voteVector=new Vector();
			while (rs.next()) {
				Vote vote = new Vote();
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				voteVector.add(vote);
			}
			dbc.close();
			return voteVector;
		}catch(Exception e){
			e.printStackTrace();

		}
		return null;		
	}	
	

	
	public Vector getOldVote() throws Exception{
		String sql = "select voteId,voteTitle,voteDescription,createTime,"
			+"startTime,endTime,createUser,comments from vote" +
					" where startTime<=sysdate and endTime<=sysdate " +
					"order by endTime desc";
		try {
			DBConnect dbc=new DBConnect();
			ResultSet rs=dbc.executeQuery(sql);
			Vector voteVector=new Vector();
			while (rs.next()) {
				Vote vote = new Vote();
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				voteVector.add(vote);
			}
			dbc.close();
			return voteVector;
		}catch(Exception e){
			e.printStackTrace();

		}
		return null;		
	}
	
	
	public Vector getAllVote() throws Exception{
		String sql = "select voteId,voteTitle,voteDescription,createTime,"
		+"startTime,endTime,createUser,comments from vote" +
				" order by startTime desc";
		
		try {
			DBConnect dbc=new DBConnect();
			ResultSet rs=dbc.executeQuery(sql);
			Vector voteVector=new Vector();
			while (rs.next()) {
				Vote vote = new Vote();
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				voteVector.add(vote);
			}
			dbc.close();
			return voteVector;
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	//All the above methods handle all questionnaires
	//*******************************************************


	public int getVoteCount() throws Exception
	{
		String sql = "select count(*) from vote";
		try
		{
			DBConnect dbc = new DBConnect();
			ResultSet rs = dbc.executeQuery(sql);
			int count = 0;
			while(rs.next())
			{
				count = rs.getInt(1);
			}
			dbc.close();
			return count;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return -1;
	}
/*
	public Vector getStatusVoteCount() throws Exception
	{
		String sql = "select * from vote";
		try
		{
			DBConnect dbc = new DBConnect();
			ResultSet rs = dbc.executeQuery(sql);
			int status = 0;
			int a=0;
			int b=0;
			int c=0;
			Vector statusVector = new Vector();
			while(rs.next())
			{
				Vote vote = new Vote();
				vote.setVoteId(rs.getInt(1));
				vote.setVoteTitle(rs.getString(2));
				vote.setVoteDescription(rs.getString(3));
				vote.setCreateTime(rs.getString(4));
				vote.setStartTime(rs.getString(5));
				vote.setEndTime(rs.getString(6));
				vote.setCreateUser(rs.getString(7));
				vote.setComments(rs.getString(8));
				status = vote.getVoteStatus();
				switch(status)
				{
					case 0:
						a++;break;                //Number of questionnaires in progress
					case 1:
						b++;break;               //Number of unpublished questionnaires
					case 2:
						c++;break;               //Number of completed questionnaires
					default:
						System.out.println("Status error!!!");
				}
				statusVector.add(a);
				statusVector.add(b);
				statusVector.add(c);
			}
			dbc.close();
			return statusVector;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}
	*/
	public Vector getStatusVoteCount() throws Exception
	{
		int a=0;
		int b=0;
		int c=0;
		Vector statusVector = new Vector();
		String sql = "select count(*) from vote where startTime<=sysdate and endTime>sysdate";
		String sql2 = "select count(*) from vote where startTime>sysdate";
		String sql3 = "select count(*) from vote where startTime<=sysdate and endTime<=sysdate";
		try
		{
			DBConnect dbc = new DBConnect();
			ResultSet rs = dbc.executeQuery(sql);
			while(rs.next())
			{
				a=rs.getInt(1);
			}
			dbc.close();
			dbc = new DBConnect();
			rs = dbc.executeQuery(sql2);
			while(rs.next())
			{
				b=rs.getInt(1);
			}
			dbc.close();
			dbc = new DBConnect();
			rs = dbc.executeQuery(sql3);
			while(rs.next())
			{
				c=rs.getInt(1);
			}
			dbc.close();
			statusVector.add(String.valueOf(a));
			statusVector.add(String.valueOf(b));
			statusVector.add(String.valueOf(c));

		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return statusVector;
	}
}