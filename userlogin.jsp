<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,java.io.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Login</title>
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
            background-image: url('https://i.pinimg.com/originals/87/ee/68/87ee686ee81f2d80c84c6b8712cfc2a7.gif');
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

        .show-password {
            margin-top: 10px;
        }

        h1 {
            text-align: center;
            margin: 0;
            padding-bottom: 20px;
        }

        input[type="checkbox"] {
            transform: scale(0.9);
            padding: 0;
            margin-top: 1px;
            vertical-align: top;
            width: auto;
            height: auto;
        }

        .place {
            float: right;
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
    <h1>Login</h1>
    <label for="identifier">Username:</label>
    <input type="text" id="identifier" name="identifier" placeholder="Enter your username" required>
    <label for="password">Password:</label>
    <div>
        <input type="password" id="password" name="password" placeholder="Enter your password" required>
        <div class="place">
            <label for="showPassword">
                <input type="checkbox" id="showPassword" class="show-password">Show Password
            </label>
        </div>
    </div>
    <%-- Java code for handling form submission and validation --%>
    <%
        String url = "jdbc:mysql://localhost:3306/game";
        String dbUsername = "root";
        String dbPassword = ""; // Set this to your MySQL password

        String inputUsername = request.getParameter("identifier");
        String inputPassword = request.getParameter("password");

        String message = "";

        if (inputUsername != null && !inputUsername.isEmpty() && inputPassword != null && !inputPassword.isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(url, dbUsername, dbPassword);

                String checkUserSQL = "SELECT * FROM users WHERE username = ? AND password = ?";
                pstmt = conn.prepareStatement(checkUserSQL);
                pstmt.setString(1, inputUsername);
                pstmt.setString(2, inputPassword);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    // Redirect to home page after successful login
                    session.setAttribute("user_id", rs.getInt("user_id"));
                    session.setAttribute("username", rs.getString("username"));
                    response.sendRedirect("menu.jsp");
                } else {
                    message = "Incorrect username, email, or password. Please try again.";
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
        } else if (inputUsername != null || inputPassword != null) {
            message = "Username/Email and password are required.";
        }
    %>
    <% if (!message.isEmpty()) { %>
        <p class="error-message"><%= message %></p>
    <% } %>
    <div class="buttons">
        <button type="submit">Login</button>
        <a href="usersignup.jsp">Sign Up</a>
    </div>
</form>

<script>
    document.getElementById("showPassword").addEventListener("change", function() {
        var passwordInput = document.getElementById("password");
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
        } else {
            passwordInput.type = "password";
        }
    });
</script>
</body>
</html>
