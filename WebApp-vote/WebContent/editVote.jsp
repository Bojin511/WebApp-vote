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
	int flag=0;//To determine whether the average user has the authority to modify the questionnaire
    String userVote=adminUser.getUserVote();
    ParseString votes=new ParseString(userVote,"\\|");
    Vector voteVector=votes.getStringVector();
    if(voteVector!=null&&voteVector.indexOf(String.valueOf(voteId))!=-1)//If the voteId is owned by the user
    flag=1;//You can modify the questionnaire
	if(flag!=1&&rank!=1)
	 {%>
    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="You do not have permission to modify this questionnaire!"/>
    </jsp:forward>
    <%}
    
    Vote vote=new Vote();
    vote.setVoteId(voteId);
    vote=vote.getVoteByVoteId();
    if(vote.getVoteStatus()==2)//The questionnaire has ended
	 {%>
    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="The questionnaire has ended and no one can modify it!"/>
    </jsp:forward>
    <%}%>

<%@ include file="global.jsp" %>

<html>
<head>
<title>Survey questionnaire management system</title>
<%@ include file="global.css" %>
<script language = "JavaScript">
function CheckForm()
{
	if (document.myform.createUser.value=="")
	{
		alert("Questionnaires can not be empty!");
		document.myform.createUser.focus();
		return false;
	}
	if (document.myform.voteTitle.value=="")
	{
		alert("Questionnotes can not be empty!");
		document.myform.voteTitle.focus();
		return false;
	}
	if (document.myform.voteTitle.value.length>24)
	{
		alert("The length of the questionnaire can not be greater than 24 characters!");
		document.myform.voteTitle.focus();
		return false;
	}
	if (document.myform.voteTitle.value.length<8)
	{
		alert("The length of the questionnaire can not be less than 8 characters!");
		document.myform.voteTitle.focus();
		return false;
	}
		if (document.myform.voteDescription.value=="")
	{
		alert("Questionnaires can not be empty!");
		document.myform.voteDescription.focus();
		return false;
	}
	    if (document.myform.voteTitle.value.length>255)
	{
		alert("Sorry, the questionnaire is too long, please give a brief description!");
		document.myform.voteTitle.focus();
		return false;
	}
    if (document.myform.voteDescription.value.length>255)
	{
		alert("Sorry, the questionnaire is too long, please give a brief description!");
		document.myform.voteDescription.focus();
		return false;
	}
    if (document.myform.startDate.value.length!=19)
	{
		alert("Sorry, the questionnaire was not in the wrong format. Please fill in again!");
		document.myform.startDate.focus();
		return false;
	}

    if (document.myform.endDate.value.length!=19)
	{
		alert("Sorry, the questionnaire is not in the wrong format. Please fill in again!");
		document.myform.endDate.focus();
		return false;
	}

	return true;  
}
</script>
</head>
<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc"<%= onload %>>




<%  // Title of this page and breadcrumbs
    String title = "Modify the questionnaire";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {title, "editVote.jsp"}
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

<form action="VOTEADMIN?voteId=<%=voteId%>" method="post" name="myform" target="_self" onSubmit="return CheckForm();">
<input type=hidden name=operation value="editVote">
<table align=center bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="90%">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td align="center" colspan=2 nowrap><font size="-1" face="verdana"><b>Modify the questionnaire</b></font></td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center" width="20%"><font size="-1">founder</font></td>
    <td align=left><input name="createUser" value="<%=vote.getCreateUser()%>" <%if(rank!=1){%> readonly<%}%> type="text" size="25" maxlength="255" onKeypress="if(event.keyCode==32||(event.keyCode>=34&&event.keyCode<=39)||event.keyCode==42||event.keyCode==47||(event.keyCode>=58&&event.keyCode<=63)||event.keyCode==92||event.keyCode==94||event.keyCode==43) event.returnValue = false;">
    <font color=red size=-1>*</font></td>
</tr>

