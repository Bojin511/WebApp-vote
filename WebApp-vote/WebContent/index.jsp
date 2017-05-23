<%@ page contentType="text/html; charset=gbk"
    pageEncoding="gbk"%>

<%		
    // Check to see if we've already logged into this tool.
	String adminLogin = (String)session.getAttribute("adminLogin");
	if (adminLogin == null||adminLogin.equals("")) {
		response.sendRedirect("login.jsp");
	}
%>

<html>
<head>
<title>Survey questionnaire management system</title>
</head>

	<frameset cols="175,*" bordercolor="#0099cc" border="0" frameborder="0" style="background-color:#0099cc">
		<frame src="left.jsp" name="sidebar" scrolling="auto" marginheight="0" marginwidth="0" noresize>
		<frameset rows="*" bordercolor="#0099cc" border="0" frameborder="0" style="background-color:#0099cc">
			<frame src="main.jsp" name="main" scrolling="auto" noresize>
		</frameset>
	</frameset>


</html>


