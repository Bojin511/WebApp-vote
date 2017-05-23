<%@ page contentType="text/html; charset=gbk" pageEncoding="gbk"%>

<%@ page import="jsp.oracle.bean.AdminUser,jsp.oracle.bean.Vote,jsp.oracle.bean.Question,
                  jsp.oracle.util.ParseString,
                  java.util.Vector"%>
<%//Controls access to users
	AdminUser user = (AdminUser) session.getAttribute("adminUser");
	if(user==null)
	{%>

    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="You are not logged in!"/>
    </jsp:forward>
<%
	}
    String vId=request.getParameter("voteId");
    if(vId==null)
    {%>
    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="Do not specify the necessary parameters, the operation can not be implemented!"/>
    </jsp:forward>
    <%}
        int voteId=Integer.parseInt(vId);
    Vote vote=new Vote();
    vote.setVoteId(voteId);
    vote=vote.getVoteByVoteId();
    if(vote.getVoteStatus()==1)
    {%>
    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="Sorry, the questionnaire does not exist or has not yet been released, the operation can not be implemented!"/>
    </jsp:forward>
    <%}
     String choices[]={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};

    %>

<%@ include file="global.jsp" %>

<html>
<head>
<title>Survey questionnaire management system</title>
<%@ include file="global.css" %>

</head>
<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc"<%= onload %>>

<%  // Title of this page and breadcrumbs
    String title = "User questionnaire";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {title, "vote.jsp"}
    };
%>
<%@ include file="title.jsp" %>

<%--The contents of the questionnaire begin--%>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><td>
		<form action="USERVOTE?voteId=<%=voteId%>" method="post">
		<input type=hidden name=operation value="vote">
<table align=center cellpadding="0" cellspacing="0" border="0" width="90%">
<tr>
    <td align="center" colspan=2 nowrap><font size="3" face="verdana"><br><b><%=vote.getVoteTitle()%></b><br><br></font></td>
</tr>
<tr>
<td colspan=2>
<table width=100% border="0">
<tr>
     <td width=5%></td>
    <td align="center" colspan=4 width="90%"><font size="-1">Start time:</font>
    <font size="-1"><%=vote.getStartTime().substring(0,19)%></font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size="-1">End Time:</font>
     <font size="-1"><%=vote.getEndTime().substring(0,19)%></font></td> 
     <td width=5%></td>
</tr>
<tr><td></td><td colspan=4 bgcolor="#999999" width=80% height=1></td><td></td></tr>
<tr>
     <td align=left colspan=6 style="line-height:10px"><font size=-1><br></td>
</tr>
<tr>
     <td align=left colspan=6 style="line-height:25px"><font size=-1><br>&nbsp;&nbsp;&nbsp;&nbsp;<%=vote.getVoteDescription()%></td>
</tr>
<%
Question q=new Question();
q.setVoteId(voteId);
Vector qVector=q.getQuestionByVoteId();
int flag=0;//Whether the user is valid, whether the user has answered all the questions, if not, flag = 1
if(qVector!=null&&qVector.size()!=0)
{
for(int i=0;i<qVector.size();i++)
{
q=(Question)qVector.get(i);
//int hasVoted=q.hasVoted(user.getUserName());
//if(hasVoted==0)
//flag=1;
int userChoice=q.getUserChoice(user.getUserName());
if(userChoice==-1)
flag=1;
%>
<tr><td></td>
     <td align=left colspan=4 style="line-height:25px"><font size=-1><br>
     problem&nbsp;<%=i+1%>��<%=q.getQuestionTitle()%><br></font></td><td></td></tr>
<%
ParseString answers=new ParseString(q.getAnswers(),"\\|");
Vector answerVector=answers.getStringVector();
for(int j=0;j<q.getAnswerNum();j++)
{
%>
<tr><td></td><td align=left valign=top width=3% style="line-height:25px"><font size=-1>
     &nbsp;&nbsp;&nbsp;<input type=radio name="<%=String.valueOf(q.getQuestionId())%>" value=<%=j%>
     <%if(userChoice!=-1){%> disabled<%}
     if(userChoice==j){%> checked<%}%>>&nbsp;<%=choices[j]%>.</font></td>
     <td colspan=3 style="line-height:25px"><font size=-1><%=answerVector.get(j)%></font></td><td></td></tr>
<%}}
%>

<tr><td colspan=6 align=center>
<%
if(flag==1){%>    
<input type="submit" value="submit" style="height:20px">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="reset" value="Reset" style="height:20px">
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         <input type=button value="View current results" style="height:20px" onclick="location.href='voteResult.jsp?voteId=<%=voteId%>'">
<%}
else
{%>Hello, you have completed the questionnaire, thank you for your attention!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=button value="View Results" style="height:20px" onclick="location.href='voteResult.jsp?voteId=<%=voteId%>'">
<%}%></td>
        </tr>
     <%}
     else {%>
 <tr><td></td><td colspan=4 align=center width=90% height=15><font color=red size=-1>There is no problem with this questionnaire. Please try again later!</font></td><td></td></tr>
 <%}%>       
<tr><td></td><td colspan=4 width=90% height=15></td><td></td></tr>
 </table>
</td></tr>
</table></form>
</td></tr></table><%--The questionnaire ends--%>
		
</body>
</html>


