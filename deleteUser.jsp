<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.servlet.http.*,javax.servlet.*"%>
<%
    // Check if the admin is logged in
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("adminUsername") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    String userId = request.getParameter("userId");
    String url = "jdbc:mysql://localhost:3306/game";
    String dbUsername = "root";
    String dbPassword = ""; // Set this to your MySQL password

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        String deleteQuery = "DELETE FROM users WHERE user_id=?";
        pstmt = conn.prepareStatement(deleteQuery);
        pstmt.setInt(1, Integer.parseInt(userId));
        pstmt.executeUpdate();

        response.sendRedirect("adminDashboard.jsp");
        return;
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
%>
