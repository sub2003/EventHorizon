<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhorizon.model.Admin" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String userName = currentSession != null ? (String) currentSession.getAttribute("userName") : null;
    String adminPermission = currentSession != null ? (String) currentSession.getAttribute("adminPermission") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (adminPermission == null || adminPermission.trim().isEmpty()) {
        adminPermission = Admin.FULL_ACCESS;
    }

    boolean canManageEvents = UserService.hasEventAccess(adminPermission);
    boolean canManageBookings = UserService.hasBookingAccess(adminPermission);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - EventHorizon</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="admin-shell">

    <aside class="sidebar">
        <div>
            <div class="brand">
                <div class="brand-icon">⬡</div>
                <div>
                    <h2>EVENTHORIZON</h2>
                    <p>Admin Workspace</p>
                </div>
            </div>

            <nav class="nav-links">
                <a class="active" href="<%= request.getContextPath() %>/admin/dashboard.jsp">
                    <i class="fa-solid fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>

                <a href="<%= request.getContextPath() %>/user?action=list">
                    <i class="fa-solid fa-users"></i>
                    <span>Manage Users</span>
                </a>

                <a href="<%= request.getContextPath() %>/user?action=addAdminForm">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Request New Admin</span>
                </a>

                <a href="<%= request.getContextPath() %>/user?action=listAdminRequests">
                    <i class="fa-solid fa-user-check"></i>
                    <span>Admin Requests</span>
                </a>

                <% if (canManageEvents) { %>
                <a href="<%= request.getContextPath() %>/event?action=adminList">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Manage Events</span>
                </a>
                <% } %>

                <% if (canManageBookings) { %>
                <a href="<%= request.getContextPath() %>/booking?action=allBookings">
                    <i class="fa-solid fa-ticket"></i>
                    <span>Bookings</span>
                </a>
                <% } %>
            </nav>
        </div>

        <div class="sidebar-footer">
            <div style="padding:12px 14px; margin-bottom:12px; border-radius:12px; background:rgba(255,255,255,0.04); color:#cbd5e1; font-size:0.9rem;">
                <div style="font-size:0.75rem; text-transform:uppercase; opacity:0.75; margin-bottom:4px;">Permission</div>
                <strong><%= UserService.permissionLabel(adminPermission) %></strong>
            </div>

            <a class="back-site" href="<%= request.getContextPath() %>/event?action=list">
                <i class="fa-solid fa-globe"></i>
                <span>Open Website</span>
            </a>

            <a class="logout-btn" href="<%= request.getContextPath() %>/user?action=logout">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <main class="main-content">
        <section class="topbar">
            <div>
                <p class="eyebrow">Administration</p>
                <h1>Dashboard</h1>
                <p class="subtitle">Welcome back, <strong><%= userName != null ? userName : "Admin" %></strong></p>
            </div>

            <div class="topbar-badge">
                <i class="fa-solid fa-shield-halved"></i>
                <span><%= UserService.permissionLabel(adminPermission) %></span>
            </div>
        </section>

        <% if ("noEventPermission".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" style="margin-bottom:16px;">You do not have permission to manage events.</div>
        <% } %>

        <% if ("noBookingPermission".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" style="margin-bottom:16px;">You do not have permission to manage bookings.</div>
        <% } %>

        <section class="hero-panel">
            <div class="hero-text">
                <h2>Control your platform from one place</h2>
                <p>
                    Your dashboard automatically adapts to your assigned admin permission category.
                </p>
            </div>

            <div class="hero-actions">
                <% if (canManageEvents) { %>
                <a href="<%= request.getContextPath() %>/event?action=adminList" class="primary-btn">
                    <i class="fa-solid fa-calendar-plus"></i>
                    <span>Manage Events</span>
                </a>
                <% } %>

                <% if (canManageBookings) { %>
                <a href="<%= request.getContextPath() %>/booking?action=allBookings" class="secondary-btn">
                    <i class="fa-solid fa-list-check"></i>
                    <span>Review Bookings</span>
                </a>
                <% } %>
            </div>
        </section>

        <section class="stats-grid">
            <div class="mini-card purple">
                <div class="mini-icon"><i class="fa-solid fa-users"></i></div>
                <div>
                    <h3>User Control</h3>
                    <p>View and manage registered users</p>
                </div>
            </div>

            <% if (canManageEvents) { %>
            <div class="mini-card cyan">
                <div class="mini-icon"><i class="fa-solid fa-calendar-days"></i></div>
                <div>
                    <h3>Event Management</h3>
                    <p>Create, update and organize events</p>
                </div>
            </div>
            <% } %>

            <% if (canManageBookings) { %>
            <div class="mini-card green">
                <div class="mini-icon"><i class="fa-solid fa-ticket"></i></div>
                <div>
                    <h3>Booking Control</h3>
                    <p>Track customer reservations and approvals</p>
                </div>
            </div>
            <% } %>

            <div class="mini-card orange">
                <div class="mini-icon"><i class="fa-solid fa-user-check"></i></div>
                <div>
                    <h3>Admin Requests</h3>
                    <p>Approve or reject new admin access</p>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>