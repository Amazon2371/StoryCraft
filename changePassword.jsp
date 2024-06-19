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

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String newPassword = request.getParameter("newPassword");

            String updateQuery = "UPDATE users SET password=? WHERE user_id=?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, newPassword);
            pstmt.setInt(2, Integer.parseInt(userId));
            pstmt.executeUpdate();

            response.sendRedirect("adminDashboard.jsp");
            return;
        }
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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }

        form {
            max-width: 400px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        label {
            display: block;
            margin-bottom: 8px;
        }

        input[type="password"] {
            width: calc(100% - 22px);
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button[type="submit"], .back-button {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        button[type="submit"]:hover, .back-button:hover {
            background-color: #fff;
            color: #333;
        }
        
        .back-button-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
        }

        .back-button {
            display: inline-block;
            text-align: center;
            margin-top: 20px;
            background-color: #4CAF50;
        }
    </style>
</head>
<body>
<h1>Change Password</h1>
<form method="post">
    <label for="newPassword">New Password:</label>
    <input type="password" id="newPassword" name="newPassword" required>
    <button type="submit">Change Password</button>
</form>
<div class="back-button-container">
    <a class="back-button" href="adminDashboard.jsp">Back to Admin Dashboard</a>
</div>
</body>
</html>
