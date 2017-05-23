<%@ page contentType="text/html; charset=gb2312" pageEncoding="gb2312"%>
<%request.setCharacterEncoding("gb2312");%>

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

<%@ include file="global.jsp" %>
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc" >
<p>

<% 
    String title = "User overview";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {title, "adminUsers.jsp"}
    };
    String[] status={"General user","System administrator"};
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
 int pagerows=20;//The number of users per page

if((String)session.getAttribute("pagerows")!=null)//See if there is a set number of pages in the session
pagerows=Integer.parseInt((String)session.getAttribute("pagerows"));//If there is a session in the value of the session

String prows=request.getParameter("pagerows");//Requests the user to set the number of page displays
if(prows!=null&&!prows.trim().equals("")&&!prows.trim().equals("0")) //If the user has set (change)
{
pagerows=Integer.parseInt(prows);//Change the page display to user settings
session.setAttribute("pagerows",prows);//Change the number of page displays in the session
}

%>
<div align=right>

<form name=pageset action="adminUsers.jsp" method=post><font size=-1>Every page shows</font>
<input type=text size=1 maxlength=3 name=pagerows value=<%=pagerows%> onkeyup="value=value.replace(/[^\d]/g,'')" style="height:20px"><font size=-1>&nbsp;Users</font>&nbsp;&nbsp;
<input type=submit value="设定" style="height:20px" title="设定">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</form>
</div>

<table bgcolor="#999999" cellpadding="0" cellspacing="0" border="0" width="90%" align="center">
<tr><td>
<table bgcolor="#999999" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td align="center" width="7%"><font size="2" face="verdana"><b>ID</b></font></td>
    <td align="center" width="20%"><font size="2" face="verdana"><b>username</b></font></td>
    <td align="center" width="15%"><font size="2" face="verdana"><b>user level</b></font></td>
    <td align="center" width="8%"><font size="2" face="verdana"><b>edit</b></font></td>
</tr>
<%
AdminUser user=new AdminUser();
Vector userVector=new Vector();
userVector=user.getAllAdminUsers();

int pageid;


int allrows=0;
int pagecount=0;
String s=request.getParameter("pageid");
if(s==null)
{
 pageid=1;
 
 }
else 
{
pageid=Integer.parseInt(s);
}
if(userVector!=null) allrows=userVector.size();
    
pagecount=(allrows+pagerows-1)/pagerows;
if(pagecount==0) pageid=0;
if(pageid>pagecount) pageid=pagecount;
if(pagecount>0&&pageid<=0) pageid=1;	

if(pageid<pagecount&&pageid>0){
        for(int i=0; i<pagerows;i++)
        {
        AdminUser tempUser=(AdminUser)userVector.get(pagerows*(pageid-1)+i);
          %>

<tr bgcolor="#ffffff">
    <td align="center"><font size="-1"><%=pagerows*(pageid-1)+i+1%></font></td>
    <td align="center"><font size="-1"><%=tempUser.getUserName()%></font></td>
	<td align="center"><font size="-1"><%= status[tempUser.getUserRank()] %></font></td>	
    <td align="center"><a href="editAdminUser.jsp?userName=<%=tempUser.getUserName()%>">
	<img src="images/button_edit.gif" width="17" height="17" alt="Edit user attributes ..." border="0"></a>
	</td>
</tr>
<% 
}}
else if(pageid==pagecount&&pageid>0)
{
for(int i=0; i<userVector.size()-pagerows*(pagecount-1);i++)
        {
        AdminUser tempUser=(AdminUser)userVector.get(pagerows*(pageid-1)+i);
          %>
<tr bgcolor="#ffffff">
    <td align="center"><font size="-1"><%=pagerows*(pageid-1)+i+1%></font></td>
    <td align="center"><font size="-1"><%=tempUser.getUserName()%></font></td>
	<td align="center"><font size="-1"><%= status[tempUser.getUserRank()] %></font></td>	
    <td align="center"><a href="editAdminUser.jsp?userName=<%=tempUser.getUserName()%>">
	<img src="images/button_edit.gif" width="17" height="17" alt="Edit user attributes ..." border="0"></a>
	</td>
</tr>
<% 
}}
%>	

<tr bgcolor="#eeeeee">
<td align="right" colspan="8"><font size="-1">
Every page shows<font color=blue> <b><%=pagerows%></b> </font>users, In total<font color=blue> <b><%=allrows%></b> </font>users&nbsp;&nbsp;<br>
current page:<font color=blue><b><%=pageid%></b> </font>/<font color=blue> <b><%=pagecount%></b> </font>
      <%if(pageid>1){%>
      <a href="adminUsers.jsp?pageid=<%=pageid-1%>">Previous page</a> 
      <%}%>
      <%if(pageid<pagecount){ %>
      <a href="adminUsers.jsp?pageid=<%=pageid+1%>">Next page</a> 
      <%}%>
&nbsp;turn to number<SELECT onChange="javascript:window.location='adminUsers.jsp?pageid='+this.options[this.selectedIndex].value;" size=1 name=page>
	<%	int p=1;
		while(p<=pagecount)
			{
			if(p==pageid)
			out.println("<option value="+p+" selected>"+p);
		else out.println("<option value="+p+">"+p);
		      p=p+1;
		    }%>
		</select>page&nbsp;&nbsp;
</font>

</td>
</tr>
			
</table>
</td></tr>
</table>

</body>
</html>