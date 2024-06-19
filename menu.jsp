<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
    // Retrieve username from the session
    HttpSession userSession = request.getSession(false);
    String username = (String) session.getAttribute("username");

    if (username == null) {
        // If the username is not in session, redirect to login page
        response.sendRedirect("userlogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Menu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff;
            color: #333;
            text-align: center;
        }
        .content {
            margin: 20px auto;
            padding: 20px;
            background-color: #e6e6fa;
            border-radius: 10px;
            width: 300px;
        }
        h1 {
            color: #4b0082;
        }
        form {
            margin-top: 20px;
        }
        select, input[type="submit"] {
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            display: block;
            width: 100%;
        }
    </style>
</head>
<body>
    <h1>Main Menu</h1>
    <section class="home" id="page-home">
        <div class="content">
            <h1>Welcome, <%= username %>!</h1>
            <form method="post" action="sci_fi_adventure.jsp">
                <label for="genre">Choose a genre:</label>
                <select id="genre" name="genre">
                    <option value="sci_fi_adventure">Sci-fi</option>
                </select>
                <input type="submit" value="Start Game">
            </form>
        </div>
    </section>
</body>
</html>
