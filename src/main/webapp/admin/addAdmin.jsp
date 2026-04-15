<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%@ page import="com.eventhorizon.model.Admin" %>
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
            min-height: 100vh;
            background:
                radial-gradient(circle at top left, rgba(53, 93, 255, 0.18), transparent 28%),
                radial-gradient(circle at top right, rgba(0, 212, 255, 0.12), transparent 24%),
                linear-gradient(180deg, #020617 0%, #020b24 45%, #01081d 100%);
            color: #e5eefc;
        }

        .admin-shell {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 190px;
            background: rgba(2, 6, 23, 0.88);
            border-right: 1px solid rgba(148, 163, 184, 0.08);
            padding: 18px 12px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            backdrop-filter: blur(14px);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 8px 14px;
            margin-bottom: 8px;
        }

        .brand-icon {
            width: 34px;
            height: 34px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 16px;
            background: linear-gradient(135deg, #7c5cff, #25c7ff);
            box-shadow: 0 10px 26px rgba(124, 92, 255, 0.35);
            flex-shrink: 0;
        }

        .brand h2 {
            font-size: 15px;
            line-height: 1.1;
            letter-spacing: 0.4px;
            color: #ffffff;
        }

        .brand p {
            margin-top: 3px;
            font-size: 11px;
            color: #94a3b8;
        }

        .nav-links {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-top: 6px;
        }

        .nav-links a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 11px 12px;
            border-radius: 12px;
            color: #dbe7ff;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            border: 1px solid transparent;
            background: rgba(255, 255, 255, 0.02);
            transition: 0.2s ease;
        }

        .nav-links a i {
            width: 18px;
            text-align: center;
            font-size: 13px;
        }

        .nav-links a:hover,
        .nav-links a.active {
            background: linear-gradient(90deg, rgba(90, 115, 255, 0.18), rgba(41, 195, 255, 0.12));
            border-color: rgba(96, 165, 250, 0.15);
            color: #ffffff;
        }

        .sidebar-footer {
            margin-top: 24px;
        }

        .permission-box {
            padding: 12px 14px;
            margin-bottom: 12px;
            border-radius: 12px;
            background: rgba(255,255,255,0.04);
            color: #cbd5e1;
            font-size: 0.9rem;
            border: 1px solid rgba(255,255,255,0.04);
        }

        .permission-box div {
            font-size: 0.72rem;
            text-transform: uppercase;
            opacity: 0.75;
            margin-bottom: 4px;
            letter-spacing: 0.8px;
        }

        .back-site,
        .logout-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            width: 100%;
            padding: 12px 14px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 700;
            font-size: 14px;
            margin-top: 10px;
        }

        .back-site {
            background: rgba(255,255,255,0.03);
            color: #e2e8f0;
            border: 1px solid rgba(255,255,255,0.05);
        }

        .logout-btn {
            background: linear-gradient(90deg, rgba(127,29,29,0.82), rgba(69,10,10,0.95));
            color: #ffffff;
            border: 1px solid rgba(248, 113, 113, 0.14);
        }

        .main-content {
            flex: 1;
            padding: 20px 18px 28px;
        }

        .topbar {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
        }

        .eyebrow {
            color: #22d3ee;
            text-transform: uppercase;
            letter-spacing: 1.8px;
            font-size: 11px;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .topbar h1 {
            font-size: 54px;
            line-height: 1.02;
            font-weight: 900;
            color: #f8fbff;
            margin-bottom: 6px;
        }

        .subtitle {
            color: #94a3b8;
            font-size: 15px;
        }

        .subtitle strong {
            color: #ffffff;
        }

        .topbar-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 16px;
            margin-top: 18px;
            border-radius: 14px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.08);
            color: #f8fafc;
            font-weight: 700;
            white-space: nowrap;
        }

        .hero-panel,
        .content-card {
            background: linear-gradient(90deg, rgba(58, 45, 125, 0.68), rgba(18, 63, 92, 0.62));
            border: 1px solid rgba(148, 163, 184, 0.10);
            border-radius: 22px;
            box-shadow: 0 22px 55px rgba(0, 0, 0, 0.26);
        }

        .hero-panel {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            padding: 22px 18px;
            margin-bottom: 18px;
        }

        .hero-text h2 {
            font-size: 17px;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 7px;
        }

        .hero-text p {
            color: #b8c6e4;
            font-size: 14px;
            line-height: 1.55;
        }

        .hero-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .primary-btn,
        .secondary-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            min-height: 44px;
            padding: 0 18px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 700;
            font-size: 14px;
            border: 1px solid transparent;
        }

        .primary-btn {
            background: linear-gradient(90deg, #7c5cff, #22c7ff);
            color: #ffffff;
            box-shadow: 0 12px 28px rgba(34, 199, 255, 0.22);
        }

        .secondary-btn {
            background: rgba(255,255,255,0.05);
            color: #e2e8f0;
            border-color: rgba(255,255,255,0.08);
        }

        .content-card {
            max-width: 980px;
            padding: 26px 22px;
        }

        .content-card h2 {
            font-size: 34px;
            font-weight: 900;
            color: #ffffff;
            margin-bottom: 10px;
        }

        .content-card .section-text {
            color: #b8c6e4;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 22px;
        }

        .alert {
            border-radius: 14px;
            padding: 14px 16px;
            margin-bottom: 18px;
            font-weight: 700;
            border: 1px solid transparent;
        }

        .alert-success {
            background: rgba(34, 197, 94, 0.12);
            border-color: rgba(74, 222, 128, 0.24);
            color: #bbf7d0;
        }

        .alert-error {
            background: rgba(239, 68, 68, 0.12);
            border-color: rgba(248, 113, 113, 0.24);
            color: #fecaca;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px 16px;
        }

        .field {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        .field label {
            font-size: 14px;
            font-weight: 800;
            color: #f8fafc;
        }

        .field input,
        .field select {
            width: 100%;
            height: 54px;
            border-radius: 14px;
            border: 1px solid rgba(148, 163, 184, 0.12);
            background: rgba(2, 6, 23, 0.78);
            color: #f8fafc;
            padding: 0 16px;
            font-size: 14px;
            outline: none;
            transition: 0.2s ease;
        }

        .field input:focus,
        .field select:focus {
            border-color: rgba(96, 165, 250, 0.42);
            box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.12);
        }

        .field input::placeholder {
            color: #64748b;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 24px;
        }

        @media (max-width: 1024px) {
            .topbar {
                flex-direction: column;
                align-items: flex-start;
            }

            .topbar-badge {
                margin-top: 0;
            }
        }

        @media (max-width: 900px) {
            .admin-shell {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            .main-content {
                padding: 18px 14px 24px;
            }

            .topbar h1 {
                font-size: 40px;
            }

            .hero-panel {
                flex-direction: column;
                align-items: flex-start;
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
                <a href="<%= request.getContextPath() %>/user?action=list">
                    <i class="fa-solid fa-users"></i>
                    <span>Manage Users</span>
                </a>
                <a href="<%= request.getContextPath() %>/event?action=adminList">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Manage Events</span>
                </a>
                <a href="<%= request.getContextPath() %>/booking?action=allBookings">
                    <i class="fa-solid fa-ticket"></i>
                    <span>Bookings</span>
                </a>
                <a href="<%= request.getContextPath() %>/booking?action=pendingPayments">
                    <i class="fa-solid fa-money-check-dollar"></i>
                    <span>Manage Payments</span>
                </a>
                <a class="active" href="<%= request.getContextPath() %>/user?action=addAdminForm">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Request New Admin</span>
                </a>
                <a href="<%= request.getContextPath() %>/user?action=listAdminRequests">
                    <i class="fa-solid fa-user-check"></i>
                    <span>Admin Requests</span>
                </a>
            </nav>
        </div>

        <div class="sidebar-footer">
            <div class="permission-box">
                <div>Permission</div>
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

        <section class="hero-panel">
            <div class="hero-text">
                <h2>Submit a new admin access request</h2>
                <p>Your request will remain pending until another full-access admin reviews and processes it.</p>
            </div>

            <div class="hero-actions">
                <a href="<%= request.getContextPath() %>/user?action=listAdminRequests" class="secondary-btn">
                    <i class="fa-solid fa-user-check"></i>
                    <span>View Pending Requests</span>
                </a>
            </div>
        </section>

        <section class="content-card">
            <h2>New Admin Request Form</h2>
            <p class="section-text">Fill in the requested details below. This page was visually aligned to the dashboard without changing your existing request flow.</p>

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

                <div class="form-actions">
                    <button type="submit" class="primary-btn" style="border:none; cursor:pointer;">
                        <i class="fa-solid fa-paper-plane"></i>
                        <span>Submit Request</span>
                    </button>

                    <a href="<%= request.getContextPath() %>/user?action=listAdminRequests" class="secondary-btn">
                        <i class="fa-solid fa-clock"></i>
                        <span>View Pending Requests</span>
                    </a>
                </div>
            </form>
        </section>
    </main>
</div>
</body>
</html>
