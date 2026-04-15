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

    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    if (bookings == null) bookings = new java.util.ArrayList<>();

    String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookings - EventHorizon</title>

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

        .search-box input {
            min-width: 280px;
            padding: 12px 14px;
            border-radius: 14px;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(0,0,0,0.25);
            color: white;
            outline: none;
        }

        .alert-box {
            padding: 14px 16px;
            border-radius: 14px;
            margin-bottom: 18px;
            font-weight: 600;
        }

        .alert-success-box {
            background: rgba(34,197,94,0.12);
            border: 1px solid rgba(34,197,94,0.22);
            color: #d1fadf;
        }

        .alert-error-box {
            background: rgba(239,68,68,0.12);
            border: 1px solid rgba(239,68,68,0.22);
            color: #ffd0d0;
        }

        .booking-table-wrap {
            overflow-x: auto;
        }

        .booking-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1400px;
        }

        .booking-table thead th {
            text-align: left;
            color: white;
            padding: 14px 12px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            text-transform: uppercase;
            font-size: 0.84rem;
            letter-spacing: 0.06em;
        }

        .booking-table tbody td {
            padding: 16px 12px;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            color: #eef2ff;
            vertical-align: middle;
        }

        .mono-id {
            color: #7dd3fc;
            font-family: Consolas, monospace;
            font-weight: 700;
        }

        .status-pill,
        .payment-pill {
            display: inline-block;
            padding: 8px 14px;
            border-radius: 999px;
            font-size: 0.82rem;
            font-weight: 700;
        }

        .confirmed-pill {
            color: #5eead4;
            background: rgba(16,185,129,0.16);
            border: 1px solid rgba(16,185,129,0.28);
        }

        .cancelled-pill {
            color: #fca5a5;
            background: rgba(239,68,68,0.16);
            border: 1px solid rgba(239,68,68,0.28);
        }

        .pending-pill {
            color: #fbbf24;
            background: rgba(245,158,11,0.16);
            border: 1px solid rgba(245,158,11,0.28);
        }

        .approved-pill {
            color: #6ee7b7;
            background: rgba(34,197,94,0.16);
            border: 1px solid rgba(34,197,94,0.28);
        }

        .rejected-pill {
            color: #fda4af;
            background: rgba(225,29,72,0.16);
            border: 1px solid rgba(225,29,72,0.28);
        }

        .reference-box {
            max-width: 260px;
            word-break: break-word;
            color: #fde68a;
            font-weight: 600;
            line-height: 1.5;
        }

        .reference-empty {
            color: #94a3b8;
        }

        .action-cell {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }

        .inline-form {
            margin: 0;
        }

        .action-btn {
            border: none;
            border-radius: 12px;
            padding: 10px 14px;
            cursor: pointer;
            font-weight: 700;
            color: #fff;
        }

        .cancel-btn {
            background: linear-gradient(135deg, #ef4444, #f97316);
        }

        .leave-btn {
            background: linear-gradient(135deg, #334155, #475569);
            color: #e2e8f0;
        }

        .leave-note {
            color: #94a3b8;
            font-weight: 600;
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

                <a class="active" href="<%= request.getContextPath() %>/booking?action=allBookings">
                    <i class="fa-solid fa-ticket"></i>
                    <span>Bookings</span>
                </a>

                <a href="<%= request.getContextPath() %>/booking?action=pendingPayments">
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
                <p class="eyebrow">Booking Management</p>
                <h1>All Booking Records</h1>
                <p class="subtitle">View payment reference numbers before cancelling or keeping bookings unchanged.</p>
            </div>

            <div class="topbar-badge-lite">
                <i class="fa-solid fa-shield-halved"></i>
                <span><%= UserService.permissionLabel(adminPermission) %></span>
            </div>
        </section>

        <% if ("cancelled".equals(request.getParameter("msg"))) { %>
            <div class="alert-box alert-success-box">Booking cancelled successfully and seats were restored.</div>
        <% } %>

        <% if ("error".equals(request.getParameter("msg"))) { %>
            <div class="alert-box alert-error-box">Action failed. Please try again.</div>
        <% } %>

        <div class="page-card">
            <div class="page-header">
                <div>
                    <h2>Booking Table</h2>
                    <p>Check each payment reference or slip reference number before deciding what to do.</p>
                </div>

                <div class="search-box">
                    <input type="text" id="bookingSearch" placeholder="Search bookings...">
                </div>
            </div>

            <div class="booking-table-wrap">
                <table class="booking-table" id="bookingTable">
                    <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Customer ID</th>
                        <th>Event</th>
                        <th>Tickets</th>
                        <th>Total (LKR)</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Payment</th>
                        <th>Reference / Slip Reference</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Booking b : bookings) { %>
                        <tr>
                            <td class="mono-id"><%= b.getBookingId() %></td>
                            <td><%= b.getCustomerId() %></td>
                            <td><%= b.getEventTitle() %></td>
                            <td><%= b.getNumberOfTickets() %></td>
                            <td><%= String.format("%.1f", b.getTotalAmount()) %></td>
                            <td><%= b.getBookingDate() %></td>

                            <td>
                                <% if ("CANCELLED".equalsIgnoreCase(b.getStatus())) { %>
                                    <span class="status-pill cancelled-pill">CANCELLED</span>
                                <% } else { %>
                                    <span class="status-pill confirmed-pill">CONFIRMED</span>
                                <% } %>
                            </td>

                            <td>
                                <% if ("APPROVED".equalsIgnoreCase(b.getPaymentStatus())) { %>
                                    <span class="payment-pill approved-pill">APPROVED</span>
                                <% } else if ("REJECTED".equalsIgnoreCase(b.getPaymentStatus())) { %>
                                    <span class="payment-pill rejected-pill">REJECTED</span>
                                <% } else { %>
                                    <span class="payment-pill pending-pill">PENDING</span>
                                <% } %>
                            </td>

                            <td>
                                <% if (b.getPaymentReference() != null && !b.getPaymentReference().trim().isEmpty()) { %>
                                    <div class="reference-box"><%= b.getPaymentReference() %></div>
                                <% } else { %>
                                    <div class="reference-empty">No reference given</div>
                                <% } %>
                            </td>

                            <td>
                                <div class="action-cell">
                                    <% if ("CONFIRMED".equalsIgnoreCase(b.getStatus())) { %>
                                        <form class="inline-form" method="post" action="<%= request.getContextPath() %>/booking"
                                              onsubmit="return confirm('Cancel this booking?');">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                            <button type="submit" class="action-btn cancel-btn">Cancel</button>
                                        </form>

                                        <span class="leave-note">or leave it as it is</span>
                                    <% } else { %>
                                        <span class="leave-note">—</span>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                    <% } %>

                    <% if (bookings.isEmpty()) { %>
                        <tr>
                            <td colspan="10" class="leave-note" style="padding: 24px;">No bookings found.</td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<script>
    (function () {
        const input = document.getElementById("bookingSearch");
        const table = document.getElementById("bookingTable");
        const rows = table.querySelectorAll("tbody tr");

        input.addEventListener("input", function () {
            const q = input.value.toLowerCase().trim();

            rows.forEach(function (row) {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(q) ? "" : "none";
            });
        });
    })();
</script>

</body>
</html>