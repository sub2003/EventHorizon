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

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background:
                radial-gradient(circle at top left, rgba(38, 200, 255, 0.10), transparent 28%),
                radial-gradient(circle at top center, rgba(124, 92, 255, 0.14), transparent 35%),
                linear-gradient(180deg, #020617 0%, #030a1c 45%, #020617 100%);
            color: #eef2ff;
            min-height: 100vh;
        }

        /* ── Shell ── */
        .admin-shell {
            display: flex;
            min-height: 100vh;
        }

        /* ── Sidebar ── */


        /* ── Nav ── */


        /* ── Sidebar Footer ── */


        /* ── Main ── */
        .main-content {
            flex: 1;
            padding: 22px 24px 30px;
            overflow-y: auto;
        }

        /* ── Topbar ── */
        .topbar {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 22px;
        }

        .eyebrow {
            color: #22c7ff;
            text-transform: uppercase;
            letter-spacing: 1.4px;
            font-size: 0.78rem;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .topbar h1 {
            font-size: 2.8rem;
            line-height: 1.05;
            margin: 0 0 6px;
            font-weight: 900;
            color: #f8fbff;
        }

        .subtitle {
            color: #9fb0d3;
            font-size: 0.97rem;
        }

        .topbar-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 18px;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.06);
            color: #ffffff;
            font-weight: 800;
            white-space: nowrap;
            font-size: 0.93rem;
        }

        .topbar-badge i {
            color: #26c8ff;
        }

        /* ── Content Card ── */
        .content-card {
            max-width: 980px;
            background: linear-gradient(135deg, rgba(28, 36, 78, 0.96), rgba(12, 20, 46, 0.94));
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 26px;
            padding: 28px 26px 26px;
            box-shadow: 0 18px 48px rgba(0, 0, 0, 0.28);
        }

        .content-card h2 {
            margin: 0 0 8px;
            font-size: 1.85rem;
            font-weight: 900;
            color: #f8fbff;
        }

        .content-card > p {
            color: #9fb0d3;
            margin-bottom: 22px;
            line-height: 1.6;
            font-size: 0.97rem;
        }

        /* ── Alerts ── */
        .alert {
            padding: 14px 16px;
            border-radius: 14px;
            margin-bottom: 18px;
            font-weight: 700;
            font-size: 0.94rem;
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

        /* ── Form ── */
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
            margin-bottom: 9px;
            font-size: 0.9rem;
            font-weight: 700;
            color: #c7d5f0;
            letter-spacing: 0.3px;
        }

        .field input,
        .field select {
            height: 52px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 14px;
            background: rgba(4, 10, 28, 0.95);
            color: #ffffff;
            padding: 0 16px;
            font-size: 0.96rem;
            font-family: 'Outfit', sans-serif;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .field select option {
            background: #0c1230;
        }

        .field input:focus,
        .field select:focus {
            border-color: rgba(124, 92, 255, 0.55);
            box-shadow: 0 0 0 3px rgba(124, 92, 255, 0.12);
        }

        .field input::placeholder {
            color: #4a5580;
        }

        /* ── Actions ── */
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
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            font-size: 0.95rem;
            border: none;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.15s;
        }

        .primary-btn:hover,
        .secondary-btn:hover {
            opacity: 0.88;
            transform: translateY(-1px);
        }

        .primary-btn {
            background: linear-gradient(90deg, #7c5cff, #26c8ff);
            color: #ffffff;
            box-shadow: 0 10px 28px rgba(124, 92, 255, 0.28);
        }

        .secondary-btn {
            background: rgba(255, 255, 255, 0.05);
            color: #eef2ff;
            border: 1px solid rgba(255, 255, 255, 0.08);
        }

        /* ── Responsive ── */
        @media (max-width: 980px) {
            .admin-shell { flex-direction: column; }

    </style>
</head>
<body>

<div class="admin-shell">

    <!-- ══ SIDEBAR ══ -->
    <aside class="sidebar">
        <div class="sidebar-top">
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

    <!-- ══ MAIN ══ -->
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
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    Admin request submitted successfully. Another full-access admin can now review it.
                </div>
            <% } %>

            <% if ("requestFailed".equals(error)) { %>
                <div class="alert alert-error">
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
