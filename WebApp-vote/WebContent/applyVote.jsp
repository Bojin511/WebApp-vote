<%@ page contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%request.setCharacterEncoding("gb2312");%>
<%response.setContentType("text/html; charset=gbk");%>

<%@ page import="jsp.oracle.bean.AdminUser"%>
<%@ page import="java.util.Vector"%>

<html>
<head>
<title>Survey questionnaire management system</title>
<%@ include file="global.css" %>
</head>

<%@ include file="global.jsp" %>
<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc" <%= onload %>>
<p>

<% 
    String title = "Apply for survey questionnaire management";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {title, "applyVote.jsp"}
    };
%>
<%@ include file="title.jsp" %>
<%
	AdminUser adminUser = (AdminUser)session.getAttribute("adminUser");
	if(adminUser != null)
	{
%>
<p>&nbsp;</p>
<form action="SYSTEMADMIN" name="ApplyVoteForm" method="post">
<input type="hidden" name="cmd" value="applyVote">
<table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="50%" align="center">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td height="34" align="center" nowrap><font size="-1" face="verdana"><b>Application for questionnaire management</b></font></td>
</tr>
<tr bgcolor="#ffffff">
    <td height="30" align="center" nowrap><font size="-1" face="verdana"><b>user<font color="#FF0000"><%=adminUser.getUserName()%></font>,Hello!<p>Are you going to apply for a questionnaire management authority <p> Are you sure?</b></font></td>
</tr>
<tr bgcolor="eeeeee">
	<td height="34" align="center" nowrap>
<input type="submit" value='确定' style='width:60px;height:20px;background:#f6f6f9 ;border:solid 1px #5589AA;' name="submit"> &nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" value='取消' style='width:60px;height:20px;background:#f6f6f9 ;border:solid 1px #5589AA;' name="quxiao" onClick="window.location.href='main.jsp'">
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