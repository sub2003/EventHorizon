<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.AdminRequest" %>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Requests</title>
    <link rel="stylesheet" href="../css/admin.css">
</head>

<body class="admin-body">

<div class="layout">

    <aside class="sidebar">
        <h2 class="logo">EVENTHORIZON</h2>

        <nav>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="users.jsp">Users</a>
            <a href="../event?action=list">Events</a>
            <a href="../booking?action=list">Bookings</a>
            <a class="active">Admin Requests</a>
        </nav>
    </aside>

    <main class="main">

        <h1 class="page-title">Admin Requests</h1>

        <div class="card">
            <table class="modern-table">

                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Time</th>
                    <th>Action</th>
                </tr>
                </thead>

                <tbody>
                <%
                    List<AdminRequest> list = (List<AdminRequest>) request.getAttribute("adminRequests");
                    if (list != null) {
                        for (AdminRequest r : list) {
                %>
                <tr>
                    <td><%= r.getRequestId() %></td>
                    <td><%= r.getName() %></td>
                    <td><%= r.getEmail() %></td>
                    <td><%= r.getPhone() %></td>
                    <td><%= r.getRequestedAt() %></td>

                    <td>
                        <a href="../user?action=approveAdmin&id=<%= r.getRequestId() %>"
                           class="btn-success">Approve</a>

                        <a href="../user?action=rejectAdmin&id=<%= r.getRequestId() %>"
                           class="btn-danger">Reject</a>
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