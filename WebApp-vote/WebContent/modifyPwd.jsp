<%@ page contentType="text/html; charset=gbk" pageEncoding="gbk"%>

<%@ page import="jsp.oracle.bean.AdminUser"%>
<%@ page import="jsp.oracle.servlet.AdminServlet"%>

<html>
<head>
<script language="javascript">
function checkModifyPwdForm()
{
	if(ModifyPwdForm.userPwd.value == "")
	{
		alert("The original password can not be empty!");
		ModifyPwdForm.userPwd.focus();
		return false;
	}
		if(ModifyPwdForm.userPwd.length < 6 || ModifyPwdForm.userPwd.length > 16)
	{
		alert("The original password input error: illegal password length!");
		ModifyPwdForm.userPwd.focus();
		return false;
	}
	if(ModifyPwdForm.userNewPwd.value == "")
	{
		alert("New password can not be empty!");
		ModifyPwdForm.userNewPwd.focus();
		return false;
	}
	if(ModifyPwdForm.userNewPwd.length < 6 || ModifyPwdForm.userNewPwd.length > 16)
	{
		alert("New password length is illegal!");
		ModifyPwdForm.userNewPwd.focus();
		return false;
	}	
	if(ModifyPwdForm.userNewPwd1.value == "")
	{
		alert("New password confirmation can not be empty!");
		ModifyPwdForm.userNewPwd.focus();
		return false;
	}
	if(ModifyPwdForm.userNewPwd1.length < 6 || ModifyPwdForm.userNewPwd1.length > 16)
	{
		alert("New password confirmation length is illegal!");
		ModifyPwdForm.userNewPwd.focus();
		return false;
	}
	if(ModifyPwdForm.userNewPwd.value != ModifyPwdForm.userNewPwd1.value)
	{
		alert("Input error: new password and password confirmation is inconsistent!");
		ModifyPwdForm.userNewPwd.focus();
		return false;
	}
	return true;
}
</script>
</head>

<%@ include file="global.jsp" %>
<body>
<p>

<% 
    String title = "change Password";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {title, "modifyPwd.jsp"}
    };
%>
<%@ include file="title.jsp" %>
<%	String message = (String)session.getAttribute("message");
    if (message != null) {
%>
	<font color=red size="-1"><b><%= message %></b></font>
    <p>
<%	
session.removeAttribute("message");
} %>


<form action="SYSTEMADMIN" name="ModifyPwdForm" method="post">
<input type="hidden" name="cmd" value="adminUserPwdModify">
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <p>&nbsp;  </p>
  <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="40%" align="center">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee" height="35">
<td align="center" nowrap="nowrap" colspan="2"><font size="3" face="verdana"><b>change&nbsp;password</b></font></td>
</tr>
<tr bgcolor="#ffffff" height="30">
    <td align="center" nowrap><font size="-1" face="verdana"><b>old password</b></font></td>
    <td align="center" nowrap><font size="-1" face="verdana"><input type="password" name="userPwd" size="30"></font></td>
</tr>
<tr bgcolor="#ffffff" height="30">
    <td align="center" nowrap><font size="-1" face="verdana"><b>new password</b></font></td>
    <td align="center" nowrap><font size="-1" face="verdana"><input type="password" name="userNewPwd" size="30"></font></td>
</tr>  
<tr bgcolor="#ffffff" height="30">
    <td align="center" nowrap><font size="-1" face="verdana"><b>New password confirmation</b></font></td>
    <td align="center" nowrap><font size="-1" face="verdana"><input type="password" name="userNewPwd1" size="30"></font></td>
</tr>   
<tr bgcolor="#eeeeee" align="center">
<td height="34" colspan="2">
<input type="submit" value='Modify' style='width:50px;height:18px;background:#f6f6f9 ;border:solid 1px #5589AA;' name="submit" onClick="return checkModifyPwdForm();"> &nbsp;&nbsp;&nbsp;&nbsp;
<input type="reset" value='Reset' style='width:50px;height:18px;background:#f6f6f9 ;border:solid 1px #5589AA;' name="reset">
</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
</body>
</html>