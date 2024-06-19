<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.io.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Signup</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-image: url('https://i.pinimg.com/originals/b6/73/97/b6739785948f04018cb3efaac3eb8630.gif');
            background-size: cover;
            background-position: top;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        .signup-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
        }

        .signup-form {
            margin-bottom: 20px;
        }

        .signup-form label {
            display: block;
            margin-bottom: 5px;
        }

        .signup-form input[type="text"],
        .signup-form input[type="email"],
        .signup-form input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .signup-form input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .signup-form input[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <h2>User Signup</h2>
        <form class="signup-form" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <%
                // Define your database connection details
                String url = "jdbc:mysql://localhost:3306/game";
                String dbUsername = "root";
                String dbPassword = ""; // Set this to your MySQL password

                // Retrieve form data
                String inputUsername = request.getParameter("username");
                String inputEmail = request.getParameter("email");
                String inputPassword = request.getParameter("password");

                response.setContentType("text/html");

                if (inputUsername != null && !inputUsername.isEmpty() && inputEmail != null && !inputEmail.isEmpty() && inputPassword != null && !inputPassword.isEmpty()) {
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    try {
                        // Register JDBC driver
                        Class.forName("com.mysql.jdbc.Driver");

                        // Open a connection
                        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

                        // Prepare the SQL statement
                        String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, inputUsername);
                        pstmt.setString(2, inputEmail);
                        pstmt.setString(3, inputPassword);

                        // Execute the statement
                        int rowsInserted = pstmt.executeUpdate();

                        if (rowsInserted > 0) {
                            // Redirect to login page if insertion is successful
                            response.sendRedirect("userlogin.jsp");
                        } else {
                            // Display a message if no rows were inserted
                            out.println("<p>Error: No rows were inserted.</p>");
                        }
                    } catch (ClassNotFoundException | SQLException e) {
                        // Handle exceptions
                        e.printStackTrace();
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    } finally {
                        // Close resources in a finally block
                        try {
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        }
                    }
                } else {
                    // Display a message if any field is empty
                    out.println("<p>Please provide username, email, and password.</p>");
                }
            %>
            <input type="submit" value="Sign Up">
        </form>
    </div>
</body>
</html>
