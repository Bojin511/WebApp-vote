<%@ page contentType="text/html; charset=gb2312" pageEncoding="gb2312"%>
<%@ page import="jsp.oracle.bean.AdminUser"%>
<%@ page import="java.util.Vector"%>

<%@ include file="global.jsp" %>
<%
String aId=request.getParameter("userName");
    if(aId==null)
{
%>    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="Do not specify the necessary parameters, the operation can not be implemented!"/>
    </jsp:forward>
<%}
AdminUser admin=new AdminUser();
admin.setUserName(aId);
admin=admin.getAdminUserByUserName();

%>
<html>
<head>
<title>Survey questionnaire management system</title>
<%@ include file="global.css" %>
<script language="javascript">
function checkForm()
{
	if(Form.userNewPwd.value == "")
	{
		alert("New password can not be empty!");
		Form.userNewPwd.focus();
		return false;
	}
	if(Form.userNewPwd.value.length < 6)
	{
		alert("New password length is illegal!");
		Form.userNewPwd.focus();
		return false;
	}	
	if(Form.userNewPwd1.value == "")
	{
		alert("New password confirmation can not be empty!");
		Form.userNewPwd1.focus();
		return false;
	}
	if(Form.userNewPwd1.value.length < 6)
	{
		alert("New password confirmation length is illegal!");
		Form.userNewPwd1.focus();
		return false;
	}
	if(Form.userNewPwd.value != Form.userNewPwd1.value)
	{
		alert("Input error: new password and new password confirmation is inconsistent!");
		Form.userNewPwd.focus();
		return false;
	}
	if(Form.rank.value == "-1")
	{
		alert("Please select the permissions of the new administrator!");
		Form.rank.focus();
		return false;
	}
	
	return true;
}
</script>

</head>
<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc">




<%  // Title of this page and breadcrumbs
    String title = "Modify the user";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {title, "editAdminUser.jsp"}
    };
    String[] status={"General user","System administrator"};
  
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


<table align=center bgcolor="#999999" cellpadding="0" cellspacing="0" border="0" width="60%">
<tr><td>
<table bgcolor="#999999" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">

    <td align="center" colspan=2 nowrap><font size="-1" face="verdana"><b>Modify the user</b></font></td>
</tr>
<form action="SYSTEMADMIN?userName=<%=admin.getUserName()%>" method="post" name="Form" target="_self" onSubmit="return checkForm();">
<input type=hidden name=cmd value="editAdminUserPwd">
		  <tr bgcolor="#ffffff">
          <td align="center" width="20%"><font size="-1">User ID</font></TD>
          <TD align=left>&nbsp;<font size="-1"><%=admin.getUserName()%></font></TD></TR>

		  <tr bgcolor="#ffffff">
          <td align="center" width="20%"><font size="-1">user level</font></TD>
          <TD align=left>&nbsp;<font size="-1"><%= status[admin.getUserRank()] %></font></TD></TR>

        <tr bgcolor="#ffffff">
          <td align="center"><font size="-1">password</font></TD>
          <TD><input type=password name="userNewPwd" maxlength="20" size="20">
          <font size="-1">The password length can not be less than 6</font>&nbsp;<font color=red size=-1>*</font>
          </TD></TR>
        <tr bgcolor="#ffffff">
          <td align="center"><font size="-1">Password Confirmation</font></TD>
          <TD><input type=password name="userNewPwd1" maxlength="20" size="20">
            <font size="-1">Please enter the password you filled in again</font>&nbsp;<font color=red size=-1>*</font></TD></TR>
<tr bgcolor="#eeeeee">
    <td align="center" colspan=2><input type="submit" value="change Password" style="height:20px">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="reset" value="fill in again" style="height:20px"></td>
</tr> </form>         
 </table>
</td></tr>
</table>
</form>
<p>
