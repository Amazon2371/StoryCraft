<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    Integer user_id = (Integer) session.getAttribute("user_id");
    String username = (String) session.getAttribute("username");

    if (user_id == null || username == null) {
        response.sendRedirect("userlogin.jsp");
        return;
    }

    String url = "jdbc:mysql://localhost:3306/game";
    String dbUsername = "root";
    String dbPassword = "";

    String action = request.getParameter("action");
    if (action != null) {
        try (Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword)) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            if ("save".equals(action)) {
                String slotNumber = request.getParameter("slot_number");
                String genre = request.getParameter("genre");
                String gameState = request.getParameter("game_state");

                String sql = "INSERT INTO Saves (user_id, slot_number, timestamp, genre, game_state) VALUES (?, ?, NOW(), ?, ?) " +
                             "ON DUPLICATE KEY UPDATE timestamp=VALUES(timestamp), genre=VALUES(genre), game_state=VALUES(game_state)";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, user_id);
                    pstmt.setInt(2, Integer.parseInt(slotNumber));
                    pstmt.setString(3, genre);
                    pstmt.setString(4, gameState);
                    pstmt.executeUpdate();
                }

            } else if ("load".equals(action)) {
                String slotNumber = request.getParameter("slot_number");
                String sql = "SELECT * FROM Saves WHERE user_id = ? AND slot_number = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, user_id);
                    pstmt.setInt(2, Integer.parseInt(slotNumber));
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            session.setAttribute("game_state", rs.getString("game_state"));
                            session.setAttribute("genre", rs.getString("genre"));
                            response.sendRedirect("sci_fi_adventure.jsp");
                            return;
                        } else {
                            out.println("<p>Error: Save slot not found.</p>");
                        }
                    }
                }

            } else if ("delete".equals(action)) {
                String slotNumber = request.getParameter("slot_number");
                String sql = "DELETE FROM Saves WHERE user_id = ? AND slot_number = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, user_id);
                    pstmt.setInt(2, Integer.parseInt(slotNumber));
                    pstmt.executeUpdate();
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Save/Load Game</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            color: #343a40;
            margin: 0;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #007bff;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid #dee2e6;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: #fff;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        form {
            display: inline-block;
            margin-right: 5px;
        }
        input[type="submit"] {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 12px;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
            border-radius: 5px;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h1>Save/Load Game</h1>
    <table>
        <tr>
            <th>Slot Number</th>
            <th>Actions</th>
            <th>Genre</th>
            <th>Game State</th>
            <th>Timestamp</th>
        </tr>
        <%
            try (Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword)) {
                Class.forName("com.mysql.cj.jdbc.Driver");

                String sql = "SELECT * FROM Saves WHERE user_id = ? ORDER BY slot_number";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, user_id);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        Map<Integer, Map<String, String>> saves = new HashMap<>();
                        while (rs.next()) {
                            Map<String, String> saveData = new HashMap<>();
                            saveData.put("genre", rs.getString("genre"));
                            saveData.put("game_state", rs.getString("game_state"));
                            saveData.put("timestamp", rs.getString("timestamp"));
                            saves.put(rs.getInt("slot_number"), saveData);
                        }

                        for (int i = 1; i <= 6; i++) {
                            Map<String, String> saveData = saves.get(i);
        %>
        <tr>
            <td><%= i %></td>
            <td>
                <form method="post">
                    <input type="hidden" name="slot_number" value="<%= i %>">
                    <input type="hidden" name="action" value="save">
                    <input type="hidden" name="genre" value="<%= saveData != null ? saveData.get("genre") : "Genre" %>">
                    <input type="hidden" name="game_state" value="<%= saveData != null ? saveData.get("game_state") : "" %>">
                    <input type="submit" value="Save">
                </form>
                <form method="post">
                    <input type="hidden" name="slot_number" value="<%= i %>">
                    <input type="hidden" name="action" value="load">
                    <input type="submit" value="Load">
                </form>
                <form method="post">
                    <input type="hidden" name="slot_number" value="<%= i %>">
                    <input type="hidden" name="action" value="delete">
                    <input type="submit" value="Delete">
                </form>
            </td>
            <td><%= saveData != null ? saveData.get("genre") : "" %></td>
            <td><%= saveData != null ? saveData.get("game_state") : "" %></td>
            <td><%= saveData != null ? saveData.get("timestamp") : "" %></td>
        </tr>
        <%
                        }
                    }
                }
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        %>
    </table>
</body>
</html>
