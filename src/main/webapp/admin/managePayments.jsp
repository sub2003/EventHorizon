<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.Booking" %>
<%@ page import="com.eventhorizon.model.Admin" %>
<%@ page import="com.eventhorizon.service.UserService" %>

<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String adminPermission = currentSession != null ? (String) currentSession.getAttribute("adminPermission") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (adminPermission == null || adminPermission.trim().isEmpty()) {
        adminPermission = Admin.FULL_ACCESS;
    }

    if (!UserService.hasBookingAccess(adminPermission)) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=noBookingPermission");
        return;
    }

    List<Booking> pendingBookings = (List<Booking>) request.getAttribute("pendingBookings");
    if (pendingBookings == null) pendingBookings = new java.util.ArrayList<>();

    String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Payments - EventHorizon</title>

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

        .table-wrap {
            overflow-x: auto;
        }

        .payment-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1250px;
        }

        .payment-table th,
        .payment-table td {
            padding: 16px 12px;
            text-align: left;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }

        .payment-table th {
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

        .reference-box {
            max-width: 280px;
            word-break: break-word;
            color: #fde68a;
            font-weight: 700;
            line-height: 1.5;
        }

        .status-pill {
            display: inline-block;
            padding: 8px 14px;
            border-radius: 999px;
            font-size: 0.82rem;
            font-weight: 800;
        }

        .status-pending {
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
            background: linear-gradient(135deg, #059669, #10b981);
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

                <% if (UserService.hasFullAccess(adminPermission)) { %>
                <a href="<%= request.getContextPath() %>/user?action=list">
                    <i class="fa-solid fa-users"></i>
                    <span>Manage Users</span>
                </a>
                <% } %>

                <% if (UserService.hasEventAccess(adminPermission)) { %>
                <a href="<%= request.getContextPath() %>/event?action=adminList">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Manage Events</span>
                </a>
                <% } %>

                <a href="<%= request.getContextPath() %>/booking?action=allBookings">
                    <i class="fa-solid fa-ticket"></i>
                    <span>Bookings</span>
                </a>

                <a class="active" href="<%= request.getContextPath() %>/booking?action=pendingPayments">
                    <i class="fa-solid fa-money-check-dollar"></i>
                    <span>Manage Payments</span>
                </a>

                <% if (UserService.hasFullAccess(adminPermission)) { %>
                <a href="<%= request.getContextPath() %>/user?action=addAdminForm">
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

    <main class="main-content">
        <section class="topbar">
            <div>
                <p class="eyebrow">Payment Review</p>
                <h1>Pending Payments</h1>
                <p class="subtitle">Check each reference number manually and approve or reject it.</p>
            </div>

            <div class="topbar-badge-lite">
                <i class="fa-solid fa-shield-halved"></i>
                <span><%= UserService.permissionLabel(adminPermission) %></span>
            </div>
        </section>

        <% if ("approved".equals(msg)) { %>
            <div class="alert-box alert-success-box">Payment approved successfully.</div>
        <% } else if ("rejected".equals(msg)) { %>
            <div class="alert-box alert-success-box">Payment rejected. Booking was cancelled and seats were restored.</div>
        <% } else if ("error".equals(msg)) { %>
            <div class="alert-box alert-error-box">Action failed. Please try again.</div>
        <% } %>

        <div class="page-card">
            <div class="page-header">
                <div>
                    <h2>Pending Reference Checks</h2>
                    <p>Only pending customer payment references are shown here.</p>
                </div>
            </div>

            <div class="table-wrap">
                <table class="payment-table">
                    <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Customer ID</th>
                        <th>Event</th>
                        <th>Tickets</th>
                        <th>Total</th>
                        <th>Date</th>
                        <th>Reference Number</th>
                        <th>Status</th>
                        <th>Decision</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Booking b : pendingBookings) { %>
                        <tr>
                            <td class="mono-id"><%= b.getBookingId() %></td>
                            <td><%= b.getCustomerId() %></td>
                            <td><%= b.getEventTitle() %></td>
                            <td><%= b.getNumberOfTickets() %></td>
                            <td>LKR <%= String.format("%.1f", b.getTotalAmount()) %></td>
                            <td><%= b.getBookingDate() %></td>
                            <td>
                                <div class="reference-box">
                                    <%= (b.getPaymentReference() != null && !b.getPaymentReference().trim().isEmpty())
                                            ? b.getPaymentReference()
                                            : "No reference given" %>
                                </div>
                            </td>
                            <td>
                                <span class="status-pill status-pending">PENDING</span>
                            </td>
                            <td>
                                <div class="action-group">
                                    <form method="post" action="<%= request.getContextPath() %>/booking" style="margin:0;">
                                        <input type="hidden" name="action" value="approvePayment">
                                        <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                        <button type="submit" class="action-btn approve-btn">Approve</button>
                                    </form>

                                    <form method="post" action="<%= request.getContextPath() %>/booking" style="margin:0;"
                                          onsubmit="return confirm('Reject this reference and cancel the booking?');">
                                        <input type="hidden" name="action" value="rejectPayment">
                                        <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                        <button type="submit" class="action-btn reject-btn">Reject</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>

                    <% if (pendingBookings.isEmpty()) { %>
                        <tr>
                            <td colspan="9" class="muted" style="padding:24px;">No pending payments found.</td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

</body>
</html>