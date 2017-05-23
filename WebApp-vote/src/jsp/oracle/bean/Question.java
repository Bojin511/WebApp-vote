package jsp.oracle.bean;

import java.sql.*;
import java.util.Vector;

import jsp.oracle.database.DBConnect;
import jsp.oracle.util.ParseString;

public class Question{
	private int questionId;				//Problem ID
	
	private int voteId;					//Questionnaire of the questionnaire to which the question belongs
	
	private String questionTitle;		//Problem title
	
	private int answerNum;				//Number of problem options
	
	private String answers;				//Problem list of options, connect with "|"
	
	private int answerCount;			//Number of questions answered
	
	private String answerUsers;			//Answer the list of user names and connect with "|"
	
	
	public int getQuestionId(){
		return this.questionId;
	}
	public int getVoteId(){
		return this.voteId;
	}
	public String getQuestionTitle(){
		return this.questionTitle;
	}
	public int getAnswerNum(){
		return this.answerNum;
	}
	public String getAnswers(){
		return this.answers;
	}
	public int getAnswerCount(){
		return this.answerCount;
	}
	public String getAnswerUsers(){
		return this.answerUsers;
	}
	
	public void setQuestionId(int q){
		this.questionId = q;
	}
	public void setVoteId(int v){
		this.voteId = v;
	}
	public void setQuestionTitle(String q){
		this.questionTitle = q;
	}
	public void setAnswerNum(int a){
		this.answerNum = a;
	}
	public void setAnswers(String a){
		this.answers = a;
	}
	public void setAnswerCount(int a){
		this.answerCount = a;
	}
	public void setAnswerUsers(String a){
		this.answerUsers = a;
	}
	
	public int addQuestion() throws Exception{
		String sql = "insert into question(questionId,voteId,"
		+"questionTitle,answerNum,answers,answerCo"
		+"unt,answerUsers) values(question_seq.nextval,?,?,?,?,?,?)";
		
		try{
			DBConnect dbc=new DBConnect(sql);
			dbc.setInt(1,voteId);
			dbc.setString(2,questionTitle);
			dbc.setInt(3,answerNum);
			dbc.setString(4,answers);
			dbc.setInt(5,answerCount);
			dbc.setString(6,answerUsers);
			int flag=dbc.executeUpdate();
			dbc.close();
			return flag;
		}catch(Exception e){
			e.printStackTrace();

		}
		return 0;
	}
	
	public int deleteQuestion() throws Exception {
		String sql = "delete from question where questionId=?";
		
		try{
			DBConnect dbc=new DBConnect(sql);
			dbc.setInt(1,questionId);
			int flag=dbc.executeUpdate();
			dbc.close();
			return flag;
		}catch(Exception e){
			e.printStackTrace();

		}
		return 0;
	}

	public int modifyQuestion() throws Exception{
		String sql="update question set voteId=?,questionTitle=?,"
		+"answerNum=?,answers=?,answerCount=?,answerUsers=? where questionId=?";

		try{
			DBConnect dbc=new DBConnect(sql);
			
			dbc.setInt(1,voteId);
			dbc.setString(2,questionTitle);
			dbc.setInt(3,answerNum);
			dbc.setString(4,answers);
			dbc.setInt(5,answerCount);
			dbc.setString(6,answerUsers);
			dbc.setInt(7,questionId);
			int flag=dbc.executeUpdate();
			dbc.close();
			return flag;
		}catch(Exception e){
			e.printStackTrace();

		}
		return 0;
	}
	
	public Question getQuestionByQuestionId() throws Exception{
		String sql = "select questionId,voteId,questionTitle,answerNum,"
		+"answers,answerCount,answerUsers from question where questionId=?";
		Question qust = new Question();
		
		try {
			DBConnect dbc = new DBConnect(sql);
			dbc.setInt(1,questionId);
			ResultSet rs=dbc.executeQuery();
			while (rs.next()) {
				qust.setQuestionId(rs.getInt(1));
				qust.setVoteId(rs.getInt(2));
				qust.setQuestionTitle(rs.getString(3));
				qust.setAnswerNum(rs.getInt(4));
				qust.setAnswers(rs.getString(5));
				qust.setAnswerCount(rs.getInt(6));
				qust.setAnswerUsers(rs.getString(7));
				dbc.close();
				return qust;
			}
		}catch(Exception e){
			e.printStackTrace();

		}
		return null;
	}
	
