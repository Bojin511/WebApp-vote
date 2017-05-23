<%@ page contentType="text/html; charset=gb2312" pageEncoding="gb2312"%>

<%@ page import="jsp.oracle.bean.AdminUser"%>

<%//Controls access to users
	AdminUser adminUser = (AdminUser) session.getAttribute("adminUser");
	if(adminUser!=null&&adminUser.getUserRank()!=1)
	{%>
    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="You do not have permission to access this page!"/>
    </jsp:forward>
<%}%>

<%@ include file="global.jsp" %>
<html>
<head>
<title>Survey questionnaire management system</title>
<%@ include file="global.css" %>
<script language="javascript">
function checkForm()
{
	if(Form.userName.value == ""||Form.userName.value.replace(/(^\s*)|(\s*$)/g, "")=="")
	{
		alert("Username can not be empty!");
		Form.userName.focus();
		return false;
	}
	if(Form.userRank.value == "-1")
	{
		alert("Please select user level!");
		Form.userRank.focus();
		return false;
	}
	if(Form.userNewPwd.value == "")
	{
		alert("password can not be blank!");
		Form.userNewPwd.focus();
		return false;
	}
	if(Form.userNewPwd.value.length < 6)
	{
		alert("Password length is illegal!");
		Form.userNewPwd.focus();
		return false;
	}	
	if(Form.userNewPwd1.value == "")
	{
		alert("Password confirmation can not be empty!");
		Form.userNewPwd1.focus();
		return false;
	}
	if(Form.userNewPwd1.value.length < 6)
	{
		alert("Password confirmation length is illegal!");
		Form.userNewPwd1.focus();
		return false;
	}
	if(Form.userNewPwd.value != Form.userNewPwd1.value)
	{
		alert("Input error: password and password confirmation is inconsistent!");
		Form.userNewPwd.focus();
		return false;
	}
	
	return true;
}
</script>
</head>
<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc">

<%  // Title of this page and breadcrumbs
    String title = "Add user";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {title, "createAdminUser.jsp"}
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

<form action="SYSTEMADMIN" method="post" name="Form" target="_self" onSubmit="return checkForm();">
<input type=hidden name=cmd value="createAdminUser">
<table align=center bgcolor="#999999" cellpadding="0" cellspacing="0" border="0" width="60%">
<tr><td>
<table bgcolor="#999999" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td align="center" colspan=2 nowrap><font size="-1" face="verdana"><b>Add user</b></font></td>
</tr>
        <tr bgcolor="#ffffff">
          <td align="center"><font size="-1">Administrator password</font></TD>
          <TD><input type=password name="userPwd" maxlength="20" size="20">
          <font size="-1">please enter your password</font>&nbsp;<font color=red size=-1>*</font>
          </TD></TR>
        <tr bgcolor="#ffffff">
          <td align="center" width="20%"><font size="-1">User ID</font></TD>
          <TD align=left><input type=text name="userName" maxlength="50" size="20">
       <font size="-1">Supports English letters, numbers and Chinese characters</font>&nbsp;<font color=red size=-1>*</font></TD></TR>
        <tr bgcolor="#ffffff">
          <td align="center"><font size="-1">user level</font></TD>
          <TD>
          <select name=userRank>
          <option value="-1" selected>Please select the user level</option>
          <option value="0">General user</option>
          <option value="1">System administrator</option>
          </select>
          <font size="-1">General users need to apply for the questionnaire</font>&nbsp;<font color=red size=-1>*</font>
          </TD></TR>
        <tr bgcolor="#ffffff">
          <td align="center"><font size="-1">user password</font></TD>
          <TD><input type=password name="userNewPwd" maxlength="20" size="20">
          <font size="-1">The password length can not be less than 6</font>&nbsp;<font color=red size=-1>*</font>
          </TD></TR>
        <tr bgcolor="#ffffff">
          <td align="center"><font size="-1">Password Confirmation</font></TD>
          <TD><input type=password name="userNewPwd1" maxlength="20" size="20">
            <font size="-1">And then enter the password you fill in</font>&nbsp;<font color=red size=-1>*</font></TD></TR>
<tr bgcolor="#ffffff">

    <td align="center" colspan=2><input type="submit" value="Add to" style="height:20px">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="reset" value="fill in again" style="height:20px"></td>

</tr> 
 </table>
</td></tr>
</table>
</form>
<p>
