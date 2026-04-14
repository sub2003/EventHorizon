<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

                <a href="<%= request.getContextPath() %>/event?action=adminList">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Manage Events</span>
                </a>

                <a href="<%= request.getContextPath() %>/admin/bookings.jsp">
                    <i class="fa-solid fa-ticket"></i>
                    <span>Bookings</span>
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
        <section class="topbar">
            <div>
                <p class="eyebrow">Administration</p>
                <h1>Dashboard</h1>
                <p class="subtitle">Welcome back, <strong><%= userName != null ? userName : "Admin" %></strong></p>
            </div>

            <div class="topbar-badge">
                <i class="fa-solid fa-shield-halved"></i>
                <span>Admin Access</span>
            </div>
        </section>

        <section class="hero-panel">
            <div class="hero-text">
                <h2>Control your platform from one place</h2>
                <p>
                    Manage users, events, bookings, and admin approvals with a cleaner and more professional workflow.
                </p>
            </div>

            <div class="hero-actions">
                <a href="<%= request.getContextPath() %>/event?action=adminList" class="primary-btn">
                    <i class="fa-solid fa-calendar-plus"></i>
                    <span>Manage Events</span>
                </a>

                <a href="<%= request.getContextPath() %>/user?action=listAdminRequests" class="secondary-btn">
                    <i class="fa-solid fa-list-check"></i>
                    <span>Review Requests</span>
                </a>
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

            <div class="mini-card cyan">
                <div class="mini-icon"><i class="fa-solid fa-user-shield"></i></div>
                <div>
                    <h3>Admin Workflow</h3>
                    <p>Handle pending admin approval requests</p>
                </div>
            </div>

            <div class="mini-card pink">
                <div class="mini-icon"><i class="fa-solid fa-calendar-days"></i></div>
                <div>
                    <h3>Event Control</h3>
                    <p>Create, update, cancel, or delete events</p>
                </div>
            </div>
        </section>

        <section class="dashboard-grid">

            <a href="<%= request.getContextPath() %>/user?action=list" class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-users"></i></div>
                <h3>Manage Users</h3>
                <p>Open the user management panel to review customers and admins.</p>
                <span class="feature-link">Open Users <i class="fa-solid fa-arrow-right"></i></span>
            </a>

            <a href="<%= request.getContextPath() %>/user?action=addAdminForm" class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-user-plus"></i></div>
                <h3>Request New Admin</h3>
                <p>Create a new admin request that must be approved by another admin.</p>
                <span class="feature-link">Open Request Form <i class="fa-solid fa-arrow-right"></i></span>
            </a>

            <a href="<%= request.getContextPath() %>/user?action=listAdminRequests" class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-user-check"></i></div>
                <h3>Pending Admin Requests</h3>
                <p>Approve or reject incoming admin access requests from one screen.</p>
                <span class="feature-link">View Requests <i class="fa-solid fa-arrow-right"></i></span>
            </a>

            <a href="<%= request.getContextPath() %>/event?action=adminList" class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-calendar-days"></i></div>
                <h3>Manage Events</h3>
                <p>Access the event management area to update live event listings.</p>
                <span class="feature-link">Open Events <i class="fa-solid fa-arrow-right"></i></span>
            </a>

            <a href="<%= request.getContextPath() %>/admin/addEvent.jsp" class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-plus-circle"></i></div>
                <h3>Add Event</h3>
                <p>Create a brand-new event with venue, date, seats, pricing, and image.</p>
                <span class="feature-link">Add Event <i class="fa-solid fa-arrow-right"></i></span>
            </a>

            <a href="<%= request.getContextPath() %>/admin/bookings.jsp" class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-ticket"></i></div>
                <h3>Bookings</h3>
                <p>Review customer booking records and monitor system activity.</p>
                <span class="feature-link">Open Bookings <i class="fa-solid fa-arrow-right"></i></span>
            </a>

        </section>
    </main>
</div>

</body>
</html>