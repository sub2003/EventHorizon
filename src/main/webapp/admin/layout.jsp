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
    boolean hasFullAccess = UserService.hasFullAccess(adminPermission);

    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Admin Panel";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - EventHorizon</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="admin-shell">

    <aside class="sidebar">
        <div class="sidebar-top">
            <div class="brand">
                <div class="brand-icon">⬡</div>
                <div class="brand-text">
                    <h2>EVENTHORIZON</h2>
                    <p>Admin Workspace</p>
                </div>
            </div>

            <nav class="nav-links">
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp"
                   class="<%= "Dashboard".equals(pageTitle) ? "active" : "" %>">
                    <i class="fa-solid fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>

                <% if (hasFullAccess) { %>
                <a href="<%= request.getContextPath() %>/user?action=list"
                   class="<%= "Users".equals(pageTitle) ? "active" : "" %>">
                    <i class="fa-solid fa-users"></i>
                    <span>Users</span>
                </a>
                <% } %>

                <% if (canManageEvents) { %>
                <a href="<%= request.getContextPath() %>/event?action=adminList"
                   class="<%= "Events".equals(pageTitle) ? "active" : "" %>">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Events</span>
                </a>
                <% } %>

                <% if (canManageBookings) { %>
                <a href="<%= request.getContextPath() %>/booking?action=allBookings"
                   class="<%= "Bookings".equals(pageTitle) ? "active" : "" %>">
                    <i class="fa-solid fa-ticket"></i>
                    <span>Bookings</span>
                </a>
                <% } %>

                <% if (hasFullAccess) { %>
                <a href="<%= request.getContextPath() %>/user?action=listAdminRequests"
                   class="<%= "Admin Requests".equals(pageTitle) ? "active" : "" %>">
                    <i class="fa-solid fa-user-check"></i>
                    <span>Admin Requests</span>
                </a>

                <a href="<%= request.getContextPath() %>/user?action=addAdminForm"
                   class="<%= "Request Admin".equals(pageTitle) ? "active" : "" %>">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Request Admin</span>
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
        <div class="topbar">
            <div>
                <p class="eyebrow">Administration</p>
                <h1><%= pageTitle %></h1>
            </div>

            <div class="topbar-user">
                Welcome, <strong><%= userName != null ? userName : "Admin" %></strong>
            </div>
        </div>