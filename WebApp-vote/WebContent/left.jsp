<%@ page contentType="text/html; charset=gbk" pageEncoding="gbk"%>


<%@ page import="java.util.Vector,jsp.oracle.util.ParseString" %>
<%@ page import="jsp.oracle.bean.AdminUser,jsp.oracle.bean.Vote"
    errorPage="error.jsp"%>

<%@ include file="global.jsp" %>
<%	// Get parameters
	AdminUser adminUser = (AdminUser) session.getAttribute("adminUser");
	int rank=adminUser.getUserRank();
	String [] ranks={"General user","System administrator"};
%>

<html>
<head>
<title>Survey questionnaire management system</title>
<%@ include file="global.css" %>
</head>
<SCRIPT language=javascript1.2>
function showsubmenu(sid)
{
whichEl = eval("submenu" + sid);
if (whichEl.style.display == "none")
{
eval("submenu" + sid + ".style.display=\"\";");
}
else
{
eval("submenu" + sid + ".style.display=\"none\";");
}
}
</SCRIPT>
<body background="images/sidebar_back.gif" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc">

<img src="images/blank.gif" width="50" height="5" border="0"><br>

    <table cellpadding="2" cellspacing="0" border="0" width="100%">
    
    
    <tr><td rowspan="99" width="1%">&nbsp;</td>
        <td colspan="3" width="99%"><font size="-1"><b>Current user</b></font></td>
    </tr>
    <tr><td width="1%">&nbsp;</td>
        <td width="1%">&#149;</td><%--用户名--%>
        <td width="97%"><font size="-1"><%=adminUser.getUserName()%></font></td>
    </tr>  
    <tr><td width="1%">&nbsp;</td>
        <td width="1%">&#149;</td><%--用户等级--%>
        <td width="97%"><font size="-1"><%=ranks[adminUser.getUserRank()]%></font></td>
    </tr>
<%
if(rank==0)
{%>    
    <tr><td width="1%">&nbsp;</td>
        <td width="1%">&#149;</td><%--The number of questionnaires to be approved by the user--%>
        <td width="97%"><font size="-1">Apply<%=adminUser.getApplyVote()%>Questionnaire management</font></td>
    </tr>
    <tr><td width="1%">&nbsp;</td>
        <td width="1%">&#149;</td><%--Number of questionnaires approved by the user--%>
        <td width="97%"><font size="-1">Approved<%=adminUser.getVotePower()%>Questionnaire management</font></td>
    </tr>    
    <%}%>
    <tr><td width="1%">&nbsp;</td>
        <td width="1%">&#149;</td>
        <td width="97%"><font size="-1"><a href="modifyPwd.jsp" target="main">change Password</a></font></td>
    </tr>
<%
if(rank==0)
{%>    
    <tr><td>&nbsp;</td>
        <td>&#149;</td>
        <td><font size="-1"><a href="applyVote.jsp" target="main">Apply for survey questionnaire management</a></font></td>
    </tr>
    <%}%>  
    <tr><td>&nbsp;</td>
        <td>&#149;</td>
        <td><font size="-1"><a href="SYSTEMADMIN?cmd=adminUserLogout" target="main">Log out of the user</a></font></td>
    </tr>    
	  <tr><td rowspan="99" width="1%">&nbsp;</td>
    </table>

<%

Vote vote=new Vote();
Vector voteVector=vote.getCurrentVote();
if(voteVector!=null&&voteVector.size()!=0)
{
%>

    <table cellpadding="2" cellspacing="0" border="0" width="100%">
    <tr><td rowspan="99" width="1%">&nbsp;</td>
        <td colspan="3"><font size="-1"><b>Current questionnaire</b></font></td>
    </tr>
    </table>
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    
<%
for(int i=0;i<voteVector.size();i++)
	{
	vote=(Vote)voteVector.get(i);
%>
    <tr><td>&nbsp;</td>
        <td>&#149;</td>
        <td><font size="-1"><a href="vote.jsp?voteId=<%=vote.getVoteId()%>" target="main"><%if(vote.getVoteTitle().length()>10){%><%=vote.getVoteTitle().substring(0,10)%>...<%}else{%><%=vote.getVoteTitle()%><%}%></a></font></td>
    </tr>
<%}%>
	  <tr><td rowspan="99" width="1%">&nbsp;</td>

    </table>


<%

}
	if(rank == 1)
	{
	%>

    <table cellpadding="2" cellspacing="0" border="0" width="100%">
    <tr><td rowspan="99" width="1%">&nbsp;</td>
        <td colspan="3"><font size="-1"><b>User Management</b></font></td>
    </tr>
    <tr><td>&nbsp;</td>
        <td>&#149;</td>
        <td><font size="-1"><a href="viewVoteApplication.jsp" target="main">Latest survey questionnaire application</a></font></td>
    </tr>
    <tr><td>&nbsp;</td>
        <td>&#149;</td>
        <td><font size="-1"><a href="adminUsers.jsp" target="main">User overview</a></font></td>
    </tr>  

    <tr><td>&nbsp;</td>
        <td>&#149;</td>
        <td><font size="-1"><a href="createAdminUser.jsp" target="main">Create a user</a></font></td>
    </tr>
	  <tr><td rowspan="99" width="1%">&nbsp;</td>

    </table>

<%
	}
	
    int flag=0;//To determine whether the average user has the authority to create a questionnaire
    
    String userVote=adminUser.getUserVote();
    ParseString votes=new ParseString(userVote,"\\|");
    voteVector=votes.getStringVector();
    int voteNum=0;
    if(voteVector!=null&&voteVector.size()!=0)
    voteNum=voteVector.size();//The number of questionnaires that the user has created
    int votePower=adminUser.getVotePower();

   if((voteVector!=null&&votePower>voteVector.size())||(voteVector==null&&votePower>0))
    {
     //If the user's votePower value is greater than the number of questionnaires currently available
    flag=1;//You can create a questionnaire
    }
    
    if(rank==1||flag==1||voteNum>0)	
	{
	%>

    <table cellpadding="2" cellspacing="0" border="0" width="100%">
    <tr><td rowspan="99" width="1%">&nbsp;</td>
        <td colspan="3" width="99%"><font size="-1"><b>Questionnaire management</b></font></td>
    </tr><%--The survey manager can see his own, the system administrator--%>
<%
}
    
    if(rank==1||flag==1)
    {%>
    <tr><td width="1%">&nbsp;</td>
        <td width="1%">&#149;</td>
        <td width="97%"><font size="-1"><a href="createVote.jsp" target="main">Create a questionnaire</a></font></td>
    </tr>
 <%} 
 if(rank==1||voteNum>0)
    {%>
     <tr><td width="1%">&nbsp;</td>
        <td width="1%">&#149;</td>
        <td width="97%"><font size="-1"><a href="userVote.jsp" target="main">My questionnaire</a></font></td>
    </tr>
    <tr><td colspan=3>&nbsp;</td>
    </tr>
    <%}
    if(rank==1){%>	

	<tr><td width="1%">&nbsp;</td><!--System administrator-->
        <td width="1%">&#149;</td>
        <td width="97%"><font size="-1"><a href="allVote.jsp" target="main">All questionnaires</a></font></td>
    </tr>
<%  } %>
    </table>


<br><br>

</body>
</html>

