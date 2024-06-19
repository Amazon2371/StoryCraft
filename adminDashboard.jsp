<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.io.*,java.util.*,javax.servlet.http.*,javax.servlet.*"%>
<%
    // Check if the admin is logged in
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("adminUsername") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f4;
            background-image: url('https://64.media.tumblr.com/a98bc710b6f5bc7aebb47b3049d7adf8/2f374d07287b003b-d5/s640x960/e4715b3a6cb2fac95a5032f193d4dec02d82d478.gifv');
            background-size: cover;
            background-position: top;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px 0;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        .search-container {
            width: 80%;
            margin: 20px 0;
        }

        .search-container input[type="text"] {
            width: calc(100% - 110px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .search-container button[type="submit"] {
            width: 100px;
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

        .search-container button[type="submit"]:hover {
            background-color: #fff;
            color: #333;
        }

        .logout-container {
            width: 80%;
            display: flex;
            justify-content: flex-end;
            margin: 20px 0;
        }

        .logout-container button[type="button"] {
            background-color: #f44336;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .logout-container button[type="button"]:hover {
            background-color: #fff;
            color: #333;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .action-buttons button {
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .action-buttons .edit-btn {
            background-color: #FFA500;
            color: white;
        }

        .action-buttons .delete-btn {
            background-color: #FF0000;
            color: white;
        }

        .action-buttons .change-pass-btn {
            background-color: #0000FF;
            color: white;
        }

        .action-buttons button:hover {
            background-color: #fff;
            color: #333;
        }
    </style>
    <script>
        // Prevent back navigation after logout
        window.history.pushState(null, "", window.location.href);
        window.onpopstate = function() {
            window.history.pushState(null, "", window.location.href);
        };
    </script>
</head>
<body>
<h1>Admin Dashboard</h1>
<div class="search-container">
    <form method="post">
        <input type="text" name="search" placeholder="Search by username or email">
        <button type="submit">Search</button>
    </form>
</div>
<table>
    <tr>
        <th>User ID</th>
        <th>Username</th>
        <th>Email</th>
        <th>Password</th>
        <th>Actions</th>
    </tr>
    <%-- Java code to fetch and display user accounts --%>
    <%
        String url = "jdbc:mysql://localhost:3306/game";
        String dbUsername = "root";
        String dbPassword = ""; // Set this to your MySQL password

        String search = request.getParameter("search");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

            String query = "SELECT user_id, username, email, password FROM users";

            if (search != null && !search.isEmpty()) {
                query += " WHERE username LIKE ? OR email LIKE ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, "%" + search + "%");
                pstmt.setString(2, "%" + search + "%");
            } else {
                pstmt = conn.prepareStatement(query);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                int userId = rs.getInt("user_id");
                String username = rs.getString("username");
                String email = rs.getString("email");
                String password = rs.getString("password");
    %>
    <tr>
        <td><%= userId %></td>
        <td><%= username %></td>
        <td><%= email %></td>
        <td><%= password %></td>
        <td class="action-buttons">
            <button class="edit-btn" onclick="location.href='editUser.jsp?userId=<%= userId %>'">Edit</button>
            <button class="delete-btn" onclick="location.href='deleteUser.jsp?userId=<%= userId %>'">Delete</button>
            <button class="change-pass-btn" onclick="location.href='changePassword.jsp?userId=<%= userId %>'">Change Password</button>
        </td>
    </tr>
    <% 
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
    %>
        <tr>
            <td colspan="5" class="error-message"><%= "Error: " + e.getMessage() %></td>
        </tr>
    <%
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    %>
</table>
<div class="logout-container">
    <form method="post" action="logout.jsp">
        <button type="button" onclick="location.href='logout.jsp'">Logout</button>
    </form>
</div>
</body>
</html>
