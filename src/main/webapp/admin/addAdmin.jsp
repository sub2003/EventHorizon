<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhorizon.model.Admin" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String userName = currentSession != null ? (String) currentSession.getAttribute("userName") : null;
    String adminPermission = currentSession != null ? (String) currentSession.getAttribute("adminPermission") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role) || !UserService.canRequestAdmin(adminPermission)) {
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request New Admin - EventHorizon</title>

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

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
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
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 700;
            color: #dbe5ff;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        .field input,
        .field select {
            width: 100%;
            height: 52px;
            border-radius: 14px;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(7, 11, 26, 0.9);
            color: var(--text);
            padding: 0 16px;
            font-size: 15px;
            outline: none;
            transition: all 0.25s ease;
        }

        .field input::placeholder {
            color: #7481a7;
        }

        .field select option {
            background: #0b1023;
            color: #f5f7ff;
        }

        .field input:focus,
        .field select:focus {
            border-color: rgba(139, 92, 246, 0.5);
            box-shadow: 0 0 0 4px rgba(139, 92, 246, 0.14);
        }

        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 24px;
        }

        @media (max-width: 900px) {
            .form-grid {
                grid-template-columns: 1fr;
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
                <a class="active" href="<%= request.getContextPath() %>/user?action=addAdminForm">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Request New Admin</span>
                </a>

                <% if (hasFullAccess) { %>
                <a href="<%= request.getContextPath() %>/user?action=listAdminRequests">
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
            <p>Submit a new admin access request. Only a Core Admin can approve or reject a pending admin request.</p>

            <% if ("requestSubmitted".equals(msg)) { %>
                <div class="alert alert-success" style="margin-bottom:18px;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>
                    Admin request submitted successfully. A Core Admin can now review it.
                </div>
            <% } %>

            <% if ("requestFailed".equals(error)) { %>
                <div class="alert alert-danger" style="margin-bottom:18px;">
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
                            <option value="CORE_ADMIN">Core Admin</option>
                            <option value="EVENTS_BOOKINGS_REQUEST_ADMIN">Events + Bookings + New Admin Requests</option>
                            <option value="EVENTS_ONLY">Events Only</option>
                            <option value="BOOKINGS_ONLY">Bookings Only</option>
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
