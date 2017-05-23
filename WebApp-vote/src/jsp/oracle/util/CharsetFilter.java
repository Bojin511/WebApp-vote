package jsp.oracle.util; 

import javax.servlet.*;
import java.io.IOException; 

public class CharsetFilter implements Filter { 
protected String encoding = null; 
protected FilterConfig filterConfig = null; 

protected boolean ignore = true; 
public void destroy() { 

this.encoding = null;
this.filterConfig = null; 

} 

public void doFilter(ServletRequest request, ServletResponse response,
FilterChain chain)
throws IOException, ServletException { 
if (ignore || (request.getCharacterEncoding() == null)) {
String encoding = selectEncoding(request);
if (encoding != null)
request.setCharacterEncoding(encoding);
}
//System.out.println("Perform a code conversion!"+encoding);
chain.doFilter(request, response); 

} 

public void init(FilterConfig filterConfig) throws ServletException { 

this.filterConfig = filterConfig;
this.encoding = filterConfig.getInitParameter("encoding");
String value = filterConfig.getInitParameter("ignore");
if (value == null)
this.ignore = true;
else if (value.equalsIgnoreCase("true"))
this.ignore = true;
else if (value.equalsIgnoreCase("yes"))
this.ignore = true;
else
this.ignore = false; 
}
protected String selectEncoding(ServletRequest request) {
return (this.encoding); 
} 
} 