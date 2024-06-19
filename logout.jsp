<%@page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    // Invalidate the session
    HttpSession currentSession = request.getSession(false);
    if (currentSession != null) {
        currentSession.invalidate();
    }
    // Redirect to the admin login page
    response.sendRedirect("adminLogin.jsp");
%>
