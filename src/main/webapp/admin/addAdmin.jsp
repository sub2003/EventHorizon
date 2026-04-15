<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String userName = currentSession != null ? (String) currentSession.getAttribute("userName") : null;
    String adminPermission = currentSession != null ? (String) currentSession.getAttribute("adminPermission") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role) || !"FULL_ACCESS".equals(adminPermission)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
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
    <style>
        * { box-sizing: border-box; font-family: Arial, sans-serif; }
        body {
            margin: 0;
            background: radial-gradient(circle at top, #0d1635 0%, #050816 55%, #030611 100%);
            color: #eef2ff;
        }
        .wrapper {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 250px;
            background: rgba(4, 9, 30, 0.95);
            border-right: 1px solid rgba(255,255,255,0.06);
            padding: 18px 14px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .brand-box {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            padding: 14px 12px;
            border-radius: 18px;
            background: rgba(255,255,255,0.03);
        }
        .brand-icon {
            width: 34px;
            height: 34px;
            border-radius: 12px;
            background: linear-gradient(135deg, #7c5cff, #27c8ff);
        }
        .brand-title {
            font-size: 24px;
            font-weight: 800;
            color: #ffffff;
        }
        .brand-sub {
            font-size: 12px;
            color: #9aa7d7;
        }
        .nav a {
            display: block;
            padding: 14px 16px;
            margin-bottom: 10px;
            border-radius: 14px;
            color: #d9def8;
            text-decoration: none;
            background: rgba(255,255,255,0.02);
            border: 1px solid transparent;
            font-weight: 600;
        }
        .nav a.active,
        .nav a:hover {
            background: linear-gradient(90deg, rgba(124,92,255,0.18), rgba(39,200,255,0.12));
            border-color: rgba(124,92,255,0.25);
        }
        .sidebar-footer .permission,
        .sidebar-footer .website,
        .sidebar-footer .logout {
            display: block;
            width: 100%;
            padding: 14px 16px;
            border-radius: 14px;
            text-decoration: none;
            margin-top: 10px;
            font-weight: 700;
        }
        .permission {
            background: rgba(255,255,255,0.04);
            color: #eef2ff;
        }
        .website {
            background: rgba(255,255,255,0.03);
            color: #eef2ff;
        }
        .logout {
            background: linear-gradient(90deg, rgba(120,25,35,0.75), rgba(58,10,26,0.95));
            color: #fff;
        }
        .main {
            flex: 1;
            padding: 26px 28px;
        }
        .page-kicker {
            color: #22c7ff;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-size: 12px;
            font-weight: 800;
            margin-bottom: 8px;
        }
        .page-title {
            font-size: 52px;
            font-weight: 900;
            margin: 0 0 8px;
        }
        .page-subtitle {
            color: #9ca9d9;
            margin-bottom: 22px;
        }
        .access-badge {
            float: right;
            margin-top: -75px;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.08);
            color: #fff;
            padding: 12px 18px;
            border-radius: 14px;
            font-weight: 800;
        }
        .card {
            max-width: 980px;
            background: linear-gradient(135deg, rgba(25,32,67,0.95), rgba(12,19,44,0.92));
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 28px;
            padding: 34px;
            box-shadow: 0 18px 48px rgba(0,0,0,0.28);
        }
        .card h2 {
            margin: 0 0 10px;
            font-size: 38px;
            font-weight: 900;
        }
        .card p {
            color: #9ca9d9;
            margin-bottom: 28px;
        }
        .alert {
            padding: 14px 16px;
            border-radius: 14px;
            margin-bottom: 18px;
            font-weight: 700;
        }
        .alert-success {
            background: rgba(46, 204, 113, 0.14);
            border: 1px solid rgba(46, 204, 113, 0.3);
            color: #9af5b6;
        }
        .alert-error {
            background: rgba(231, 76, 60, 0.14);
            border: 1px solid rgba(231, 76, 60, 0.3);
            color: #ffb7ad;
        }
        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px 18px;
        }
        .field {
            display: flex;
            flex-direction: column;
        }
        .field.full {
            grid-column: 1 / -1;
        }
        label {
            margin-bottom: 10px;
            font-size: 18px;
            font-weight: 800;
        }
        input, select {
            height: 56px;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 16px;
            background: rgba(6, 11, 30, 0.95);
            color: #ffffff;
            padding: 0 18px;
            font-size: 16px;
            outline: none;
        }
        input:focus, select:focus {
            border-color: rgba(124,92,255,0.55);
            box-shadow: 0 0 0 3px rgba(124,92,255,0.12);
        }
        .actions {
            display: flex;
            gap: 14px;
            margin-top: 28px;
            flex-wrap: wrap;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 52px;
            padding: 0 24px;
            border-radius: 14px;
            text-decoration: none;
            font-weight: 800;
            border: none;
            cursor: pointer;
        }
        .btn-primary {
            background: linear-gradient(90deg, #7c5cff, #28c7ff);
            color: #fff;
        }
        .btn-secondary {
            background: rgba(255,255,255,0.07);
            color: #eef2ff;
            border: 1px solid rgba(255,255,255,0.08);
        }
        @media (max-width: 900px) {
            .wrapper { flex-direction: column; }
            .sidebar { width: 100%; }
            .grid { grid-template-columns: 1fr; }
            .access-badge { float: none; margin: 0 0 16px; display: inline-block; }
            .page-title { font-size: 40px; }
        }
    </style>
</head>
<body>
<div class="wrapper">
    <aside class="sidebar">
        <div>
            <div class="brand-box">
                <div class="brand-icon"></div>
                <div>
                    <div class="brand-title">EVENTHORIZON</div>
                    <div class="brand-sub">Admin Workspace</div>
                </div>
            </div>

            <nav class="nav">
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">Dashboard</a>
                <a href="<%= request.getContextPath() %>/user?action=list">Manage Users</a>
                <a href="<%= request.getContextPath() %>/event?action=adminList">Manage Events</a>
                <a href="<%= request.getContextPath() %>/booking?action=allBookings">Bookings</a>
                <a href="<%= request.getContextPath() %>/booking?action=pendingPayments">Manage Payments</a>
                <a class="active" href="<%= request.getContextPath() %>/user?action=addAdminForm">Request New Admin</a>
                <a href="<%= request.getContextPath() %>/user?action=listAdminRequests">Admin Requests</a>
            </nav>
        </div>

        <div class="sidebar-footer">
            <div class="permission">Permission<br><strong>Full Access</strong></div>
            <a class="website" href="<%= request.getContextPath() %>/index.jsp">Open Website</a>
            <a class="logout" href="<%= request.getContextPath() %>/user?action=logout">Logout</a>
        </div>
    </aside>

    <main class="main">
        <div class="page-kicker">Administration</div>
        <h1 class="page-title">Request New Admin</h1>
        <div class="page-subtitle">Welcome, <%= userName %></div>
        <div class="access-badge">Full Access</div>

        <section class="card">
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

                <div class="grid">
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
                    <button type="submit" class="btn btn-primary">Submit Request</button>
                    <a href="<%= request.getContextPath() %>/user?action=listAdminRequests" class="btn btn-secondary">View Pending Requests</a>
                </div>
            </form>
        </section>
    </main>
</div>
</body>
</html>