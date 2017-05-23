<%@ page contentType="text/html; charset=gbk" pageEncoding="gbk"%>

<%@ page import="jsp.oracle.bean.AdminUser,
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
	int rank=adminUser.getUserRank();
	int flag=0;//To determine whether the average user has the authority to create a questionnaire
    String userVote=adminUser.getUserVote();
    ParseString votes=new ParseString(userVote,"\\|");
    Vector voteVector=votes.getStringVector();
    int votePower=adminUser.getVotePower();
    if((voteVector!=null&&votePower>voteVector.size())||(voteVector==null&&votePower>0))//If the user's votePower value is greater than the number of questionnaires currently available
    flag=1;//You can create a questionnaire
	if(rank!=1&&flag!=1)
	 {%>
    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="You do not have permission to create a questionnaire!"/>
    </jsp:forward>
    <%}

%>

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
	if (document.myform.voteTitle.value.length<13)
	{
		alert("The length of the questionnaire can not be less than 12 characters!");
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
    String title = "Create a questionnaire";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {title, "createVote.jsp"}
    };
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

<form action="VOTEADMIN" method="post" name="myform" target="_self" onSubmit="return CheckForm();">
<input type=hidden name=operation value="addVote">
<table align=center bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="90%">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td align="center" colspan=2 nowrap><font size="-1" face="verdana"><b>Create a questionnaire</b></font></td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center" width="20%"><font size="-1">founder</font></td>
    <td align=left><input name="createUser" value="<%=adminUser.getUserName()%>" <%if(rank!=1){%> readonly<%}%> type="text" size="25" maxlength="255" onKeypress="if(event.keyCode==32||(event.keyCode>=34&&event.keyCode<=39)||event.keyCode==42||event.keyCode==47||(event.keyCode>=58&&event.keyCode<=63)||event.keyCode==92||event.keyCode==94||event.keyCode==43) event.returnValue = false;">
    <font color=red size=-1>*</font></td>
</tr>

<tr bgcolor="#ffffff">
    <td align="center" width="20%"><font size="-1">Questionnaire title</font></td>
    <td align=left><input name="voteTitle" type="text" size="56" maxlength="255" onKeypress="if(event.keyCode==32||(event.keyCode>=34&&event.keyCode<=39)||event.keyCode==42||event.keyCode==47||(event.keyCode>=58&&event.keyCode<=63)||event.keyCode==92||event.keyCode==94||event.keyCode==43) event.returnValue = false;">
    <font color=red size=-1><br>*Use a word greater than or equal to 13 words less than or equal to 24 words to describe the questionnaire</font></td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center"><font size="-1">Survey notes</font></td>
    <td align=left><textarea name="voteDescription" cols="50" rows="5" maxlength="255" wrap="physical" class="textarea"></textarea>
    <font color=red size=-1>*No more than 255 words, will be displayed as user visible</font></td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center"><font size="-1">Start time</font></td>
    <td align=left><input name="startDate" value="<%=(new java.sql.Timestamp(System.currentTimeMillis()).toString()).substring(0,19)%>" type="text" size="19" maxlength="19" onKeypress="if (!((event.keyCode >= 48 && event.keyCode <= 58)||(event.keyCode == 45)||(event.keyCode == 32)))event.returnValue = false;">
    <font color=red size=-1>*Please follow the example format exactly£º2008-08-08 08:08:08</font>
    </td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center"><font size="-1">End Time</font></td>
    <td align=left><input name="endDate" type="text" size="19" maxlength="19" onKeypress="if (!((event.keyCode >= 48 && event.keyCode <= 58)||(event.keyCode == 45)||(event.keyCode == 32)))event.returnValue = false;">
    <font color=red size=-1>*Please follow the example format exactly£º2008-08-08 08:08:08</font>
    </td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center"><font size="-1">Remarks</font></td>
    <td align=left>
    <textarea name="comments" cols="80" rows="5" wrap="physical" class="textarea"></textarea><br>
	 </td>
</tr>

 <tr bgcolor="#ffffff">

    <td align="center" colspan=2><input type="submit" value="Create a questionnaire" style="height:20px">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="reset" value="fill in again" style="height:20px"></td>

</tr> 

     
 </table>
</td></tr>
</table>
</form>
<p>
