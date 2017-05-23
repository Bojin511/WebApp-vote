


<%	// Security check
	String adminLogin = (String)session.getAttribute("adminLogin");

   	if(adminLogin==null||(adminLogin!=null&&!adminLogin.equals("true")))
	{
	 		response.sendRedirect("login.jsp");
	}
    
    String onload = "";


%>

<%! // Global vars/methods for the entire skin
    
    static final String tblBorderColor = "#999999";
    static final String errorColor = "#ff0000";
    static final String messageColor = "#006600";
    
%>