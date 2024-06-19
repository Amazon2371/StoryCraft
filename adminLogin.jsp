<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,java.io.*,java.util.*,javax.servlet.http.*,javax.servlet.*"%>
<%
    // Check if the admin is already logged in
    HttpSession currentSession = request.getSession(false);
    if (currentSession != null && currentSession.getAttribute("adminUsername") != null) {
        response.sendRedirect("adminDashboard.jsp");
        return;
    }
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
   response.setHeader("Pragma", "no-cache"); // HTTP 1.0
   response.setDateHeader("Expires", 0); // Proxies
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f4;
            background-image: url('https://i.pinimg.com/originals/52/c6/f7/52c6f70459d1c0f5fb0fd7fecabe87f4.gif');
            background-size: cover;
            background-position: top;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        form {
            width: 300px;
            padding: 30px;
            background-color: #fff;
            background-color: rgba(255, 255, 255, 0.3);
            border-radius: 10px;
            backdrop-filter: blur(2px);
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .buttons {
            display: flex;
            justify-content: space-between;
            margin: 8px 0;
        }

        button[type="submit"],
        button[type="button"] {
            width: 48%;
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        button[type="submit"]:hover,
        button[type="button"]:hover {
            background-color: #fff;
            color: #333;
        }

        h1 {
            text-align: center;
            margin: 0;
            padding-bottom: 20px;
        }

        .error-message {
            color: red;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
<form method="post">
    <h1>Admin Login</h1>
    <label for="identifier">Email or Username:</label>
    <input type="text" id="identifier" name="identifier" placeholder="Enter email or username" required>
    <label for="adminpassword">Password:</label>
    <input type="password" id="adminpassword" name="adminpassword" placeholder="Enter password" required>
    <%-- Java code for handling login --%>
    <%
        String url = "jdbc:mysql://localhost:3306/game";
        String dbUsername = "root";
        String dbPassword = ""; // Set this to your MySQL password

        String identifier = request.getParameter("identifier");
        String adminPassword = request.getParameter("adminpassword");

        String message = "";

        if (identifier != null && !identifier.isEmpty() && adminPassword != null && !adminPassword.isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(url, dbUsername, dbPassword);

                // Using parameterized query to prevent SQL injection
                String loginSQL = "SELECT * FROM admin WHERE (adminusername = ? OR email = ?) AND adminpassword = ?";
                pstmt = conn.prepareStatement(loginSQL);
                pstmt.setString(1, identifier);
                pstmt.setString(2, identifier);
                pstmt.setString(3, adminPassword);

                rs = pstmt.executeQuery();

                if (rs.next()) {
                    HttpSession newSession = request.getSession();
                    newSession.setAttribute("adminUsername", rs.getString("adminusername"));
                    response.sendRedirect("adminDashboard.jsp"); // Redirect to admin dashboard
                } else {
                    message = "Invalid email/username or password.";
                }
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                message = "Error: " + e.getMessage();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } else if (identifier != null || adminPassword != null) {
            message = "All fields are required.";
        }
    %>
    <% if (!message.isEmpty()) { %>
        <p class="error-message"><%= message %></p>
    <% } %>
    <div class="buttons">
        <button type="submit">Login</button>
        <button type="button" onclick="location.href='createAdmin.jsp'">Sign up</button>
    </div>
</form>
</body>
</html>
