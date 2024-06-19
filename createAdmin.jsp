<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,java.io.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create New Admin Account</title>
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
            background-image: url('https://64.media.tumblr.com/be9e196e0e59b345a49575020cef444b/4e9537cad97cbf25-b2/s640x960/5a63b0bfd6967ff590fbd06aa905acfba619cfdb.gifv');
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
    <h1>Create New Admin Account</h1>
    <label for="adminusername">Admin Username:</label>
    <input type="text" id="adminusername" name="adminusername" placeholder="Enter admin username" required>
    <label for="email">Email:</label>
    <input type="text" id="email" name="email" placeholder="Enter email" required>
    <label for="adminpassword">Password:</label>
    <input type="password" id="adminpassword" name="adminpassword" placeholder="Enter password" required>
    <%-- Java code for handling form submission and user creation --%>
    <%
        String url = "jdbc:mysql://localhost:3306/game";
        String dbUsername = "root";
        String dbPassword = ""; // Set this to your MySQL password

        String newAdminUsername = request.getParameter("adminusername");
        String newEmail = request.getParameter("email");
        String newAdminPassword = request.getParameter("adminpassword");

        String message = "";

        if (newAdminUsername != null && !newAdminUsername.isEmpty() && newEmail != null && !newEmail.isEmpty() && newAdminPassword != null && !newAdminPassword.isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(url, dbUsername, dbPassword);

                // Using parameterized query to prevent SQL injection
                String insertAdminSQL = "INSERT INTO admin (adminusername, email, adminpassword) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(insertAdminSQL);
                pstmt.setString(1, newAdminUsername);
                pstmt.setString(2, newEmail);
                pstmt.setString(3, newAdminPassword); // Ideally, hash the password before storing

                int rows = pstmt.executeUpdate();

                if (rows > 0) {
                    response.sendRedirect("adminLogin.jsp"); // Redirect to admin login page
                } else {
                    message = "Failed to create admin.";
                }
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                message = "Error: " + e.getMessage();
            } finally {
                try {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } else if (newAdminUsername != null || newEmail != null || newAdminPassword != null) {
            message = "All fields are required.";
        }
    %>
    <% if (!message.isEmpty()) { %>
        <p class="error-message"><%= message %></p>
    <% } %>
    <div class="buttons">
        <button type="submit">Create</button>
        <button type="button" onclick="location.href='adminLogin.jsp'">Cancel</button>
    </div>
</form>
</body>
</html>
