<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile – EventHorizon</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <div class="hamburger"><span></span><span></span><span></span></div>
    <ul class="navbar-links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="event?action=list">Events</a></li>
        <li><a href="booking?action=myBookings">My Bookings</a></li>
        <li><a href="profile.jsp" class="active">Profile</a></li>
        <li><a href="user?action=logout" class="btn-nav">Logout</a></li>
    </ul>
</nav>

<div class="container" style="max-width:600px;padding-top:40px;padding-bottom:60px;">
    <h1 class="page-title" style="margin-bottom:32px;">👤 My Profile</h1>

    <% if ("updated".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success" data-auto-dismiss>✅ Profile updated successfully!</div>
    <% } %>
    <% if ("updateFailed".equals(request.getParameter("error"))) { %>
        <div class="alert alert-danger" data-auto-dismiss>❌ Update failed. Please try again.</div>
    <% } %>

    <!-- Profile card -->
    <div style="background:var(--bg-card);border:1px solid var(--border);border-radius:16px;padding:32px;">
        <!-- Avatar -->
        <div style="text-align:center;margin-bottom:28px;">
            <div style="width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,var(--accent-purple),var(--accent-teal));display:inline-flex;align-items:center;justify-content:center;font-size:2rem;margin-bottom:12px;">
                👤
            </div>
            <div style="font-size:1.1rem;font-weight:700;">${sessionScope.userName}</div>
            <div style="color:var(--text-muted);font-size:0.85rem;">${sessionScope.userEmail}</div>
            <span class="badge badge-purple" style="margin-top:6px;">${sessionScope.role}</span>
        </div>

        <form action="user" method="post" class="needs-validation">
            <input type="hidden" name="action" value="update">

            <div class="form-group">
                <label class="form-label" for="name">Full Name</label>
                <input type="text" id="name" name="name"
                       class="form-control" value="${sessionScope.userName}" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone"
                       class="form-control" placeholder="07X XXX XXXX" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">New Password</label>
                <input type="password" id="password" name="password"
                       class="form-control" placeholder="Leave blank to keep current" >
            </div>

            <button type="submit" class="btn btn-primary btn-block">
                💾 Save Changes
            </button>
        </form>
    </div>

    <div style="text-align:center;margin-top:24px;">
        <a href="booking?action=myBookings" class="btn btn-outline">
            🎟️ View My Bookings
        </a>
    </div>
</div>

<footer class="footer">
    <div class="footer-brand">⬡ EVENTHORIZON</div>
    <p>SE1020 – Object Oriented Programming Project &copy; 2026</p>
</footer>

<script src="js/main.js"></script>
</body>
</html>