<tr bgcolor="#ffffff">
    <td align="center" width="20%"><font size="-1">Questionnaire title</font></td>
    <td align=left><input name="voteTitle" value="<%=vote.getVoteTitle()%>" type="text" size="56" maxlength="255" onKeypress="if(event.keyCode==32||(event.keyCode>=34&&event.keyCode<=39)||event.keyCode==42||event.keyCode==47||(event.keyCode>=58&&event.keyCode<=63)||event.keyCode==92||event.keyCode==94||event.keyCode==43) event.returnValue = false;">
    <font color=red size=-1><br>*Use a word greater than or equal to 8 words less than or equal to 24 words to describe the questionnaire</font></td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center"><font size="-1">Survey notes</font></td>
    <td align=left><textarea name="voteDescription" cols="50" rows="5" maxlength="255" wrap="physical"><%=vote.getVoteDescription()%></textarea>
    <font color=red size=-1>*No more than 255 words, will be displayed as user visible</font></td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center"><font size="-1">Start time</font></td>
    <td align=left><input name="startDate" value="<%=vote.getStartTime().substring(0,19)%>" type="text" size="19" maxlength="19" onKeypress="if (!((event.keyCode >= 48 && event.keyCode <= 58)||(event.keyCode == 45)||(event.keyCode == 32)))event.returnValue = false;">
    <font color=red size=-1>*Please follow the example format exactly as follows:2008-08-08 08:08:08</font>
    </td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center"><font size="-1">End Time</font></td>
    <td align=left><input name="endDate" value="<%=vote.getEndTime().substring(0,19)%>" type="text" size="19" maxlength="19" onKeypress="if (!((event.keyCode >= 48 && event.keyCode <= 58)||(event.keyCode == 45)||(event.keyCode == 32)))event.returnValue = false;">
    <font color=red size=-1>*Please follow the example format exactly as follows:2008-08-08 08:08:08</font>
    </td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center"><font size="-1">Remarks</font></td>
    <td align=left>
    <textarea name="comments" cols="80" rows="5" wrap="physical" class="textarea"><%=vote.getComments()%></textarea><br>
	 </td>
</tr>

 <tr bgcolor="#ffffff">

    <td align="center" colspan=2><input type="submit" value="Modify the questionnaire" style="height:20px">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="reset" value="fill in again" style="height:20px">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=button value="Preview effect" style="height:20px" onclick="location.href='viewVote.jsp?voteId=<%=voteId%>'"></td>
</tr>
 </table>
</td></tr>
</table>
</form>
<p><br></p>
<table align=center bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="90%">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td align="center" colspan=2 nowrap><font size="-1" face="verdana"><b>The questionnaire contains questions</b></font></td>
</tr>
<%
Question q=new Question();
q.setVoteId(voteId);
Vector qVector=q.getQuestionByVoteId();
if(qVector==null)
{
%>
 <tr bgcolor="#ffffff">
    <td align="center" colspan=2><font color=blue size=-1>Did not find the problem</font>
        </td>
</tr>

<%}
else
{
for(int i=0;i<qVector.size();i++)
{
q=(Question)qVector.get(i);

%>
 <tr bgcolor="#ffffff">
    <td align="center" width=20%><font size=-1>problem&nbsp;<%=i+1%></font></td>
    <td align="center" width=80%>
    <table width=100% style="line-height:25px">
    <tr bgcolor="#ffffff">
    <td align=left><font size=-1>&nbsp;&nbsp;<%=q.getQuestionTitle()%></font>
        </td>
    </tr><tr bgcolor="<%= tblBorderColor %>"><td height=1></td></tr>
<%
ParseString answers=new ParseString(q.getAnswers(),"\\|");
Vector answerVector=answers.getStringVector();
for(int j=0;j<q.getAnswerNum();j++)
{
%>
 <tr bgcolor="#ffffff">
    <td align="left"><font size=-1>&nbsp;&nbsp;&nbsp;&nbsp;<%=choices[j]%>.&nbsp;<%=answerVector.get(j)%></font>
        </td>
 </tr>
<%}%><tr bgcolor="<%= tblBorderColor %>"><td height=1></td></tr>
 <tr bgcolor="#ffffff">
    <td align="center" valign=middle><form action=VOTEADMIN?questionId=<%=q.getQuestionId()%>&voteId=<%=voteId%> name=qq method=post>
    <input type=hidden name=operation value="delQuestion">
    <font size=-1><%
    if(vote.getVoteStatus()==1){%><INPUT TYPE="button" value="修改此问题" style="height:20px" onclick="location.href='editQ.jsp?questionId=<%=q.getQuestionId()%>'">
    <%}
    else if(vote.getVoteStatus()==0){%><font color=red>The questionnaire is in progress and can not be modified</font>
    <%}else if(vote.getVoteStatus()==2){%><font color=red>The questionnaire has ended and can not be modified</font>
    <%}%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type=submit value="Remove this problem" style="height:20px" onclick='if(window.confirm("Delete operation can not be restored! The The Are you sure you want to delete this question?")){return true;}else{return false;}'>
    </font></form>
        </td>
 </tr>
</table></td></tr>

<%}}%>
</td></tr>
 <tr bgcolor="#ffffff">
    <td align="right" valign=middle colspan=2><INPUT TYPE="button" value="Add a question" style="height:20px" onclick="location.href='addQ.jsp?voteId=<%=voteId%>'">
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type=button value="Preview effect" style="height:20px" onclick="location.href='viewVote.jsp?voteId=<%=voteId%>'">
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type=button value="Return to the previous page" style="height:20px" onclick="window.history.go(-1);">
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
</tr>
</table>
</td></tr>
</table>
<p>

