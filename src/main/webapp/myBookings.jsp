<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.Booking" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;

    if (currentSession == null || role == null || !"CUSTOMER".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
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
    <title>My Bookings - EventHorizon</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .page-wrap {
            min-height: 100vh;
            background:
                radial-gradient(circle at top left, rgba(139,92,246,0.12), transparent 25%),
                radial-gradient(circle at top right, rgba(6,182,212,0.08), transparent 22%),
                linear-gradient(180deg, #020617 0%, #030b2a 100%);
            color: #fff;
        }

        .content-box {
            max-width: 1100px;
            margin: 0 auto;
            padding: 42px 20px 70px;
        }

        .page-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            margin-bottom: 26px;
        }

        .page-title {
            font-size: 2.5rem;
            margin: 0;
            color: #fff;
            letter-spacing: 0.02em;
        }

        .page-sub {
            color: #9fb0d3;
            margin-top: 8px;
        }

        .browse-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
            padding: 14px 22px;
            border-radius: 16px;
            color: #38bdf8;
            border: 1px solid rgba(56,189,248,0.35);
            background: rgba(56,189,248,0.05);
            font-weight: 700;
            transition: 0.25s ease;
        }

        .browse-btn:hover {
            transform: translateY(-2px);
            color: #fff;
            border-color: rgba(56,189,248,0.6);
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

        .bookings-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 20px 45px rgba(0,0,0,0.25);
        }

        .bookings-table-wrap {
            overflow-x: auto;
        }

        .bookings-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 950px;
        }

        .bookings-table thead {
            background: linear-gradient(135deg, rgba(124,58,237,0.28), rgba(6,182,212,0.16));
        }

        .bookings-table th {
            padding: 16px 16px;
            text-align: left;
            color: #cbd5e1;
            text-transform: uppercase;
            font-size: 0.84rem;
            letter-spacing: 0.06em;
        }

        .bookings-table td {
            padding: 18px 16px;
            border-top: 1px solid rgba(255,255,255,0.06);
            color: #eef2ff;
        }

        .booking-id {
            color: #38bdf8;
            font-family: Consolas, monospace;
            font-weight: 700;
        }

        .amount {
            color: #7dd3fc;
            font-weight: 800;
        }

        .status-pill {
            display: inline-block;
            padding: 8px 14px;
            border-radius: 999px;
            font-size: 0.82rem;
            font-weight: 800;
            letter-spacing: 0.03em;
        }

        .status-pending {
            color: #facc15;
            background: rgba(245,158,11,0.16);
            border: 1px solid rgba(245,158,11,0.28);
        }

        .status-approved {
            color: #5eead4;
            background: rgba(16,185,129,0.16);
            border: 1px solid rgba(16,185,129,0.28);
        }

        .status-cancelled {
            color: #fca5a5;
            background: rgba(239,68,68,0.16);
            border: 1px solid rgba(239,68,68,0.28);
        }

        .action-btn {
            border: none;
            border-radius: 12px;
            padding: 10px 16px;
            font-weight: 800;
            cursor: pointer;
            color: #fff;
            background: linear-gradient(135deg, #ef4444, #f97316);
        }

        .muted {
            color: #94a3b8;
            font-weight: 700;
        }

        .footer {
            margin-top: 50px;
            padding-top: 18px;
            border-top: 1px solid rgba(255,255,255,0.08);
            color: #94a3b8;
        }
    </style>
</head>
<body>
<div class="page-wrap">

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
        <ul class="navbar-links">
            <li><a href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/event?action=list">Events</a></li>
            <li><a href="<%= request.getContextPath() %>/booking?action=myBookings" class="active">My Bookings</a></li>
            <li><a href="<%= request.getContextPath() %>/profile.jsp">Profile</a></li>
            <li><a href="<%= request.getContextPath() %>/user?action=logout" class="btn-nav">Logout</a></li>
        </ul>
    </nav>

    <div class="content-box">
        <div class="page-top">
            <div>
                <h1 class="page-title">My Bookings</h1>
                <p class="page-sub">Track your payment review status here.</p>
            </div>

            <a href="<%= request.getContextPath() %>/event?action=list" class="browse-btn">
                <i class="fa-solid fa-compass"></i>
                <span>Browse More Events</span>
            </a>
        </div>

        <% if ("paymentPending".equals(msg)) { %>
            <div class="alert-box alert-success-box">Your payment reference was submitted successfully. Status is now pending admin review.</div>
        <% } %>

        <% if ("cancelled".equals(msg)) { %>
            <div class="alert-box alert-success-box">Your booking was cancelled successfully.</div>
        <% } %>

        <% if ("error".equals(msg)) { %>
            <div class="alert-box alert-error-box">Something went wrong. Please try again.</div>
        <% } %>

        <div class="bookings-card">
            <div class="bookings-table-wrap">
                <table class="bookings-table">
                    <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Event</th>
                        <th>Tickets</th>
                        <th>Total Amount</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Booking b : bookings) {
                        String displayStatus;

                        if ("CANCELLED".equalsIgnoreCase(b.getStatus()) ||
                            "REJECTED".equalsIgnoreCase(b.getPaymentStatus())) {
                            displayStatus = "CANCELLED";
                        } else if ("APPROVED".equalsIgnoreCase(b.getPaymentStatus())) {
                            displayStatus = "APPROVED";
                        } else {
                            displayStatus = "PENDING";
                        }
                    %>
                        <tr>
                            <td class="booking-id"><%= b.getBookingId() %></td>
                            <td><%= b.getEventTitle() %></td>
                            <td><%= b.getNumberOfTickets() %></td>
                            <td class="amount">LKR <%= String.format("%.1f", b.getTotalAmount()) %></td>
                            <td><%= b.getBookingDate() %></td>
                            <td>
                                <% if ("PENDING".equals(displayStatus)) { %>
                                    <span class="status-pill status-pending">PENDING</span>
                                <% } else if ("APPROVED".equals(displayStatus)) { %>
                                    <span class="status-pill status-approved">APPROVED</span>
                                <% } else { %>
                                    <span class="status-pill status-cancelled">CANCELLED</span>
                                <% } %>
                            </td>
                            <td>
                                <% if ("PENDING".equals(displayStatus)) { %>
                                    <form method="post" action="<%= request.getContextPath() %>/booking" style="margin:0;">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                        <button type="submit" class="action-btn">Cancel</button>
                                    </form>
                                <% } else { %>
                                    <span class="muted">—</span>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>

                    <% if (bookings.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="muted" style="padding:24px;">No bookings found yet.</td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="footer">
            ⬡ EVENTHORIZON<br>
            SE1020 – Object Oriented Programming Project &copy; 2026
        </div>
    </div>
</div>
</body>
</html>