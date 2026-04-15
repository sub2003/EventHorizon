<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhorizon.model.Admin" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String userName = currentSession != null ? (String) currentSession.getAttribute("userName") : null;
    String adminPermission = currentSession != null ? (String) currentSession.getAttribute("adminPermission") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (adminPermission == null || adminPermission.trim().isEmpty()) {
        adminPermission = Admin.FULL_ACCESS;
    }

    if (!UserService.hasFullAccess(adminPermission)) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=noFullAccess");
        return;
    }

    if (request.getAttribute("adminRequests") == null) {
        request.setAttribute("adminRequests", new java.util.ArrayList<>());
    }

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
    request.setAttribute("msg", msg);
    request.setAttribute("error", error);
    request.setAttribute("permissionLabel", UserService.permissionLabel(adminPermission));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Requests - EventHorizon</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .page-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 22px;
            padding: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.25);
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .page-header h2 {
            margin: 0;
            font-size: 2rem;
            color: #fff;
        }

        .page-header p {
            margin: 8px 0 0;
            color: #aab4d6;
        }

        .topbar-badge-lite {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 12px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.08);
            color: #fff;
        }

        .alert-box {
            padding: 14px 16px;
            border-radius: 14px;
            margin-bottom: 18px;
            font-weight: 700;
        }

        .alert-success-box {
            background: rgba(34,197,94,0.12);
            border: 1px solid rgba(34,197,94,0.24);
            color: #d1fadf;
        }

        .alert-error-box {
            background: rgba(239,68,68,0.12);
            border: 1px solid rgba(239,68,68,0.24);
            color: #ffd0d0;
        }

        .table-wrap-x {
            overflow-x: auto;
        }

        .request-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1200px;
        }

        .request-table th,
        .request-table td {
            padding: 16px 12px;
            text-align: left;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }

        .request-table th {
            color: #fff;
            text-transform: uppercase;
            font-size: 0.84rem;
            letter-spacing: 0.06em;
        }

        .mono-id {
            color: #7dd3fc;
            font-family: Consolas, monospace;
            font-weight: 700;
        }

        .perm-pill {
            display: inline-block;
            padding: 8px 14px;
            border-radius: 999px;
            font-size: 0.82rem;
            font-weight: 800;
            color: #facc15;
            background: rgba(245,158,11,0.16);
            border: 1px solid rgba(245,158,11,0.28);
        }

        .action-group {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .action-btn {
            border: none;
            border-radius: 12px;
            padding: 10px 14px;
            font-weight: 800;
            cursor: pointer;
            color: #fff;
        }

        .approve-btn {
            background: linear-gradient(135deg, #7c3aed, #6366f1);
        }

        .reject-btn {
            background: linear-gradient(135deg, #ef4444, #f97316);
        }

        .muted {
            color: #94a3b8;
            font-weight: 700;
        }
    </style>
</head>
<body>

<div class="admin-shell">
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
            <div style="padding:12px 14px; margin-bottom:12px; border-radius:12px; background:rgba(255,255,255,0.04); color:#cbd5e1; font-size:0.9rem;">
                <div style="font-size:0.75rem; text-transform:uppercase; opacity:0.75; margin-bottom:4px;">Permission</div>
                <strong>${permissionLabel}</strong>
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
                <p class="subtitle">Welcome, <strong><%= userName != null ? userName : "Admin" %></strong></p>
            </div>

            <div class="topbar-badge-lite">
                <i class="fa-solid fa-shield-halved"></i>
                <span>${permissionLabel}</span>
            </div>
        </section>

        <c:if test="${msg == 'approved'}">
            <div class="alert-box alert-success-box">Admin request approved successfully.</div>
        </c:if>

        <c:if test="${msg == 'rejected'}">
            <div class="alert-box alert-success-box">Admin request rejected successfully.</div>
        </c:if>

        <c:if test="${error == 'approveFailed'}">
            <div class="alert-box alert-error-box">Approval failed. You cannot approve your own admin request.</div>
        </c:if>

        <c:if test="${error == 'rejectFailed'}">
            <div class="alert-box alert-error-box">Rejection failed. You cannot reject your own admin request.</div>
        </c:if>

        <div class="page-card">
            <div class="page-header">
                <div>
                    <h2>Pending Admin Requests</h2>
                    <p>Review and approve or reject admin access requests.</p>
                </div>
            </div>

            <div class="table-wrap-x">
                <table class="request-table">
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
                    <c:forEach var="r" items="${adminRequests}">
                        <tr>
                            <td class="mono-id">${r.requestId}</td>
                            <td>${r.requesterAdminId}</td>
                            <td>${r.requestedName}</td>
                            <td>${r.requestedEmail}</td>
                            <td>${r.requestedPhone}</td>
                            <td><span class="perm-pill">${r.requestedPermission}</span></td>
                            <td>${r.requestedAt}</td>
                            <td>
                                <div class="action-group">
                                    <form method="post" action="<%= request.getContextPath() %>/user" style="margin:0;">
                                        <input type="hidden" name="action" value="approveAdminRequest">
                                        <input type="hidden" name="requestId" value="${r.requestId}">
                                        <button type="submit" class="action-btn approve-btn">Approve</button>
                                    </form>

                                    <form method="post" action="<%= request.getContextPath() %>/user" style="margin:0;"
                                          onsubmit="return confirm('Reject this admin request?');">
                                        <input type="hidden" name="action" value="rejectAdminRequest">
                                        <input type="hidden" name="requestId" value="${r.requestId}">
                                        <button type="submit" class="action-btn reject-btn">Reject</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty adminRequests}">
                        <tr>
                            <td colspan="8" class="muted" style="padding:24px;">No pending admin requests found.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

</body>
</html>