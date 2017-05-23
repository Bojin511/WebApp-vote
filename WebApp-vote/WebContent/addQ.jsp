<%@ page contentType="text/html; charset=gbk" pageEncoding="gbk"%>

<%@ page import="jsp.oracle.bean.Question,jsp.oracle.bean.Vote,
                  jsp.oracle.bean.AdminUser,
                  jsp.oracle.util.ParseString,
                  java.util.Vector"
    errorPage="error.jsp"
%>
<%//Controls access to users
	AdminUser adminUser = (AdminUser) session.getAttribute("adminUser");
	if(adminUser==null)
	{%>

    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="You are not logged in!"/>
    </jsp:forward>
<%
	}
    String vId=request.getParameter("voteId");
    if(vId==null)
    {%>
    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="Do not specify the necessary parameters, the operation can not be implemented!"/>
    </jsp:forward>
    <%}
    int voteId=Integer.parseInt(vId);
 	int rank=adminUser.getUserRank();
	int flag=0;//To determine whether the average user has the authority to modify the questionnaire to add the problem
    String userVote=adminUser.getUserVote();
    ParseString votes=new ParseString(userVote,"\\|");
    Vector voteVector=votes.getStringVector();
    if(voteVector!=null&&voteVector.indexOf(String.valueOf(voteId))!=-1)//If the voteId is owned by the user
    flag=1;//You can modify the questionnaire
	if(flag!=1&&rank!=1)
	 {%>
    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="You do not have permission to add a question to this questionnaire!"/>
    </jsp:forward>
    <%}
    
    Vote vote=new Vote();
    vote.setVoteId(voteId);
    vote=vote.getVoteByVoteId();

%>

<%@ include file="global.jsp" %>

<html>
<head>
<title>Survey questionnaire management system</title>
<%@ include file="global.css" %>
<script language = "JavaScript">
var StraddItem="";
var ItemNo=1;

function CheckForm()
{

	if (document.myform.questionTitle.value=="")
	{
		alert("The title of the question can not be empty!");
		document.myform.questionTitle.focus();
		return false;
	}
	if (document.myform.questionTitle.value.length>255)
	{
		alert("Sorry, the question title is too long, please give a brief description!");
		document.myform.questionTitle.focus();
		return false;
	}
	return true;  
}
</script>
</head>
<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc"<%= onload %>>

<%  // Title of this page and breadcrumbs
    String title = "Add a question";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {"My questionnaire", "userVote.jsp"},
        {title, "addQ.jsp"}
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

<form action="VOTEADMIN?voteId=<%=voteId%>" method="post" name="myform" target="_self" onSubmit="return CheckForm();">
<input type=hidden name=operation value="addQuestion">
<table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">

    <td align="center" colspan=2 nowrap><font size="-1" face="verdana"><b>Add a question</b></font></td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center" width=30%><font size="-1">Questionnaire title</font></td>
    <td align=left><font size="-1"><%=vote.getVoteTitle()%></font></td>
</tr>
<tr bgcolor="#ffffff">
    <td align="center"><font size="-1">Problem description</font></td>
    <td align=left><input name="questionTitle" type="text" size="70" maxlength="255">
    <font color=red size=-1>*</font></td>
</tr>

<tr bgcolor="#ffffff">
    <td align="center"><font size="-1">Problem options</font></td>
    <td align=left>
<DIV id="mybag0" ALIGN="CENTER">
</DIV>
<DIV ALIGN="CENTER">
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="1">
<tr>
<td colspan="16" align="center">
<input name="cmdAddItm" type="button" onclick="AddItm();" value="Add an option" style="height:20px">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input name="cmdDelItm" type="button" onclick="DelItm();" value="Delete an option" style="height:20px">
<script language = "JavaScript">
function AddItm()
{
var mybag="Mybag"+(ItemNo-1); 
StraddItem="<table id=TblItm"+ItemNo+" WIDTH=100% BORDER=0 CELLSPACING=1 CELLPADDING=1 BORDERCOLOR=red><tr colspan=3 height=1 align=center><td align=left width=10%><font size=-1 color=blue>选项 <b>"+ItemNo+"</b></font></td><td align=left><INPUT TYPE=text size=60 name=answers class=text onKeypress=\"if(event.keyCode==34) event.returnValue = false;\"></td><td align=right><font size=-1>选中删除:</font><INPUT TYPE=CHECKBOX name=chkAppIt"+ ItemNo +" value=Y></td></tr></table><div id=mybag"+ItemNo+" ></div>";
document.all(mybag).innerHTML=StraddItem;
ItemNo++;
}

function DelItm()
{
var i;
var bSel;
var strURL;

for(i=1;i<ItemNo;i++)
{
chkAppItx="chkAppIt"+i;
TblItmx="TblItm"+i;
if (document.all(chkAppItx).checked==true)
{document.all(TblItmx).style.display="none";
document.all(chkAppItx).value=1;
bSel=true;
}
}

if (bSel != true) {alert("Please select the option you want to delete first!");return false;}
else {return true;}
}

</script></td>
</tr>
</TABLE>
</DIV>
<br>
</td>
</tr>
<tr bgcolor="#ffffff">
    <td colspan=2 align="center"><input type="submit" value="Add a question" style="height:20px">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="reset" value="fill in again" style="height:20px"></td>
</tr> 
 </table>
</td></tr>
</table>
</form>
<p>
