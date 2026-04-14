<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.User" %>

<!DOCTYPE html>
<html>
<head>
    <title>Users - EventHorizon</title>
    <link rel="stylesheet" href="../css/admin.css">
</head>

<body class="admin-body">

<div class="layout">

    <!-- Sidebar -->
    <aside class="sidebar">
        <h2 class="logo">EVENTHORIZON</h2>

        <nav>
            <a href="dashboard.jsp">Dashboard</a>
            <a class="active">Users</a>
            <a href="../event?action=list">Events</a>
            <a href="../booking?action=list">Bookings</a>
            <a href="../user?action=listAdminRequests">Admin Requests</a>
        </nav>

        <form action="../user" method="post">
            <input type="hidden" name="action" value="logout"/>
            <button class="logout-btn">Logout</button>
        </form>
    </aside>

    <!-- Main -->
    <main class="main">

        <h1 class="page-title">Users</h1>

        <div class="card">
            <table class="modern-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                </tr>
                </thead>

                <tbody>
                <%
                    List<User> users = (List<User>) request.getAttribute("users");
                    if (users != null) {
                        for (User u : users) {
                %>
                <tr>
                    <td><%= u.getUserId() %></td>
                    <td><%= u.getName() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getPhone() %></td>
                    <td>
                        <span class="badge <%= u.getRole() %>">
                            <%= u.getRole() %>
                        </span>
                    </td>
                </tr>
                <% }} %>
                </tbody>
            </table>
        </div>

    </main>
</div>

</body>
</html>