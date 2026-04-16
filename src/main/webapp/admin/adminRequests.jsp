<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.eventhorizon.model.Admin" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String userName = currentSession != null ? (String) currentSession.getAttribute("userName") : null;
    String adminPermission = currentSession != null ? (String) currentSession.getAttribute("adminPermission") : null;
    String currentAdminId = currentSession != null ? (String) currentSession.getAttribute("userId") : null;

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

    List<Map<String, String>> adminRequests =
            (List<Map<String, String>>) request.getAttribute("adminRequests");
    if (adminRequests == null) {
        adminRequests = new java.util.ArrayList<>();
    }

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Requests - EventHorizon</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
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
        .sidebar {
            width: 260px;
            background: rgba(3, 7, 18, 0.92);
            border-right: 1px solid rgba(255, 255, 255, 0.06);
            padding: 18px 14px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            backdrop-filter: blur(10px);
            position: sticky;
            top: 0;
            height: 100vh;
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
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #7c5cff, #26c8ff);
            color: #ffffff;
            font-size: 15px;
            box-shadow: 0 10px 25px rgba(124, 92, 255, 0.35);
            flex-shrink: 0;
        }

        .brand h2 {
            color: #ffffff;
            font-size: 1.08rem;
            line-height: 1.1;
            margin: 0;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .brand p {
            color: #94a3b8;
            font-size: 0.78rem;
            margin-top: 2px;
        }

        /* ── Nav ── */
        .nav-links a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px 16px;
            margin-bottom: 6px;
            border-radius: 14px;
            color: #dbe7ff;
            text-decoration: none;
            font-weight: 700;
            font-size: 16px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid transparent;
            transition: all 0.2s ease;
        }

        .nav-links a i {
            width: 18px;
            text-align: center;
            color: #94a3b8;
            font-size: 0.95rem;
            transition: color 0.2s;
        }

        .nav-links a:hover,
        .nav-links a.active {
            background: linear-gradient(90deg, rgba(124, 92, 255, 0.18), rgba(38, 200, 255, 0.12));
            border-color: rgba(124, 92, 255, 0.22);
            color: #ffffff;
        }

        .nav-links a:hover i,
        .nav-links a.active i {
            color: #26c8ff;
        }

        /* ── Sidebar Footer ── */
        .sidebar-footer a {
            display: flex;
            align-items: center;
            gap: 10px;
            width: 100%;
            padding: 13px 14px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 800;
            font-size: 16px;
            margin-top: 10px;
        }

        .back-site {
            background: rgba(255, 255, 255, 0.04);
            color: #eef2ff;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .logout-btn {
            background: linear-gradient(90deg, rgba(120, 25, 35, 0.78), rgba(58, 10, 26, 0.96));
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.04);
        }

        /* ── Main ── */
        .main-content {
            flex: 1;
            padding: 28px;
            overflow-y: auto;
        }

        /* ── Topbar ── */
        .topbar {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 24px;
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
            font-size: 36px;
            line-height: 1.1;
            margin: 0 0 6px;
            font-weight: 900;
            color: #f8fbff;
        }

        .subtitle {
            color: #9fb0d3;
            font-size: 15px;
        }

        .topbar-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 16px;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.06);
            color: #ffffff;
            font-weight: 800;
            white-space: nowrap;
            font-size: 16px;
        }

        .topbar-badge i {
            color: #26c8ff;
        }

        /* ── Content Card ── */
        .content-card {
            background: linear-gradient(135deg, rgba(28, 36, 78, 0.96), rgba(12, 20, 46, 0.94));
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 26px;
            padding: 26px 24px 24px;
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
            margin-bottom: 20px;
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

        /* ── Table ── */
        .table-wrap {
            overflow-x: auto;
            border-radius: 18px;
            border: 1px solid rgba(255, 255, 255, 0.06);
            background: rgba(2, 8, 23, 0.45);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }

        thead th {
            background: linear-gradient(90deg, #7c5cff, #26c8ff);
            color: #fff;
            text-align: left;
            padding: 16px 14px;
            font-size: 0.82rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.7px;
        }

        thead th:first-child { border-radius: 18px 0 0 0; }
        thead th:last-child  { border-radius: 0 18px 0 0; }

        tbody tr {
            background: rgba(255, 255, 255, 0.01);
            transition: background 0.15s;
        }

        tbody tr:hover {
            background: rgba(124, 92, 255, 0.06);
        }

        tbody td {
            padding: 15px 14px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            color: #eef2ff;
            vertical-align: top;
            font-size: 16px;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        /* ── Pills ── */
        .pill {
            display: inline-flex;
            align-items: center;
            padding: 5px 12px;
            border-radius: 999px;
            font-size: 0.76rem;
            font-weight: 800;
        }

        .pill-self {
            background: rgba(255, 99, 132, 0.14);
            border: 1px solid rgba(255, 99, 132, 0.22);
            color: #ffb4c4;
        }

        .pill-perm {
            background: rgba(124, 92, 255, 0.16);
            border: 1px solid rgba(124, 92, 255, 0.22);
            color: #d2c7ff;
        }

        /* ── Action Buttons ── */
        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            border: none;
            border-radius: 12px;
            padding: 9px 14px;
            font-family: "Segoe UI", Arial, sans-serif;
            font-weight: 800;
            cursor: pointer;
            font-size: 0.87rem;
            transition: opacity 0.2s, transform 0.15s;
        }

        .btn:hover:not(:disabled) {
            opacity: 0.85;
            transform: translateY(-1px);
        }

        .btn-approve {
            background: linear-gradient(90deg, #19c37d, #2ed573);
            color: #fff;
            box-shadow: 0 6px 18px rgba(46, 213, 115, 0.22);
        }

        .btn-reject {
            background: linear-gradient(90deg, #ff5f6d, #c44569);
            color: #fff;
            box-shadow: 0 6px 18px rgba(196, 69, 105, 0.22);
        }

        .btn-disabled {
            background: rgba(255, 255, 255, 0.06);
            color: #6b7aaa;
            cursor: not-allowed;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .empty {
            padding: 36px 10px;
            color: #5a6a9a;
            font-weight: 700;
            text-align: center;
            font-size: 0.97rem;
        }

        .empty i {
            display: block;
            font-size: 2rem;
            margin-bottom: 10px;
            color: #2a3460;
        }

        /* ── Responsive ── */
        @media (max-width: 980px) {
            .admin-shell { flex-direction: column; }
            .sidebar { width: 100%; height: auto; position: static; }
            .topbar { flex-direction: column; align-items: flex-start; }
            .topbar h1 { font-size: 2.2rem; }
        }
    </style>
</head>
<body>

<div class="admin-shell">

    <!-- ══ SIDEBAR ══ -->
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
                <a href="<%= request.getContextPath() %>/user?action=addAdminForm">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Request New Admin</span>
                </a>

                <a class="active" href="<%= request.getContextPath() %>/user?action=listAdminRequests">
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
                <h1>Admin Requests</h1>
                <p class="subtitle">Welcome back, <strong><%= userName != null ? userName : "Admin" %></strong></p>
            </div>

            <div class="topbar-badge">
                <i class="fa-solid fa-shield-halved"></i>
                <span><%= UserService.permissionLabel(adminPermission) %></span>
            </div>
        </section>

        <section class="content-card">
            <h2>Pending Admin Requests</h2>
            <p>Review and approve or reject admin access requests submitted by full-access admins.</p>

            <% if ("requestSubmitted".equals(msg)) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    New admin request submitted successfully.
                </div>
            <% } else if ("approved".equals(msg)) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    Admin request approved successfully.
                </div>
            <% } else if ("rejected".equals(msg)) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    Admin request rejected successfully.
                </div>
            <% } %>

            <% if ("requestFailed".equals(error)) { %>
                <div class="alert alert-error">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>
                    Could not submit the admin request.
                </div>
            <% } else if ("approveFailed".equals(error)) { %>
                <div class="alert alert-error">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>
                    Approval failed. A requester cannot approve their own request, and the request may already be processed.
                </div>
            <% } else if ("rejectFailed".equals(error)) { %>
                <div class="alert alert-error">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>
                    Rejection failed. A requester cannot reject their own request, and the request may already be processed.
                </div>
            <% } %>

            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Request ID</th>
                            <th>Requested By</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Permission</th>
                            <th>Requested At</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (adminRequests.isEmpty()) { %>
                        <tr>
                            <td colspan="8" class="empty">
                                <i class="fa-solid fa-inbox"></i>
                                No pending admin requests found.
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Map<String, String> r : adminRequests) {
                            boolean ownRequest = currentAdminId != null && currentAdminId.equals(r.get("requesterAdminId"));
                        %>
                            <tr>
                                <td><strong><%= r.get("requestId") %></strong></td>
                                <td>
                                    <%= r.get("requesterAdminId") %>
                                    <% if (ownRequest) { %>
                                        <div style="margin-top:6px;">
                                            <span class="pill pill-self">
                                                <i class="fa-solid fa-user" style="margin-right:5px; font-size:0.7rem;"></i>
                                                Your request
                                            </span>
                                        </div>
                                    <% } %>
                                </td>
                                <td><%= r.get("requestedName") %></td>
                                <td><%= r.get("requestedEmail") %></td>
                                <td><%= r.get("requestedPhone") %></td>
                                <td>
                                    <span class="pill pill-perm">
                                        <%= UserService.permissionLabel(r.get("requestedPermission")) %>
                                    </span>
                                </td>
                                <td><%= r.get("requestedAt") %></td>
                                <td>
                                    <div class="actions">
                                        <% if (ownRequest) { %>
                                            <button type="button" class="btn btn-disabled" disabled>
                                                <i class="fa-solid fa-ban"></i>
                                                <span>Self approval blocked</span>
                                            </button>
                                        <% } else { %>
                                            <form action="<%= request.getContextPath() %>/user" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="approveAdminRequest">
                                                <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                                                <button type="submit" class="btn btn-approve">
                                                    <i class="fa-solid fa-check"></i>
                                                    <span>Approve</span>
                                                </button>
                                            </form>

                                            <form action="<%= request.getContextPath() %>/user" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="rejectAdminRequest">
                                                <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                                                <button type="submit" class="btn btn-reject">
                                                    <i class="fa-solid fa-xmark"></i>
                                                    <span>Reject</span>
                                                </button>
                                            </form>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

</body>
</html>
