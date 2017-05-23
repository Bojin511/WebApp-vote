<%@ page contentType="text/html; charset=gbk"
    pageEncoding="gbk"%>

<%@ page import="jsp.oracle.bean.AdminUser"%>


<html>
<head>
	<title>Check the questionnaire management system administrator login</title>
<script language="javascript">
function checkLoginForm()
{
if(LoginForm.userName.value=="")
{
alert("Username can not be empty!");
LoginForm.userName.focus();
return false;
}
if(LoginForm.userPwd.value=="")
{
alert("password can not be blank!");
LoginForm.userPwd.focus();
return false;
}
return true;
}
</script>
</head>

<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#800080" alink="#ff0000">

<form action="SYSTEMADMIN" name="LoginForm" method="post">
<input type="hidden" name="cmd" value="adminUserLogin">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<td width="49%"><br></td>
<td width="2%">
	<noscript>
	<table border="0" cellspacing="0" cellpadding="0">
	<td class="error">
        <font size="-1" color="#ff0000">
        <b>error:</b> JavaScript is not available. This tool uses JavaScript and if JavaScript is not available, most of its functionality will not work properly. Please open JavaScript and refresh this page.
        </font>
	</td>
	</table>
	<br><br><br><br>
	</noscript>


    <p>
    <table cellpadding="1" cellspacing="0" border="0" bgcolor="#999999">
	<tr><td>
    <table cellpadding="2" cellspacing="0" border="0" bgcolor="#eeeeee">
	<tr><td colspan="2"><img src="images/blank.gif" width="1" height="5" border="0"></td></tr>
	<tr>
		<td align="right" nowrap><font size="-1" face="arial,helvetica,sans-serif">username &nbsp;</font></td>
		<td><input type="text" name="userName" size="15" maxlength="25"></td>
	</tr>
	<tr><td colspan="2"><img src="images/blank.gif" width="230" height="5" border="0"></td></tr>
	<tr>
		<td align="right" nowrap><font size="-1" face="arial,helvetica,sans-serif">Password &nbsp;</font></td>
		<td><input type="password" name="userPwd" size="15" maxlength="20"></td>
	</tr>
	<tr><td colspan="2"><img src="images/blank.gif" width="1" height="5" border="0"></td></tr>
	<tr>
		<td colspan="2" align="center">
			<input onClick="return checkLoginForm();" type="submit" value="&nbsp login&nbsp;">
			<p>
			<font size="2" face="verdana,arial,helvetica">
			<b>Survey questionnaire management system</b>
			</font>
		</td>
	</tr>
	<tr><td colspan="2"><img src="images/blank.gif" width="1" height="5" border="0"></td></tr>
    </table>
    </td></tr>
    </table>
</td>
<td width="49%"><br></td>
</table>

</form>



</body>
</html>

