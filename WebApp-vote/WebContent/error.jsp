<%@ page contentType="text/html; charset=gbk"
    pageEncoding="gbk"%>
<html>
<head>
<title>Survey questionnaire management system</title>
</head>
<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc">


<p>
<p>

 <%

	String msg = request.getParameter("msg") ;%>
	
            <div align="center">
            Survey Questionnaire System Information:<p>
            
            <span><%=msg%></span> 
<br><br>
<input type='button' value='Return retry' style='width:80px;height:18px;background:#f6f6f9 ;border:solid 1px #5589AA;' onclick='window.history.go(-1);'>¡¡¡¡<input type='button' value='System home page' style='width:80px;height:18px;background:#f6f6f9 ;border:solid 1px #5589AA;' onclick="window.location.href='main.jsp'"> </div>

         




</body>
</html>
