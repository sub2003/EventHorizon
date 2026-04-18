<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String role = (String) session.getAttribute("role");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile – EventHorizon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <div class="hamburger"><span></span><span></span><span></span></div>

    <ul class="navbar-links">
        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/event?action=list">Events</a></li>

        <% if ("CUSTOMER".equals(role)) { %>
            <li><a href="${pageContext.request.contextPath}/booking?action=myBookings">My Bookings</a></li>
        <% } %>

        <% if ("ADMIN".equals(role)) { %>
            <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a></li>
        <% } %>

        <li><a href="${pageContext.request.contextPath}/profile.jsp" class="active">Profile</a></li>
        <li><a href="${pageContext.request.contextPath}/user?action=logout" class="btn-nav">Logout</a></li>
    </ul>
</nav>

<div class="container" style="max-width:700px;padding-top:40px;padding-bottom:60px;">
    <h1 class="page-title" style="margin-bottom:32px;">👤 My Profile</h1>

    <c:if test="${param.msg == 'updated'}">
        <div class="alert alert-success" data-auto-dismiss>
            ✅ Profile updated successfully.
        </div>
    </c:if>

    <c:if test="${param.error == 'updateFailed'}">
        <div class="alert alert-danger" data-auto-dismiss>
            ❌ Update failed. Please try again.
        </div>
    </c:if>

    <c:if test="${param.error == 'deleteFailed'}">
        <div class="alert alert-danger" data-auto-dismiss>
            ❌ Account deletion failed. Please try again.
        </div>
    </c:if>

    <c:if test="${param.error == 'notAllowed'}">
        <div class="alert alert-danger" data-auto-dismiss>
            ❌ You are not allowed to perform that action.
        </div>
    </c:if>

    <div style="background:var(--bg-card);border:1px solid var(--border);border-radius:16px;padding:32px;">
        <div style="text-align:center;margin-bottom:28px;">
            <div style="width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,var(--accent-purple),var(--accent-teal));display:inline-flex;align-items:center;justify-content:center;font-size:2rem;margin-bottom:12px;">
                👤
            </div>

            <div style="font-size:1.1rem;font-weight:700;">
                ${sessionScope.userName}
            </div>

            <div style="color:var(--text-muted);font-size:0.85rem;">
                ${sessionScope.userEmail}
            </div>

            <span class="badge badge-purple" style="margin-top:6px;">
                ${sessionScope.role}
            </span>
        </div>

        <form action="${pageContext.request.contextPath}/user" method="post" class="needs-validation">
            <input type="hidden" name="action" value="update">

            <div class="form-group">
                <label class="form-label" for="name">Full Name</label>
                <input type="text"
                       id="name"
                       name="name"
                       class="form-control"
                       value="${sessionScope.userName}"
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="phone">Phone Number</label>
                <input type="tel"
                       id="phone"
                       name="phone"
                       class="form-control"
                       value="${sessionScope.userPhone}"
                       placeholder="07X XXX XXXX"
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">New Password</label>
                <input type="password"
                       id="password"
                       name="password"
                       class="form-control"
                       placeholder="Enter a new password">
            </div>

            <button type="submit" class="btn btn-primary btn-block">
                💾 Save Changes
            </button>
        </form>
    </div>

    <% if ("CUSTOMER".equals(role)) { %>
    <div style="margin-top:24px;background:rgba(220,53,69,0.08);border:1px solid rgba(220,53,69,0.25);border-radius:16px;padding:24px;">
        <h3 style="margin:0 0 10px 0;color:#dc3545;">⚠ Delete My Account</h3>
        <p style="margin:0 0 18px 0;color:var(--text-muted);line-height:1.6;">
            This action is permanent. Your account and related booking records may be removed and cannot be recovered.
        </p>

        <form action="${pageContext.request.contextPath}/user" method="post"
              onsubmit="return confirm('Are you sure you want to delete your account? This action cannot be undone.');">
            <input type="hidden" name="action" value="selfDelete">

            <button type="submit"
                    class="btn"
                    style="background:#dc3545;color:#ffffff;border:none;padding:12px 22px;border-radius:10px;font-weight:700;cursor:pointer;">
                🗑 Delete My Account
            </button>
        </form>
    </div>
    <% } %>

    <div style="text-align:center;margin-top:24px;">
        <% if ("CUSTOMER".equals(role)) { %>
            <a href="${pageContext.request.contextPath}/booking?action=myBookings" class="btn btn-outline">
                🎟️ View My Bookings
            </a>
        <% } else if ("ADMIN".equals(role)) { %>
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-outline">
                🛠 Go to Dashboard
            </a>
        <% } %>
    </div>
</div>

<footer class="footer">
    <div class="footer-brand">⬡ EVENTHORIZON</div>
    <p>SE1020 – Object Oriented Programming Project &copy; 2026</p>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>