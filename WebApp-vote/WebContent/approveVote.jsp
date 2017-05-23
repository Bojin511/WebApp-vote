<%@ page contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%request.setCharacterEncoding("gb2312");%>
<%response.setContentType("text/html; charset=gbk");%>

<%@ page import="jsp.oracle.bean.AdminUser"%>
<%@ page import="java.util.Vector"%>

<%//Controls access to users
	AdminUser adminUser = (AdminUser) session.getAttribute("adminUser");
	if(adminUser!=null&&adminUser.getUserRank()!=1)
	{%>
    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="You do not have permission to access this page!"/>
    </jsp:forward>
<%}%>

<html>
<head>
<title>Survey questionnaire management system</title>
<%@ include file="global.css" %>
</head>

<%@ include file="global.jsp" %>
<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc" <%= onload %>>
<p>

<% 
    String title = "Approve the questionnaire application";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {title, "approveVote.jsp"}
    };
%>
<%@ include file="title.jsp" %>
<%
	String applicate = request.getParameter("applicate");
	adminUser = new AdminUser();
	adminUser.setUserName(applicate);
	adminUser = adminUser.getAdminUserByUserName();
	session.setAttribute("applicate",adminUser);
	if(adminUser != null)
	{
%>
<form action="SYSTEMADMIN" name="ApproveVoteForm" method="post">
<input type="hidden" name="cmd" value="approveVote">
<table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="50%" align="center">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td height="34" align="center" nowrap colspan="2"><font size="-1" face="verdana"><b>Application for questionnaire management</b></font></td>
</tr>
<tr bgcolor="#ffffff">
    <td height="30" align="center" nowrap><font size="-1" face="verdana"><b>Applicant account number</b></font></td>
	<td height="30" align="center" nowrap><font size="-1" face="verdana"><%=adminUser.getUserName()%></font></td>
</tr>
<tr bgcolor="#ffffff">
    <td height="30" align="center" nowrap><font size="-1" face="verdana"><b>Number of applications that have not been approved</b></font></td>
	<td height="30" align="center" nowrap><font size="-1" face="verdana"><%=adminUser.getApplyVote()%>&nbsp;次</font></td>
</tr>
<tr bgcolor="#ffffff">
    <td height="30" align="center" nowrap><font size="-1" face="verdana"><b>Approve the number of applications</b></font></td>
	<td height="30" align="center" nowrap><INPUT type="text" size=10 name="voteCount" value="1">&nbsp;次</td>
</tr>
<tr bgcolor="eeeeee">
	<td height="34" align="center" nowrap colspan="2">
<input type="submit" value='确定' style='width:60px;height:20px;background:#f6f6f9 ;border:solid 1px #5589AA;' name="submit" onclick="return checkApproveVoteform();"> &nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" value='取消' style='width:60px;height:20px;background:#f6f6f9 ;border:solid 1px #5589AA;' name="quxiao" onClick="window.location.href='viewVoteApplication.jsp'">
	</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
<%
	}
%>
</body>
</html>