<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String userName = currentSession != null ? (String) currentSession.getAttribute("userName") : null;
    String currentAdminId = currentSession != null ? (String) currentSession.getAttribute("userId") : null;
    String adminPermission = currentSession != null ? (String) currentSession.getAttribute("adminPermission") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role) || !"FULL_ACCESS".equals(adminPermission)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, String>> adminRequests = (List<Map<String, String>>) request.getAttribute("adminRequests");
    if (adminRequests == null) adminRequests = new java.util.ArrayList<>();

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Requests - EventHorizon</title>
    <style>
        * { box-sizing: border-box; font-family: Arial, sans-serif; }
        body {
            margin: 0;
            background: radial-gradient(circle at top, #0d1635 0%, #050816 55%, #030611 100%);
            color: #eef2ff;
        }
        .wrapper { display: flex; min-height: 100vh; }
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
            background: linear-gradient(135deg, rgba(25,32,67,0.95), rgba(12,19,44,0.92));
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 28px;
            padding: 26px;
            box-shadow: 0 18px 48px rgba(0,0,0,0.28);
        }
        .card h2 {
            margin: 0 0 10px;
            font-size: 34px;
            font-weight: 900;
        }
        .card p {
            color: #9ca9d9;
            margin-bottom: 20px;
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
        .table-wrap {
            overflow-x: auto;
            border-radius: 18px;
            border: 1px solid rgba(255,255,255,0.06);
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
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }
        tbody td {
            padding: 16px 14px;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            color: #eef2ff;
            vertical-align: top;
        }
        .pill {
            display: inline-block;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,0.07);
            font-size: 12px;
            font-weight: 800;
        }
        .pill-self {
            background: rgba(255, 99, 132, 0.14);
            color: #ffb4c4;
        }
        .pill-perm {
            background: rgba(124,92,255,0.16);
            color: #d2c7ff;
        }
        .actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn {
            border: none;
            border-radius: 12px;
            padding: 10px 14px;
            font-weight: 800;
            cursor: pointer;
        }
        .btn-approve {
            background: linear-gradient(90deg, #19c37d, #2ed573);
            color: #fff;
        }
        .btn-reject {
            background: linear-gradient(90deg, #ff5f6d, #c44569);
            color: #fff;
        }
        .btn-disabled {
            background: rgba(255,255,255,0.08);
            color: #9aa7d7;
            cursor: not-allowed;
        }
        .empty {
            padding: 24px 10px;
            color: #9ca9d9;
            font-weight: 700;
        }
        @media (max-width: 900px) {
            .wrapper { flex-direction: column; }
            .sidebar { width: 100%; }
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
                <a href="<%= request.getContextPath() %>/user?action=addAdminForm">Request New Admin</a>
                <a class="active" href="<%= request.getContextPath() %>/user?action=listAdminRequests">Admin Requests</a>
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
        <h1 class="page-title">Admin Requests</h1>
        <div class="page-subtitle">Welcome, <%= userName %></div>
        <div class="access-badge">Full Access</div>

        <section class="card">
            <h2>Pending Admin Requests</h2>
            <p>Review and approve or reject admin access requests.</p>

            <% if ("requestSubmitted".equals(msg)) { %>
                <div class="alert alert-success">New admin request submitted successfully.</div>
            <% } else if ("approved".equals(msg)) { %>
                <div class="alert alert-success">Admin request approved successfully.</div>
            <% } else if ("rejected".equals(msg)) { %>
                <div class="alert alert-success">Admin request rejected successfully.</div>
            <% } %>

            <% if ("requestFailed".equals(error)) { %>
                <div class="alert alert-error">Could not submit the admin request.</div>
            <% } else if ("approveFailed".equals(error)) { %>
                <div class="alert alert-error">Approval failed. A requester cannot approve their own request, and the request may already be processed.</div>
            <% } else if ("rejectFailed".equals(error)) { %>
                <div class="alert alert-error">Rejection failed. A requester cannot reject their own request, and the request may already be processed.</div>
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
                            <td colspan="8" class="empty">No pending admin requests found.</td>
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
                                        <div class="pill pill-self" style="margin-top:8px;">Your request</div>
                                    <% } %>
                                </td>
                                <td><%= r.get("requestedName") %></td>
                                <td><%= r.get("requestedEmail") %></td>
                                <td><%= r.get("requestedPhone") %></td>
                                <td><span class="pill pill-perm"><%= UserService.permissionLabel(r.get("requestedPermission")) %></span></td>
                                <td><%= r.get("requestedAt") %></td>
                                <td>
                                    <div class="actions">
                                        <% if (ownRequest) { %>
                                            <button type="button" class="btn btn-disabled" disabled>Self approval blocked</button>
                                        <% } else { %>
                                            <form action="<%= request.getContextPath() %>/user" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="approveAdminRequest">
                                                <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                                                <button type="submit" class="btn btn-approve">Approve</button>
                                            </form>

                                            <form action="<%= request.getContextPath() %>/user" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="rejectAdminRequest">
                                                <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                                                <button type="submit" class="btn btn-reject">Reject</button>
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