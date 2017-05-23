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
    String title = "View the latest survey application";
    String[][] breadcrumbs = {
        {"主页面", "main.jsp"},
        {title, "viewVoteApplication.jsp"}
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
<%
	String[] ranks={"General user","System administrator"};
	AdminUser adminUser1 = new AdminUser();
	Vector adminUserVector = adminUser1.getApplyVoteAdminUsers();
	if(adminUserVector==null || adminUserVector.size() == 0)
	{
%>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<center>
		<font size="3" face="verdana"><b>There are no new unapproved survey management applications!</b></font>
		</center>
<%
	}
	else
	{
%>
<p>&nbsp;</p>
<table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="100%" align="center">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td width="15%" height="34" align="center" nowrap><font size="3" face="verdana"><b>Applicant account number</b></font></td>
	<td width="14%" align="center" nowrap><font size="3" face="verdana"><b>user level</b></font></td>
	<td width="18%" align="center" nowrap><font size="3" face="verdana"><b>Number of unapproved</b></font></td>
	<td width="15%" align="center" nowrap><font size="3" face="verdana"><b>Approved application</b></font></td>
</tr>
<%
for(int i = 0; i < adminUserVector.size(); i++ )
{
	adminUser = (AdminUser)adminUserVector.get(i);
%>
<tr bgcolor="#ffffff">

 	<td height="30" align="center" nowrap><font size="-1" face="verdana"><%=adminUser.getUserName()%></font></td>
	<td align="center" nowrap><font size="-1" face="verdana"><%=ranks[adminUser.getUserRank()]%></font></td>
	<td width="18%" align="center" nowrap><font size="-1" face="verdana"><%=adminUser.getApplyVote()%>&nbsp;次</font></td>
	<td align="center" nowrap><font size="-1" face="verdana"><a href="approveVote.jsp?applicate=<%=adminUser.getUserName()%>"><img src="images/button_approve.gif" width="17" height="17" alt="批准申请" border="0"></a></font></td>

</tr>
<%
}
%>
</table>
</td>
</tr>
</table>
<%
	}
%>

</body>
</html>