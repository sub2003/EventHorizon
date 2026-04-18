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

    List<Map<String, String>> adminRequests = (List<Map<String, String>>) request.getAttribute("adminRequests");
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

        .table-wrap table {
            width: 100%;
            min-width: 980px;
            border-collapse: collapse;
        }

        .table-wrap thead th {
            background: rgba(139, 92, 246, 0.14);
            color: #dbe5ff;
            padding: 15px 14px;
            text-align: left;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }

        .table-wrap tbody tr {
            border-bottom: 1px solid rgba(255,255,255,0.06);
            transition: background 0.2s ease;
        }

        .table-wrap tbody tr:hover {
            background: rgba(139, 92, 246, 0.06);
        }

        .table-wrap tbody td {
            padding: 15px 14px;
            color: var(--text);
            vertical-align: top;
        }

        .pill {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .pill-self {
            background: rgba(236, 72, 153, 0.14);
            border: 1px solid rgba(236, 72, 153, 0.22);
            color: #f9a8d4;
        }

        .pill-perm {
            background: rgba(139, 92, 246, 0.16);
            border: 1px solid rgba(139, 92, 246, 0.22);
            color: #d8c9ff;
        }

        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            border-radius: 12px;
            padding: 10px 14px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s ease, opacity 0.2s ease;
            text-decoration: none;
        }

        .btn:hover {
            transform: translateY(-1px);
            opacity: 0.92;
        }

        .btn-approve {
            background: rgba(34, 197, 94, 0.18);
            color: #d1fadf;
            border: 1px solid rgba(34, 197, 94, 0.24);
        }

        .btn-reject {
            background: rgba(239, 68, 68, 0.16);
            color: #ffd0d0;
            border: 1px solid rgba(239, 68, 68, 0.24);
        }

        .btn-disabled {
            background: rgba(255,255,255,0.06);
            color: #aab4d6;
            border: 1px solid rgba(255,255,255,0.08);
            cursor: not-allowed;
        }

        .empty {
            text-align: center;
            color: var(--muted);
            padding: 30px 18px !important;
            font-weight: 600;
        }

        .empty i {
            display: block;
            font-size: 28px;
            margin-bottom: 10px;
            color: #7c8bc0;
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
            <p>Review and approve or reject admin access requests submitted by full-access admins.</p>

            <% if ("requestSubmitted".equals(msg)) { %>
                <div class="alert alert-success" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    New admin request submitted successfully.
                </div>
            <% } else if ("approved".equals(msg)) { %>
                <div class="alert alert-success" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    Admin request approved successfully.
                </div>
            <% } else if ("rejected".equals(msg)) { %>
                <div class="alert alert-success" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    Admin request rejected successfully.
                </div>
            <% } %>

            <% if ("requestFailed".equals(error)) { %>
                <div class="alert alert-danger" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>
                    Could not submit the admin request.
                </div>
            <% } else if ("approveFailed".equals(error)) { %>
                <div class="alert alert-danger" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>
                    Approval failed. A requester cannot approve their own request, and the request may already be processed.
                </div>
            <% } else if ("rejectFailed".equals(error)) { %>
                <div class="alert alert-danger" style="margin-bottom:18px;">
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
                                                <i class="fa-solid fa-user" style="margin-right:5px; font-size:11px;"></i>
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
