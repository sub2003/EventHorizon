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
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(255,255,255,0.05);
            color: #e2e8f0;
        }

        .content-card {
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

        .table-wrap {
            overflow-x: auto;
            border-radius: 18px;
            border: 1px solid rgba(255,255,255,0.06);
            background: rgba(2, 6, 23, 0.32);
        }

        table {
            width: 100%;
            min-width: 1100px;
            border-collapse: collapse;
        }

        thead th {
            text-align: left;
            padding: 16px 14px;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: #dbeafe;
            background: linear-gradient(90deg, rgba(124,92,255,0.92), rgba(34,199,255,0.88));
        }

        tbody td {
            padding: 16px 14px;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            vertical-align: top;
            color: #e5eefc;
            font-size: 14px;
        }

        tbody tr:hover {
            background: rgba(255,255,255,0.025);
        }

        .pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            border: 1px solid transparent;
        }

        .pill-self {
            background: rgba(244, 114, 182, 0.14);
            border-color: rgba(244, 114, 182, 0.18);
            color: #f9a8d4;
            margin-top: 8px;
        }

        .pill-perm {
            background: rgba(124,92,255,0.16);
            border-color: rgba(124,92,255,0.22);
            color: #ddd6fe;
        }

        .actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 40px;
            padding: 0 14px;
            border-radius: 12px;
            border: 1px solid transparent;
            font-weight: 800;
            font-size: 13px;
            cursor: pointer;
        }

        .btn-approve {
            background: linear-gradient(90deg, #16a34a, #22c55e);
            color: #ffffff;
            box-shadow: 0 10px 24px rgba(34, 197, 94, 0.16);
        }

        .btn-reject {
            background: linear-gradient(90deg, #ef4444, #dc2626);
            color: #ffffff;
            box-shadow: 0 10px 24px rgba(239, 68, 68, 0.14);
        }

        .btn-disabled {
            background: rgba(255,255,255,0.06);
            color: #94a3b8;
            border-color: rgba(255,255,255,0.08);
            cursor: not-allowed;
        }

        .empty {
            text-align: center;
            padding: 28px 14px;
            color: #94a3b8;
            font-weight: 700;
        }

        @media (max-width: 1024px) {
            .topbar {
                flex-direction: column;
                align-items: flex-start;
            }

            .topbar-badge {
                margin-top: 0;
            }

            .hero-panel {
                flex-direction: column;
                align-items: flex-start;
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
                <a href="<%= request.getContextPath() %>/user?action=addAdminForm">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Request New Admin</span>
                </a>
                <a class="active" href="<%= request.getContextPath() %>/user?action=listAdminRequests">
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
                <h1>Admin Requests</h1>
                <p class="subtitle">Welcome back, <strong><%= userName != null ? userName : "Admin" %></strong></p>
            </div>

            <div class="topbar-badge">
                <i class="fa-solid fa-shield-halved"></i>
                <span><%= UserService.permissionLabel(adminPermission) %></span>
            </div>
        </section>

        <section class="hero-panel">
            <div class="hero-text">
                <h2>Review pending admin requests</h2>
                <p>Approve or reject pending admin access requests while keeping self-approval blocked exactly as before.</p>
            </div>

            <div class="hero-actions">
                <a href="<%= request.getContextPath() %>/user?action=addAdminForm" class="secondary-btn">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Request New Admin</span>
                </a>
            </div>
        </section>

        <section class="content-card">
            <h2>Pending Admin Requests</h2>
            <p class="section-text">This page has been visually aligned to the dashboard theme and sidebar only. Approval and rejection behavior remain unchanged.</p>

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
                                        <div class="pill pill-self">Your request</div>
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
                                            <button type="button" class="btn btn-disabled" disabled>
                                                <i class="fa-solid fa-lock"></i>
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
