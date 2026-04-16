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

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .content-card {
            background: linear-gradient(135deg, rgba(18, 24, 56, 0.92), rgba(10, 16, 38, 0.94));
            border: 1px solid var(--line);
            border-radius: 24px;
            padding: 28px;
            box-shadow: var(--shadow);
        }
        .content-card h2 { font-size: 26px; margin-bottom: 8px; }
        .content-card > p { color: var(--muted); margin-bottom: 20px; line-height: 1.6; }

        /* Table */
        .table-wrap {
            overflow-x: auto;
            border-radius: 16px;
            border: 1px solid var(--line);
            background: rgba(2, 6, 18, 0.50);
        }
        table { width: 100%; border-collapse: collapse; min-width: 960px; }

        thead th {
            background: linear-gradient(135deg, var(--purple-2), var(--cyan));
            color: #fff;
            text-align: left;
            padding: 15px 14px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.7px;
        }
        thead th:first-child { border-radius: 16px 0 0 0; }
        thead th:last-child  { border-radius: 0 16px 0 0; }

        tbody tr { transition: background 0.15s; }
        tbody tr:hover { background: rgba(139, 92, 246, 0.06); }

        tbody td {
            padding: 14px;
            border-bottom: 1px solid var(--line);
            color: var(--text);
            vertical-align: middle;
            font-size: 14px;
        }
        tbody tr:last-child td { border-bottom: none; }

        /* Pills */
        .pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 11px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
        }
        .pill-self {
            background: rgba(239, 68, 68, 0.14);
            border: 1px solid rgba(239, 68, 68, 0.22);
            color: #ffd0d0;
        }
        .pill-perm {
            background: rgba(139, 92, 246, 0.16);
            border: 1px solid rgba(139, 92, 246, 0.24);
            color: #d4c6ff;
        }

        /* Action buttons */
        .row-actions { display: flex; gap: 8px; flex-wrap: wrap; }

        .btn-approve,
        .btn-reject,
        .btn-blocked {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 700;
            border: none;
            cursor: pointer;
            font-family: "Segoe UI", Arial, sans-serif;
            transition: opacity 0.2s, transform 0.15s;
        }
        .btn-approve:hover,
        .btn-reject:hover { opacity: 0.85; transform: translateY(-1px); }

        .btn-approve {
            background: linear-gradient(135deg, #16a34a, #22c55e);
            color: #fff;
            box-shadow: 0 6px 16px rgba(34, 197, 94, 0.22);
        }
        .btn-reject {
            background: linear-gradient(135deg, var(--danger), #f87171);
            color: #fff;
            box-shadow: 0 6px 16px rgba(239, 68, 68, 0.22);
        }
        .btn-blocked {
            background: rgba(255,255,255,0.05);
            color: #5a6a8a;
            border: 1px solid var(--line);
            cursor: not-allowed;
        }

        .empty-row td {
            padding: 40px 14px;
            text-align: center;
            color: var(--muted);
            font-size: 15px;
        }
        .empty-row i { display: block; font-size: 28px; margin-bottom: 10px; color: #2a3460; }
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
                <a class="active" href="<%= request.getContextPath() %>/user?action=listAdminRequests">
                    <i class="fa-solid fa-user-check"></i>
                    <span>Admin Requests</span>
                </a>

                <a href="<%= request.getContextPath() %>/user?action=addAdminForm">
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
                <h1>Admin Requests</h1>
            </div>
            <div class="topbar-user">
                Welcome, <strong><%= userName != null ? userName : "Admin" %></strong>
            </div>
        </div>

        <section class="content-card">
            <h2>Pending Admin Requests</h2>
            <p>Review and approve or reject admin access requests submitted by full-access admins.</p>

            <% if ("requestSubmitted".equals(msg)) { %>
                <div class="alert alert-success" style="margin-bottom:16px;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    New admin request submitted successfully.
                </div>
            <% } else if ("approved".equals(msg)) { %>
                <div class="alert alert-success" style="margin-bottom:16px;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    Admin request approved successfully.
                </div>
            <% } else if ("rejected".equals(msg)) { %>
                <div class="alert alert-success" style="margin-bottom:16px;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    Admin request rejected successfully.
                </div>
            <% } %>

            <% if ("requestFailed".equals(error)) { %>
                <div class="alert alert-danger" style="margin-bottom:16px;">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>
                    Could not submit the admin request.
                </div>
            <% } else if ("approveFailed".equals(error)) { %>
                <div class="alert alert-danger" style="margin-bottom:16px;">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>
                    Approval failed. A requester cannot approve their own request, and the request may already be processed.
                </div>
            <% } else if ("rejectFailed".equals(error)) { %>
                <div class="alert alert-danger" style="margin-bottom:16px;">
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
                        <tr class="empty-row">
                            <td colspan="8">
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
                                                <i class="fa-solid fa-user" style="font-size:10px;"></i>
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
                                    <div class="row-actions">
                                        <% if (ownRequest) { %>
                                            <button type="button" class="btn-blocked" disabled>
                                                <i class="fa-solid fa-ban"></i>
                                                <span>Self approval blocked</span>
                                            </button>
                                        <% } else { %>
                                            <form action="<%= request.getContextPath() %>/user" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="approveAdminRequest">
                                                <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                                                <button type="submit" class="btn-approve">
                                                    <i class="fa-solid fa-check"></i>
                                                    <span>Approve</span>
                                                </button>
                                            </form>
                                            <form action="<%= request.getContextPath() %>/user" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="rejectAdminRequest">
                                                <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                                                <button type="submit" class="btn-reject">
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
