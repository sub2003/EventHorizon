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
    <title>Request New Admin - EventHorizon</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background:
                radial-gradient(circle at top left, rgba(38, 200, 255, 0.10), transparent 28%),
                radial-gradient(circle at top center, rgba(124, 92, 255, 0.14), transparent 35%),
                linear-gradient(180deg, #020617 0%, #030a1c 45%, #020617 100%);
            color: #eef2ff;
            min-height: 100vh;
        }

        .admin-shell {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            background: rgba(3, 7, 18, 0.92);
            border-right: 1px solid rgba(255, 255, 255, 0.06);
            padding: 18px 14px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            backdrop-filter: blur(10px);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 10px;
            margin-bottom: 18px;
        }

        .brand-icon {
            width: 38px;
            height: 38px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #7c5cff, #26c8ff);
            color: #ffffff;
            font-size: 15px;
            box-shadow: 0 10px 25px rgba(124, 92, 255, 0.35);
        }

        .brand h2 {
            color: #ffffff;
            font-size: 1.7rem;
            line-height: 1.1;
            margin: 0;
            font-weight: 900;
        }

        .brand p {
            color: #94a3b8;
            font-size: 0.82rem;
            margin-top: 3px;
        }

        .nav-links a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 16px;
            margin-bottom: 10px;
            border-radius: 14px;
            color: #dbe7ff;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.96rem;
            background: rgba(255,255,255,0.02);
            border: 1px solid transparent;
            transition: all 0.2s ease;
        }

        .nav-links a i {
            width: 18px;
            text-align: center;
            color: #cbd5e1;
        }

        .nav-links a:hover,
        .nav-links a.active {
            background: linear-gradient(90deg, rgba(124,92,255,0.18), rgba(38,200,255,0.12));
            border-color: rgba(124, 92, 255, 0.22);
            color: #ffffff;
        }

        .sidebar-footer .permission-box {
            padding: 12px 14px;
            margin-bottom: 12px;
            border-radius: 12px;
            background: rgba(255,255,255,0.04);
            color: #cbd5e1;
            font-size: 0.9rem;
        }

        .permission-box .label {
            font-size: 0.74rem;
            text-transform: uppercase;
            opacity: 0.75;
            margin-bottom: 4px;
            letter-spacing: 0.4px;
        }

        .back-site,
        .logout-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            justify-content: flex-start;
            width: 100%;
            padding: 13px 14px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 800;
            margin-top: 10px;
        }

        .back-site {
            background: rgba(255,255,255,0.04);
            color: #eef2ff;
            border: 1px solid rgba(255,255,255,0.05);
        }

        .logout-btn {
            background: linear-gradient(90deg, rgba(120,25,35,0.78), rgba(58,10,26,0.96));
            color: #ffffff;
            border: 1px solid rgba(255,255,255,0.04);
        }

        .main-content {
            flex: 1;
            padding: 22px 24px 30px;
        }

        .topbar {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
        }

        .eyebrow {
            color: #22c7ff;
            text-transform: uppercase;
            letter-spacing: 1.4px;
            font-size: 0.78rem;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .topbar h1 {
            font-size: 3.15rem;
            line-height: 1.05;
            margin: 0 0 8px;
            font-weight: 900;
            color: #f8fbff;
        }

        .subtitle {
            color: #9fb0d3;
            font-size: 1rem;
        }

        .topbar-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 18px;
            border-radius: 14px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.06);
            color: #ffffff;
            font-weight: 800;
            white-space: nowrap;
        }

        .content-card {
            max-width: 980px;
            background: linear-gradient(135deg, rgba(28, 36, 78, 0.96), rgba(12, 20, 46, 0.94));
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 26px;
            padding: 28px 24px 24px;
            box-shadow: 0 18px 48px rgba(0,0,0,0.28);
        }

        .content-card h2 {
            margin: 0 0 10px;
            font-size: 2.2rem;
            font-weight: 900;
            color: #f8fbff;
        }

        .content-card p {
            color: #9fb0d3;
            margin-bottom: 24px;
            line-height: 1.6;
        }

        .alert {
            padding: 14px 16px;
            border-radius: 14px;
            margin-bottom: 18px;
            font-weight: 700;
        }

        .alert-success {
            background: rgba(46, 204, 113, 0.14);
            border: 1px solid rgba(46, 204, 113, 0.30);
            color: #9af5b6;
        }

        .alert-error {
            background: rgba(231, 76, 60, 0.14);
            border: 1px solid rgba(231, 76, 60, 0.30);
            color: #ffb7ad;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .field {
            display: flex;
            flex-direction: column;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        .field label {
            margin-bottom: 10px;
            font-size: 1rem;
            font-weight: 800;
            color: #f3f7ff;
        }

        .field input,
        .field select {
            height: 56px;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 14px;
            background: rgba(4, 10, 28, 0.95);
            color: #ffffff;
            padding: 0 16px;
            font-size: 0.98rem;
            outline: none;
            transition: all 0.2s ease;
        }

        .field input:focus,
        .field select:focus {
            border-color: rgba(124,92,255,0.50);
            box-shadow: 0 0 0 3px rgba(124,92,255,0.12);
        }

        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 24px;
        }

        .primary-btn,
        .secondary-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-height: 50px;
            padding: 0 22px;
            border-radius: 14px;
            text-decoration: none;
            font-weight: 800;
            border: none;
            cursor: pointer;
            font-size: 0.96rem;
        }

        .primary-btn {
            background: linear-gradient(90deg, #7c5cff, #26c8ff);
            color: #ffffff;
            box-shadow: 0 14px 30px rgba(76, 130, 255, 0.22);
        }

        .secondary-btn {
            background: rgba(255,255,255,0.05);
            color: #eef2ff;
            border: 1px solid rgba(255,255,255,0.08);
        }

        @media (max-width: 980px) {
            .admin-shell {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            .topbar {
                flex-direction: column;
                align-items: flex-start;
            }

            .topbar h1 {
                font-size: 2.4rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
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
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">
                    <i class="fa-solid fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>

                <% if (hasFullAccess) { %>
                <a href="<%= request.getContextPath() %>/user?action=list">
                    <i class="fa-solid fa-users"></i>
                    <span>Manage Users</span>
                </a>
                <% } %>

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

                <a href="<%= request.getContextPath() %>/booking?action=pendingPayments">
                    <i class="fa-solid fa-money-check-dollar"></i>
                    <span>Manage Payments</span>
                </a>
                <% } %>

                <% if (hasFullAccess) { %>
                <a class="active" href="<%= request.getContextPath() %>/user?action=addAdminForm">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Request New Admin</span>
                </a>

                <a href="<%= request.getContextPath() %>/user?action=listAdminRequests">
                    <i class="fa-solid fa-user-check"></i>
                    <span>Admin Requests</span>
                </a>
                <% } %>
            </nav>
        </div>

        <div class="sidebar-footer">
            <div class="permission-box">
                <div class="label">Permission</div>
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
                <h1>Request New Admin</h1>
                <p class="subtitle">Welcome back, <strong><%= userName != null ? userName : "Admin" %></strong></p>
            </div>

            <div class="topbar-badge">
                <i class="fa-solid fa-shield-halved"></i>
                <span><%= UserService.permissionLabel(adminPermission) %></span>
            </div>
        </section>

        <section class="content-card">
            <h2>New Admin Request Form</h2>
            <p>Submit a new admin access request. The request will stay pending until another full-access admin reviews it.</p>

            <% if ("requestSubmitted".equals(msg)) { %>
                <div class="alert alert-success">
                    Admin request submitted successfully. Another full-access admin can now review it.
                </div>
            <% } %>

            <% if ("requestFailed".equals(error)) { %>
                <div class="alert alert-error">
                    Request submission failed. Check the fields or verify that the email is not already registered or pending.
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/user" method="post">
                <input type="hidden" name="action" value="requestAdmin">

                <div class="form-grid">
                    <div class="field">
                        <label for="name">Full Name</label>
                        <input id="name" type="text" name="name" required>
                    </div>

                    <div class="field">
                        <label for="email">Email Address</label>
                        <input id="email" type="email" name="email" required>
                    </div>

                    <div class="field">
                        <label for="password">Temporary Password</label>
                        <input id="password" type="text" name="password" required>
                    </div>

                    <div class="field">
                        <label for="phone">Phone Number</label>
                        <input id="phone" type="text" name="phone" required>
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

                <div class="actions">
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