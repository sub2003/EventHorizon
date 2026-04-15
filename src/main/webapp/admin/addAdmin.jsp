<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhorizon.model.Admin" %>
<%@ page import="com.eventhorizon.service.UserService" %>

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

    String error = request.getParameter("error");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request New Admin - EventHorizon</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .page-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 22px;
            padding: 28px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.25);
            max-width: 950px;
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

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #cbd5e1;
            font-weight: 700;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 14px 14px;
            border-radius: 14px;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(0,0,0,0.25);
            color: white;
            outline: none;
            box-sizing: border-box;
        }

        .submit-row {
            margin-top: 22px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .primary-btn-custom,
        .secondary-btn-custom {
            border: none;
            border-radius: 14px;
            padding: 13px 18px;
            font-weight: 800;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .primary-btn-custom {
            color: #fff;
            background: linear-gradient(135deg, #7c3aed, #06b6d4);
        }

        .secondary-btn-custom {
            color: #e2e8f0;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.08);
        }

        .helper-text {
            color: #94a3b8;
            line-height: 1.7;
            margin-top: 8px;
            margin-bottom: 22px;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
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
                <h1>Request New Admin</h1>
                <p class="subtitle">Welcome, <strong><%= userName != null ? userName : "Admin" %></strong></p>
            </div>

            <div class="topbar-badge-lite">
                <i class="fa-solid fa-shield-halved"></i>
                <span><%= UserService.permissionLabel(adminPermission) %></span>
            </div>
        </section>

        <% if ("submitted".equals(msg)) { %>
            <div class="alert-box alert-success-box">Admin request submitted successfully. Another admin can now review it.</div>
        <% } %>

        <% if ("emailExists".equals(error)) { %>
            <div class="alert-box alert-error-box">That email is already used by another account or request.</div>
        <% } else if ("invalidPermission".equals(error)) { %>
            <div class="alert-box alert-error-box">Please choose a valid permission type.</div>
        <% } else if ("failed".equals(error)) { %>
            <div class="alert-box alert-error-box">Request creation failed. Please try again.</div>
        <% } %>

        <div class="page-card">
            <h2 style="margin:0 0 10px; color:#fff; font-size:2rem;">New Admin Request Form</h2>
            <p class="helper-text">
                Submit a new admin access request. The request will stay pending until another full-access admin reviews it.
            </p>

            <form method="post" action="<%= request.getContextPath() %>/user">
                <input type="hidden" name="action" value="submitAdminRequest">

                <div class="form-grid">
                    <div class="form-group">
                        <label for="name">Full Name</label>
                        <input type="text" id="name" name="name" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Temporary Password</label>
                        <input type="text" id="password" name="password" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" name="phone" required>
                    </div>

                    <div class="form-group full">
                        <label for="permission">Permission Type</label>
                        <select id="permission" name="permission" required>
                            <option value="">Select permission</option>
                            <option value="BOOKINGS_ONLY">Bookings Only</option>
                            <option value="EVENTS_ONLY">Events Only</option>
                            <option value="EVENTS_BOOKINGS">Events and Bookings</option>
                            <option value="FULL_ACCESS">Full Access</option>
                        </select>
                    </div>
                </div>

                <div class="submit-row">
                    <button type="submit" class="primary-btn-custom">
                        <i class="fa-solid fa-paper-plane"></i>
                        <span>Submit Request</span>
                    </button>

                    <a href="<%= request.getContextPath() %>/user?action=listAdminRequests" class="secondary-btn-custom">
                        <i class="fa-solid fa-list"></i>
                        <span>View Pending Requests</span>
                    </a>
                </div>
            </form>
        </div>
    </main>
</div>

</body>
</html>