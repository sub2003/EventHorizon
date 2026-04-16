<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhorizon.model.Admin" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String userName = currentSession != null ? (String) currentSession.getAttribute("userName") : null;
    String adminPermission = currentSession != null ? (String) currentSession.getAttribute("adminPermission") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role) || !"FULL_ACCESS".equals(adminPermission)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (adminPermission == null || adminPermission.trim().isEmpty()) {
        adminPermission = Admin.FULL_ACCESS;
    }

    boolean canManageEvents = UserService.hasEventAccess(adminPermission);
    boolean canManageBookings = UserService.hasBookingAccess(adminPermission);
    boolean hasFullAccess = UserService.hasFullAccess(adminPermission);

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Admin - EventHorizon</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .content-card {
            background: linear-gradient(135deg, rgba(18, 24, 56, 0.92), rgba(10, 16, 38, 0.94));
            border: 1px solid var(--line);
            border-radius: 24px;
            padding: 28px;
            box-shadow: var(--shadow);
            max-width: 900px;
        }
        .content-card h2 { font-size: 26px; margin-bottom: 8px; }
        .content-card > p { color: var(--muted); margin-bottom: 24px; line-height: 1.6; }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }
        .field { display: flex; flex-direction: column; }
        .field.full { grid-column: 1 / -1; }

        .field label {
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 600;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .field input,
        .field select {
            height: 50px;
            border: 1px solid var(--line);
            border-radius: 12px;
            background: rgba(4, 8, 24, 0.90);
            color: var(--text);
            padding: 0 16px;
            font-size: 15px;
            font-family: "Segoe UI", Arial, sans-serif;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            width: 100%;
        }
        .field select option { background: #0a1022; }
        .field input:focus,
        .field select:focus {
            border-color: rgba(139, 92, 246, 0.55);
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.12);
        }
        .field input::placeholder { color: #3a4468; }

        .form-actions { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 26px; }
        .form-actions button[type="submit"] {
            border: none;
            font-size: 15px;
            font-weight: 600;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        @media (max-width: 700px) { .form-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="admin-shell">

    <!-- SIDEBAR — mirrors layout.jsp exactly -->
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
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">
                    <i class="fa-solid fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>

                <% if (hasFullAccess) { %>
                <a href="<%= request.getContextPath() %>/user?action=list">
                    <i class="fa-solid fa-users"></i>
                    <span>Users</span>
                </a>
                <% } %>

                <% if (canManageEvents) { %>
                <a href="<%= request.getContextPath() %>/event?action=adminList">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Events</span>
                </a>
                <% } %>

                <% if (canManageBookings) { %>
                <a href="<%= request.getContextPath() %>/booking?action=allBookings">
                    <i class="fa-solid fa-ticket"></i>
                    <span>Bookings</span>
                </a>
                <% } %>

                <% if (hasFullAccess) { %>
                <a href="<%= request.getContextPath() %>/user?action=listAdminRequests">
                    <i class="fa-solid fa-user-check"></i>
                    <span>Admin Requests</span>
                </a>

                <a class="active" href="<%= request.getContextPath() %>/user?action=addAdminForm">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Request Admin</span>
                </a>
                <% } %>
            </nav>
        </div>

        <div class="sidebar-footer">
            <div style="padding:12px 14px; border-radius:12px; background:rgba(255,255,255,0.04); color:#cbd5e1; font-size:0.9rem;">
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

    <!-- MAIN -->
    <main class="main-content">
        <div class="topbar">
            <div>
                <p class="eyebrow">Administration</p>
                <h1>Request Admin</h1>
            </div>
            <div class="topbar-user">
                Welcome, <strong><%= userName != null ? userName : "Admin" %></strong>
            </div>
        </div>

        <section class="content-card">
            <h2>New Admin Request Form</h2>
            <p>Submit a new admin access request. The request will stay pending until another full-access admin reviews it.</p>

            <% if ("requestSubmitted".equals(msg)) { %>
                <div class="alert alert-success" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    Admin request submitted successfully. Another full-access admin can now review it.
                </div>
            <% } %>
            <% if ("requestFailed".equals(error)) { %>
                <div class="alert alert-danger" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>
                    Request submission failed. Check the fields or verify that the email is not already registered or pending.
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/user" method="post">
                <input type="hidden" name="action" value="requestAdmin">

                <div class="form-grid">
                    <div class="field">
                        <label for="name">Full Name</label>
                        <input id="name" type="text" name="name" placeholder="Enter full name" required>
                    </div>
                    <div class="field">
                        <label for="email">Email Address</label>
                        <input id="email" type="email" name="email" placeholder="Enter email address" required>
                    </div>
                    <div class="field">
                        <label for="password">Temporary Password</label>
                        <input id="password" type="text" name="password" placeholder="Set a temporary password" required>
                    </div>
                    <div class="field">
                        <label for="phone">Phone Number</label>
                        <input id="phone" type="text" name="phone" placeholder="Enter phone number" required>
                    </div>
                    <div class="field full">
                        <label for="adminPermission">Permission Type</label>
                        <select id="adminPermission" name="adminPermission" required>
                            <option value="">Select permission</option>
                            <option value="FULL_ACCESS">Full Access</option>
                            <option value="EVENTS_ONLY">Events Only</option>
                            <option value="BOOKINGS_ONLY">Bookings Only</option>
                            <option value="EVENTS_BOOKINGS">Events + Bookings</option>
                        </select>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="primary-btn">
                        <i class="fa-solid fa-paper-plane"></i>
                        <span>Submit Request</span>
                    </button>
                    <a href="<%= request.getContextPath() %>/user?action=listAdminRequests" class="secondary-btn">
                        <i class="fa-solid fa-list-check"></i>
                        <span>View Pending Requests</span>
                    </a>
                </div>
            </form>
        </section>
    </main>
</div>
</body>
</html>
