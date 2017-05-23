<%@ page contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%request.setCharacterEncoding("gb2312");%>
<%response.setContentType("text/html; charset=gbk");%>

<%@ page import="jsp.oracle.bean.Vote"%>
<%@ page import="jsp.oracle.bean.AdminUser"%>
<%@ page import="java.util.Vector"%>

<%//Controls access to users
	AdminUser adminUser = (AdminUser) session.getAttribute("adminUser");
	if(adminUser==null)
	{%>

    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="You are not logged in!"/>
    </jsp:forward>
    <%}
	else if(adminUser.getUserRank()!=1)
	{%>

    <jsp:forward page="error.jsp">
    <jsp:param name="msg" value="You do not have permission to access this page!"/>
    </jsp:forward>
<%}%>

<%@ include file="global.jsp" %>
<%--Important attributes on this page are voteType, pagerows, respectively, that show the type of questionnaire, each page shows the number of questionnaires,

Session storage
--%>


<html>
<head>
<title>Survey questionnaire management system</title>
<%@ include file="global.css" %>
</head>
<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#0000ff" alink="#6699cc"<%= onload %>>

<% 
    String title = "All survey questionnaire management";
    String[][] breadcrumbs = {
        {"home page", "main.jsp"},
        {title, "allVote.jsp"}
    };
    
    
    
String [] subtitle={"All current questionnaires","All unpublished questionnaires were issued","All historical questionnaires","All questionnaires"};
    
String [] status={"processing","Unpublished","over"};
 
int voteType=0;//Show the type of questionnaire

if((String)session.getAttribute("voteType")!=null)//Check whether there is a set of questionnaires in the session
voteType=Integer.parseInt((String)session.getAttribute("voteType"));//If there is a session in the value of the session
  String t = request.getParameter ("voteType");
if(t!=null)
{
voteType=Integer.parseInt(t);//Change the category to user settings
session.setAttribute("voteType",t);//Change the type of questionnaire in the session
} 

  
  int pagerows=20;//Number of questionnaires displayed per page

if((String)session.getAttribute("pagerows")!=null)//Check whether there are set pages in the session
pagerows=Integer.parseInt((String)session.getAttribute("pagerows"));//If there is a session in the value of the session

String prows=request.getParameter("pagerows");//Requests the number of pages set by the user
if(prows!=null) //If the user has set (change)
{
pagerows=Integer.parseInt(prows);//Change the number of pages to the user settings
session.setAttribute("pagerows",prows);//Change the number of pages in the session
}


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
<div align=right>

<SELECT onChange="javascript:window.location='allVote.jsp?voteType='+this.options[this.selectedIndex].value;" size=1 name=voteType>
<option value="-1" selected>==Please select the type of survey questionnaire==</option>
<option value="0">&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;All current questionnaires</option>
<option value="1">&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;All unpublished questionnaires were issued</option>
<option value="2">&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;All historical questionnaires</option>
<option value="3">&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;All questionnaires</option>
		</select>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<form name=pageset action="allVote.jsp" method=post><font size=-1>Every page shows</font>
<input type=text size=1 maxlength=3 name=pagerows value=<%=pagerows%> onkeyup="value=value.replace(/[^\d]/g,'')" style="height:20px"><font size=-1>&nbsp;Questionnaires</font>&nbsp;&nbsp;
<input type=submit value="设定" style="height:20px" title="设定">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</form>

</div>
<p></p>
<table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="98%" align="center">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee"><%--Questionnaire type subtitle--%>
    <td colspan=8 align="center" nowrap><font size="3" face="verdana"><b><%=subtitle[voteType]%></b></font>

    </td>
</tr>
<tr bgcolor="#eeeeee">
    <td align="center" width="5%"><font size="2" face="verdana"><b>ID</b></font></td>
    <td align="center" width="12%"><font size="2" face="verdana"><b>Start time</b></font></td>
    <td align="center" width="12%"><font size="2" face="verdana"><b>End Time</b></font></td>
    <td align="center" width="35%"><font size="2" face="verdana"><b>Questionnaire title (click preview effect)</b></font></td>
    <td align="center" width="12%"><font size="2" face="verdana"><b>founder</b></font></td>
    <td align="center" width="8%"><font size="2" face="verdana"><b>status</b></font></td>  
    <td align="center" width="8%"><font size="2" face="verdana"><b>edit</b></font></td>
    <td align="center" width="8%"><font size="2" face="verdana"><b>View Results</b></font></td>
</tr>
<%
	Vote vote=new Vote();
	Vector voteVector = new Vector();		
	switch(voteType)
	{
	case 1:
	voteVector = vote.getUnvalidVote(); break;//Not yet published questionnaires
	case 2:
	voteVector = vote.getOldVote(); break;//History of the questionnaire
	case 3:
	voteVector = vote.getAllVote(); break;//All questionnaires
	default:
	voteVector = vote.getCurrentVote(); break;//Current questionnaire
	}
	
	//voteVector = vote.getAllVote();
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
if(voteVector!=null) allrows=voteVector.size();
    
