<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String userName = currentSession != null ? (String) currentSession.getAttribute("userName") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

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

                <a href="<%= request.getContextPath() %>/user?action=list"
                   class="<%= "Users".equals(pageTitle) ? "active" : "" %>">
                    <i class="fa-solid fa-users"></i>
                    <span>Users</span>
                </a>

                <a href="<%= request.getContextPath() %>/event?action=adminList"
                   class="<%= "Events".equals(pageTitle) ? "active" : "" %>">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Events</span>
                </a>

                <a href="<%= request.getContextPath() %>/admin/bookings.jsp"
                   class="<%= "Bookings".equals(pageTitle) ? "active" : "" %>">
                    <i class="fa-solid fa-ticket"></i>
                    <span>Bookings</span>
                </a>

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
            </nav>
        </div>

        <div class="sidebar-footer">
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