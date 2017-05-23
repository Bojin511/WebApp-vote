

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<td>
<b><%= title %></b>
</td>
<td align="right">
    <font size="-1">
<%  for (int i=0; i<breadcrumbs.length-1; i++) { %>
    <a href="<%= breadcrumbs[i][1] %>"><%= breadcrumbs[i][0] %></a>

    &gt;
<%
    }
%>
<%= breadcrumbs[breadcrumbs.length-1][0] %>
    </font>
</td>
</table>
<hr size="0">