	public Vector getQuestionByVoteId() throws Exception{
		String sql = "select questionId,voteId,questionTitle,answerNum,"
		+"answers,answerCount,answerUsers from question where voteId=? order by questionId asc";
		Vector qustVector=new Vector();
		
		try{
			DBConnect dbc=new DBConnect(sql);
			dbc.setInt(1,voteId);
			ResultSet rs=dbc.executeQuery();
			while (rs.next()) {
				Question qust = new Question();
				qust.setQuestionId(rs.getInt(1));
				qust.setVoteId(rs.getInt(2));
				qust.setQuestionTitle(rs.getString(3));
				qust.setAnswerNum(rs.getInt(4));
				qust.setAnswers(rs.getString(5));
				qust.setAnswerCount(rs.getInt(6));
				qust.setAnswerUsers(rs.getString(7));
				qustVector.add(qust);
			}
			dbc.close();
			return qustVector;
		}catch(Exception e){
			e.printStackTrace();

		}
		return null;
	}
	
	
	public Vector getQuestionByQuestionTitle() throws Exception{
		String sql = "select questionId,voteId,questionTitle,answerNum,"
		+"answers,answerCount,answerUsers from question where questionTitle=?";
		
		
		try{
			DBConnect dbc = new DBConnect(sql);
			dbc.setString(1,questionTitle);
			ResultSet rs=dbc.executeQuery();
			Vector questionVector=new Vector();
			while(rs.next()){
				Question qust = new Question();
				qust.setQuestionId(rs.getInt(1));
				qust.setVoteId(rs.getInt(2));
				qust.setQuestionTitle(rs.getString(3));
				qust.setAnswerNum(rs.getInt(4));
				qust.setAnswers(rs.getString(5));
				qust.setAnswerCount(rs.getInt(6));
				qust.setAnswerUsers(rs.getString(7));
				
				questionVector.add(qust);
			}
			dbc.close();
			return questionVector;
		}catch(Exception e){
			e.printStackTrace();

		}
		return null;
	}
	
	public Vector getAllQuestion() throws Exception{
		String sql = "select questionId,voteId,questionTitle,answerNum,"
		+"answers,answerCount,answerUsers from question";
		Vector qustVector = new Vector();
		
		try{
			DBConnect dbc=new DBConnect();
			ResultSet rs=dbc.executeQuery(sql);
			while (rs.next()){
				Question qust = new Question();
				qust.setQuestionId(rs.getInt(1));
				qust.setVoteId(rs.getInt(2));
				qust.setQuestionTitle(rs.getString(3));
				qust.setAnswerNum(rs.getInt(4));
				qust.setAnswers(rs.getString(5));
				qust.setAnswerCount(rs.getInt(6));
				qust.setAnswerUsers(rs.getString(7));
				qustVector.add(qust);
			}
			dbc.close();
			return qustVector;
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	/*
	public int hasVoted(String userName)
	{
		if(this.getAnswerUsers().indexOf(userName)!=-1)
			return 1;
		else
			return 0;
	}*/
	
	public int getUserChoice(String userName)
	{
		ParseString choice=new ParseString(this.getAnswerUsers(),"\\|");
		Vector choiceVector=choice.getStringVector();//User name # The vector of the sequence number
		String key=null;
		if(choiceVector!=null)
		{
			for(int i=0;i<this.getAnswerNum();i++)//Number of options loop
			{
				if(i<10)
					key=userName+"#0"+String.valueOf(i);
				else
					key=userName+"#"+String.valueOf(i);
				//System.out.println(key);
				if(choiceVector.indexOf((String)key)!=-1)
					return i;//User name # option number If it exists in all user names + answer combinations, the serial number is the user's selected
			}
		}
		
		return -1;

	}
	
	public Vector getStatistics()
	{
		Vector resultVector=new Vector();
		ParseString choice=new ParseString(this.getAnswerUsers(),"\\|");
		Vector choiceVector=choice.getStringVector();
		String key=null;
		int result=0;
		String answers=null;
		if(choiceVector!=null)
		{
			for(int i=0;i<this.getAnswerNum();i++)//For each option of the problem
			{
				if(i<10)
					key="#0"+String.valueOf(i);
				else
					key="#"+String.valueOf(i);//Get a search keyword related to the option
				
				for(int j=0;j<choiceVector.size();j++)//Match the result data
				{
					answers=(String)choiceVector.get(j);
					//System.out.println(answers.substring(answers.indexOf("#")));
					if(key.equals(answers.substring(answers.indexOf("#"))))
						result++;//If it matches, the number of options is incremented
				}
				//System.out.println(result);
				key=String.valueOf(result);
				resultVector.add(key);//Put this option into the vector
				result=0;

			}
			return resultVector;
		}
		else
		{
			for(int i=0;i<this.getAnswerNum();i++)
				resultVector.add("0");
			return resultVector;
		}
		
		//return null;
	}
	

}