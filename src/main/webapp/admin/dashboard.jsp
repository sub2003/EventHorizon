<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String userName = currentSession != null ? (String) currentSession.getAttribute("userName") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - EventHorizon</title>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; background: #f4f6f9; }
        .header { background: #1f2937; color: white; padding: 20px 30px; }
        .header h1 { margin: 0; font-size: 28px; }
        .header p { margin: 6px 0 0; font-size: 14px; color: #d1d5db; }
        .container { width: 90%; max-width: 1100px; margin: 30px auto; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; }
        .card { background: white; border-radius: 12px; padding: 22px; box-shadow: 0 0 12px rgba(0,0,0,0.08); }
        .card h3 { margin-top: 0; color: #222; }
        .card p { color: #555; min-height: 48px; }
        .card a {
            display: inline-block; margin-top: 12px; text-decoration: none;
            background: #007bff; color: white; padding: 10px 14px; border-radius: 6px;
        }
        .card a:hover { background: #0056b3; }
        .logout { margin-top: 30px; text-align: center; }
        .logout a {
            text-decoration: none; color: white; background: #dc3545;
            padding: 12px 18px; border-radius: 6px;
        }
        .logout a:hover { background: #b02a37; }
    </style>
</head>
<body>

<div class="header">
    <h1>Admin Dashboard</h1>
    <p>Welcome, <%= userName != null ? userName : "Admin" %></p>
</div>

<div class="container">
    <div class="grid">

        <div class="card">
            <h3>Manage Users</h3>
            <p>View all users, including customers and admins, and manage user records.</p>
            <a href="<%= request.getContextPath() %>/user?action=list">Open Users</a>
        </div>

        <div class="card">
            <h3>Request New Admin</h3>
            <p>Create a new admin request. Another admin must approve it before the admin account is created.</p>
            <a href="<%= request.getContextPath() %>/user?action=addAdminForm">Open Request Form</a>
        </div>

        <div class="card">
            <h3>Pending Admin Requests</h3>
            <p>Review pending admin requests and approve or reject them.</p>
            <a href="<%= request.getContextPath() %>/user?action=listAdminRequests">View Requests</a>
        </div>

        <div class="card">
            <h3>Manage Events</h3>
            <p>View, add, edit, and manage events in the system.</p>
            <a href="<%= request.getContextPath() %>/admin/events.jsp">Open Events</a>
        </div>

        <div class="card">
            <h3>Add Event</h3>
            <p>Create a brand-new event for customers to browse and book.</p>
            <a href="<%= request.getContextPath() %>/admin/addEvent.jsp">Add Event</a>
        </div>

        <div class="card">
            <h3>Bookings</h3>
            <p>View and manage booking records made by customers.</p>
            <a href="<%= request.getContextPath() %>/admin/bookings.jsp">Open Bookings</a>
        </div>

    </div>

    <div class="logout">
        <a href="<%= request.getContextPath() %>/user?action=logout">Logout</a>
    </div>
</div>

</body>
</html>