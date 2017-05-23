<%@ page contentType="text/html; charset=gbk" pageEncoding="gbk"%>

<%@ page import="jsp.oracle.bean.AdminUser,jsp.oracle.bean.Vote,jsp.oracle.bean.Question,
                  jsp.oracle.util.ParseString,
                  java.util.Vector"
    errorPage="error.jsp"
%>
<%//Controls access to users
	AdminUser adminUser = (AdminUser) session.getAttribute("adminUser");
	if(adminUser==null)
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
 	int rank=adminUser.getUserRank();
	int flag=0;//To determine whether the average user has the right to view the questionnaire
    String userVote=adminUser.getUserVote();
    ParseString votes=new ParseString(userVote,"\\|");
    Vector voteVector=votes.getStringVector();
    if(voteVector!=null&&voteVector.indexOf(String.valueOf(voteId))!=-1)//If the voteId is owned by the user
    flag=1;//You can view the questionnaire
	if(flag!=1&&rank!=1)
	 {%>
    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="You do not have permission to view this questionnaire!"/>
    </jsp:forward>
    <%}
    
    Vote vote=new Vote();
    vote.setVoteId(voteId);
    vote=vote.getVoteByVoteId();

%>

<%@ include file="global.jsp" %>

<html>
<head>
<title>Survey questionnaire management system</title>
<%@ include file="global.css" %>
</head>
<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc"<%= onload %>>




<%  // Title of this page and breadcrumbs
    String title = "View the questionnaire";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {title, "viewVote.jsp"}
    };
    String choices[]={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
    
%>
<%@ include file="title.jsp" %>

<p>

<%	String message = (String)session.getAttribute("message");
    if (message != null) {
%>
	<font color=red size="-1"><b><%= message %></b></font>
    <p>
<%	
session.removeAttribute("message");
} %>

<table align=center bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="90%">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td align="center" colspan=2 nowrap><font size="3" face="verdana"><b><%=vote.getVoteTitle()%></b></font></td>
</tr>
<tr bgcolor="#ffffff">
<td colspan=2>
<table width=100% border="0">
<tr bgcolor="#ffffff">
     <td width=10%></td>
    <td align="right" width="20%"><font size="-1">Start time:</font></td>
    <td align=left width=20%><font size="-1"><%=vote.getStartTime().substring(0,19)%></font></td>

     <td align="right" width="20%"><font size="-1">End Time:</font></td>
     <td align=left width=20%><font size="-1"><%=vote.getEndTime().substring(0,19)%></font></td> 
     <td width=10%></td>
</tr>
<tr bgcolor="<%= tblBorderColor %>"><td colspan=6 height=1></td></tr>
<tr bgcolor="#ffffff">
     <td align=left colspan=6 style="line-height:10px"><font size=-1><br></td>
</tr>
<tr bgcolor="#ffffff">
     <td align=left colspan=6 style="line-height:25px"><font size=-1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=vote.getVoteDescription()%></td>
</tr>
<%
Question q=new Question();
q.setVoteId(voteId);
Vector qVector=q.getQuestionByVoteId();
if(qVector!=null)
{
for(int i=0;i<qVector.size();i++)
{
q=(Question)qVector.get(i);

%>
<tr bgcolor="#ffffff">
     <td align=left colspan=6 style="line-height:25px"><font size=-1><br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
     problem&nbsp;<%=i+1%>£º<%=q.getQuestionTitle()%><br></font></td></tr>
<%
ParseString answers=new ParseString(q.getAnswers(),"\\|");
Vector answerVector=answers.getStringVector();
for(int j=0;j<q.getAnswerNum();j++)
{
%>
<td align=left colspan=6 style="line-height:25px"><font size=-1>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
     &nbsp;&nbsp;&nbsp;&nbsp;<%=choices[j]%>.&nbsp;<%=answerVector.get(j)%></font></td></tr>
<%}}}
%>    

</table>
</td>
</tr> 
 </table>
</td></tr>
</table>

<p>
<div align=right>
<input type=button value="Return to the previous page" style="height:20px" onclick="window.history.go(-1);">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type=button value="View Results" style="height:20px" onclick="location.href='viewVoteResult.jsp?voteId=<%=voteId%>'">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type=button value="Modify the questionnaire" style="height:20px" onclick="location.href='editVote.jsp?voteId=<%=voteId%>'">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</div>
