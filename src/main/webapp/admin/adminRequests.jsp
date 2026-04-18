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

    if (currentSession == null || role == null || !"ADMIN".equals(role) || !UserService.hasFullAccess(adminPermission)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (adminPermission == null || adminPermission.trim().isEmpty()) {
        adminPermission = Admin.CORE_ADMIN;
    }

    boolean canManageEvents = UserService.hasEventAccess(adminPermission);
    boolean canManageBookings = UserService.hasBookingAccess(adminPermission);
    boolean hasFullAccess = UserService.hasFullAccess(adminPermission);

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");

    List<Map<String, String>> list =
            (List<Map<String, String>>) request.getAttribute("adminRequests");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Requests - EventHorizon</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .content-card {
            background: linear-gradient(180deg, rgba(255,255,255,0.045), rgba(255,255,255,0.025));
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 24px;
            padding: 28px;
            box-shadow: var(--shadow);
            position: relative;
            z-index: 2;
        }

        .content-card h2 {
            font-size: 28px;
            margin-bottom: 10px;
            color: var(--text);
        }

        .content-card > p {
            color: var(--muted);
            line-height: 1.6;
            margin-bottom: 22px;
        }

        .table-wrap {
            overflow-x: auto;
            border-radius: 18px;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(7, 11, 26, 0.55);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1100px;
        }

        .data-table thead th {
            text-align: left;
            padding: 16px 14px;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: #eef2ff;
            background: rgba(91, 33, 182, 0.22);
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }

        .data-table tbody td {
            padding: 16px 14px;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            color: var(--text);
            vertical-align: middle;
        }

        .data-table tbody tr:hover {
            background: rgba(255,255,255,0.025);
        }

        .permission-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            color: #ddd6fe;
            background: rgba(91, 33, 182, 0.22);
            border: 1px solid rgba(167, 139, 250, 0.22);
            white-space: nowrap;
        }

        .action-group {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .action-group form {
            margin: 0;
        }

        .approve-btn,
        .reject-btn {
            border: none;
            border-radius: 12px;
            padding: 10px 14px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.25s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .approve-btn {
            color: #ffffff;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.22);
        }

        .approve-btn:hover {
            transform: translateY(-1px);
            opacity: 0.96;
        }

        .reject-btn {
            color: #ffffff;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            box-shadow: 0 10px 20px rgba(239, 68, 68, 0.22);
        }

        .reject-btn:hover {
            transform: translateY(-1px);
            opacity: 0.96;
        }

        .empty-cell {
            text-align: center;
            color: #94a3b8 !important;
            padding: 28px !important;
            font-weight: 600;
        }

        @media (max-width: 900px) {
            .action-group {
                flex-direction: column;
                align-items: stretch;
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

                <% if (UserService.canRequestAdmin(adminPermission)) { %>
                <a href="<%= request.getContextPath() %>/user?action=addAdminForm">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Request New Admin</span>
                </a>

                <% if (hasFullAccess) { %>
                <a class="active" href="<%= request.getContextPath() %>/user?action=listAdminRequests">
                    <i class="fa-solid fa-user-check"></i>
                    <span>Admin Requests</span>
                </a>
                <% } %>
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
            <p>Review and approve or reject admin access requests.</p>

            <% if ("approved".equals(msg)) { %>
                <div class="alert alert-success" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    Admin request approved successfully.
                </div>
            <% } %>

            <% if ("rejected".equals(msg)) { %>
                <div class="alert alert-success" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    Admin request rejected successfully.
                </div>
            <% } %>

            <% if ("approveFailed".equals(error)) { %>
                <div class="alert alert-danger" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>
                    Failed to approve request.
                </div>
            <% } %>

            <% if ("rejectFailed".equals(error)) { %>
                <div class="alert alert-danger" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>
                    Failed to reject request.
                </div>
            <% } %>

            <div class="table-wrap">
                <table class="data-table">
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
                    <% if (list != null && !list.isEmpty()) {
                        for (Map<String, String> r : list) { %>
                        <tr>
                            <td><%= r.get("requestId") %></td>
                            <td><%= r.get("requesterAdminId") %></td>
                            <td><%= r.get("requestedName") %></td>
                            <td><%= r.get("requestedEmail") %></td>
                            <td><%= r.get("requestedPhone") %></td>
                            <td>
                                <span class="permission-badge">
                                    <%= UserService.permissionLabel(r.get("requestedPermission")) %>
                                </span>
                            </td>
                            <td><%= r.get("requestedAt") %></td>
                            <td>
                                <div class="action-group">
                                    <form action="<%= request.getContextPath() %>/user" method="post">
                                        <input type="hidden" name="action" value="approveAdminRequest">
                                        <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                                        <button type="submit" class="approve-btn"
                                                onclick="return confirm('Approve this admin request?');">
                                            <i class="fa-solid fa-check"></i>
                                            <span>Approve</span>
                                        </button>
                                    </form>

                                    <form action="<%= request.getContextPath() %>/user" method="post">
                                        <input type="hidden" name="action" value="rejectAdminRequest">
                                        <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                                        <button type="submit" class="reject-btn"
                                                onclick="return confirm('Reject this admin request?');">
                                            <i class="fa-solid fa-xmark"></i>
                                            <span>Reject</span>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <%  }
                       } else { %>
                        <tr>
                            <td colspan="8" class="empty-cell">No pending admin requests.</td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

</body>
</html>