pagecount=(allrows+pagerows-1)/pagerows;
if(pagecount==0) pageid=0;
if(pageid>pagecount) pageid=pagecount;
if(pagecount>0&&pageid<=0) pageid=1;	

if(pageid<pagecount&&pageid>0){
        for(int i=0; i<pagerows;i++)
        {
        Vote tempVote=(Vote)voteVector.get(pagerows*(pageid-1)+i);
          %>

<tr bgcolor="#ffffff">
    <td align="center"><font size="-1"><%=pagerows*(pageid-1)+i+1%></font></td>
    <td align="center"><font size="-1"><%=tempVote.getStartTime().substring(0,10)%></font></td>
    <td align="center"><font size="-1"><%=tempVote.getEndTime().substring(0,10)%></font></td>
    <td align="center"><font size="-1"><a href="viewVote.jsp?voteId=<%=tempVote.getVoteId()%>">
 <%
if(tempVote.getVoteTitle().length()>18)
{
%>
<%=tempVote.getVoteTitle().substring(0,18)%>...<%}
else {%>
<%=tempVote.getVoteTitle()%> <%}%></a></font></td>
	<td align="center"><font size="-1"><%=tempVote.getCreateUser()%></font></td>
    <td align="center"><font size="-1"><%=status[tempVote.getVoteStatus()]%></font></td>		
    <td align="center">
    <%if(tempVote.getVoteStatus()==2){%><font size=-1>shut down</font>
    <%}else{%><a href="editVote.jsp?voteId=<%=tempVote.getVoteId() %>">
	<img src="images/button_edit.gif" width="17" height="17" alt="Edit the contents of the questionnaire ..." border="0"></a>
	<%}%></td>
    <td align="center"><a href="viewVoteResult.jsp?voteId=<%=tempVote.getVoteId()%>">
	<font size=-1>View Results</font>
	</a>
	</td>
</tr>

<% 
}}
else if(pageid==pagecount&&pageid>0)
{
for(int i=0; i<voteVector.size()-pagerows*(pagecount-1);i++)
        {
        Vote tempVote=(Vote)voteVector.get(pagerows*(pageid-1)+i);
          %>
<tr bgcolor="#ffffff">
    <td align="center"><font size="-1"><%=pagerows*(pageid-1)+i+1%></font></td>
    <td align="center"><font size="-1"><%=tempVote.getStartTime().substring(0,10)%></font></td>
    <td align="center"><font size="-1"><%=tempVote.getEndTime().substring(0,10)%></font></td>
    <td align="center"><font size="-1"><a href="viewVote.jsp?voteId=<%=tempVote.getVoteId()%>">
 <%
if(tempVote.getVoteTitle().length()>18)
{
%>
<%=tempVote.getVoteTitle().substring(0,18)%>...<%}
else {%>
<%=tempVote.getVoteTitle()%> <%}%></a></font></td>
	<td align="center"><font size="-1"><%=tempVote.getCreateUser()%></font></td>
    <td align="center"><font size="-1"><%=status[tempVote.getVoteStatus()]%></font></td>		
    <td align="center">
    <%if(tempVote.getVoteStatus()==2){%><font size=-1>shut down</font>
    <%}else{%><a href="editVote.jsp?voteId=<%=tempVote.getVoteId() %>">
	<img src="images/button_edit.gif" width="17" height="17" alt="Edit the contents of the questionnaire ..." border="0"></a>
	<%}%></td>
    <td align="center"><a href="viewVoteResult.jsp?voteId=<%=tempVote.getVoteId()%>">
	<font size=-1>View Results</font>
	</a>
	</td>
</tr>
<% 
}}
%>	

<tr bgcolor="#eeeeee">
<td align="right" colspan="8"><font size="-1">
Every page shows<font color=blue> <b><%=pagerows%></b> </font>Questionnaire, In total<font color=blue> <b><%=allrows%></b> </font>Questionnaires&nbsp;&nbsp;<br>
current page:<font color=blue><b><%=pageid%></b> </font>/<font color=blue> <b><%=pagecount%></b> </font>
      <%if(pageid>1){%>
      <a href="allVote.jsp?pageid=<%=pageid-1%>">Previous page</a> 
      <%}%>
      <%if(pageid<pagecount){ %>
      <a href="allVote.jsp?pageid=<%=pageid+1%>">Next page</a> 
      <%}%>
&nbsp;turn to number<SELECT onChange="javascript:window.location='allVote.jsp?pageid='+this.options[this.selectedIndex].value;" size=1 name=page>
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
<p></p>
<div align=right>

<SELECT onChange="javascript:window.location='allVote.jsp?voteType='+this.options[this.selectedIndex].value;" size=1 name=voteType>
<option value="-1" selected>==Please select the type of survey questionnaire==</option>
<option value="0">&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;All current questionnaires</option>
<option value="1">&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;All unpublished questionnaires were issued</option>
<option value="2">&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;All historical questionnaires</option>
<option value="3">&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;All questionnaires</option>
		</select>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
</div>
</body>
</html>