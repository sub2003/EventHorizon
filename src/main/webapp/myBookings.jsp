<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.Booking" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String userName = currentSession != null ? (String) currentSession.getAttribute("userName") : null;

    if (currentSession == null || role == null || !"CUSTOMER".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    if (bookings == null) {
        bookings = new java.util.ArrayList<>();
    }

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - EventHorizon</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #050816;
            color: #e8ecff;
        }

        .navbar {
            width: 100%;
            background: linear-gradient(90deg, #060b1f, #0b1434);
            border-bottom: 1px solid rgba(130, 90, 255, 0.22);
            padding: 18px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .brand {
            font-size: 32px;
            font-weight: 800;
            letter-spacing: 1px;
            color: #7c5cff;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 22px;
        }

        .nav-links a {
            color: #d9defa;
            text-decoration: none;
            font-weight: 600;
            transition: 0.2s ease;
        }

        .nav-links a:hover {
            color: #8c6cff;
        }

        .container {
            width: 92%;
            max-width: 1250px;
            margin: 32px auto;
        }

        .page-header {
            margin-bottom: 24px;
        }

        .page-title {
            font-size: 36px;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 8px;
        }

        .page-subtitle {
            color: #9ba8d8;
            font-size: 15px;
        }

        .alert {
            padding: 14px 18px;
            border-radius: 14px;
            margin-bottom: 20px;
            font-weight: 600;
            border: 1px solid transparent;
        }

        .alert.success {
            background: rgba(46, 204, 113, 0.12);
            border-color: rgba(46, 204, 113, 0.35);
            color: #b8ffd4;
        }

        .alert.error {
            background: rgba(231, 76, 60, 0.12);
            border-color: rgba(231, 76, 60, 0.35);
            color: #ffc4bd;
        }

        .booking-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
            gap: 24px;
        }

        .booking-card {
            background: linear-gradient(180deg, #0b1431, #09112a);
            border: 1px solid rgba(126, 93, 255, 0.18);
            border-radius: 22px;
            padding: 24px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.22);
            transition: 0.2s ease;
        }

        .booking-card:hover {
            transform: translateY(-2px);
            border-color: rgba(126, 93, 255, 0.32);
        }

        .booking-title {
            font-size: 24px;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 18px;
        }

        .booking-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.07);
        }

        .booking-row:last-child {
            border-bottom: none;
        }

        .booking-label {
            color: #99a5d7;
            font-weight: 600;
            font-size: 14px;
        }

        .booking-value {
            color: #f3f6ff;
            font-weight: 700;
            font-size: 14px;
            text-align: right;
            word-break: break-word;
            max-width: 55%;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.4px;
            text-transform: uppercase;
        }

        .status-confirmed {
            background: rgba(46, 204, 113, 0.14);
            color: #87f0aa;
        }

        .status-cancelled {
            background: rgba(160, 160, 160, 0.16);
            color: #d0d0d0;
        }

        .payment-pending {
            background: rgba(255, 193, 7, 0.14);
            color: #ffd66b;
        }

        .payment-approved {
            background: rgba(46, 204, 113, 0.14);
            color: #87f0aa;
        }

        .payment-rejected {
            background: rgba(231, 76, 60, 0.14);
            color: #ff9f95;
        }

        /* Ticket type badge */
        .ticket-type-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 5px 11px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.4px;
            text-transform: uppercase;
            background: rgba(43, 192, 255, 0.13);
            color: #2bc0ff;
            border: 1px solid rgba(43, 192, 255, 0.24);
        }

        .actions {
            margin-top: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 16px;
            border-radius: 12px;
            border: none;
            text-decoration: none;
            font-weight: 800;
            font-size: 14px;
            cursor: pointer;
            transition: 0.2s ease;
        }

        .btn:hover {
            transform: translateY(-1px);
            opacity: 0.96;
        }

        .btn-primary {
            background: linear-gradient(90deg, #7c5cff, #2bc0ff);
            color: #ffffff;
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.08);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.10);
        }

        .btn-danger {
            background: linear-gradient(90deg, #ff5d73, #ff7b54);
            color: #ffffff;
        }

        .empty-box {
            text-align: center;
            padding: 55px 24px;
            background: linear-gradient(180deg, #0b1431, #09112a);
            border: 1px solid rgba(126, 93, 255, 0.18);
            border-radius: 22px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.22);
        }

        .empty-box h2 {
            font-size: 30px;
            margin-bottom: 10px;
            color: #ffffff;
        }

        .empty-box p {
            color: #9ba8d8;
            margin-bottom: 22px;
        }

        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 14px;
                padding: 16px 18px;
            }

            .nav-links {
                flex-wrap: wrap;
                justify-content: center;
                gap: 14px;
            }

            .page-title {
                font-size: 30px;
            }

            .booking-row {
                flex-direction: column;
                align-items: flex-start;
            }

            .booking-value {
                max-width: 100%;
                text-align: left;
            }
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="brand">EVENTHORIZON</div>
    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/index.jsp">Home</a>
        <a href="<%= request.getContextPath() %>/event?action=list">Events</a>
        <a href="<%= request.getContextPath() %>/booking?action=myBookings">My Bookings</a>
        <a href="<%= request.getContextPath() %>/profile.jsp">Profile</a>
        <a href="<%= request.getContextPath() %>/user?action=logout">Logout</a>
    </div>
</div>

<div class="container">
    <div class="page-header">
        <div class="page-title">My Bookings</div>
        <div class="page-subtitle">
            Welcome<%= userName != null ? ", " + userName : "" %>. Here you can track payments and view your approved tickets.
        </div>
    </div>

    <% if ("paymentPending".equals(msg)) { %>
        <div class="alert success">
            Payment submitted successfully. Your booking is now waiting for admin approval.
        </div>
    <% } %>

    <% if ("cancelled".equals(msg)) { %>
        <div class="alert success">
            Booking cancelled successfully.
        </div>
    <% } %>

    <% if ("error".equals(msg) || error != null) { %>
        <div class="alert error">
            Something went wrong. Please try again.
        </div>
    <% } %>

    <% if (bookings.isEmpty()) { %>
        <div class="empty-box">
            <h2>No bookings yet</h2>
            <p>You have not booked any events yet.</p>
            <a class="btn btn-primary" href="<%= request.getContextPath() %>/event?action=list">
                Browse Events
            </a>
        </div>
    <% } else { %>

    <div class="booking-grid">
        <%
            for (Booking b : bookings) {
                String bookingStatusClass = "status-confirmed";
                if ("CANCELLED".equalsIgnoreCase(b.getStatus())) {
                    bookingStatusClass = "status-cancelled";
                }

                String paymentStatusClass = "payment-pending";
                if ("APPROVED".equalsIgnoreCase(b.getPaymentStatus())) {
                    paymentStatusClass = "payment-approved";
                } else if ("REJECTED".equalsIgnoreCase(b.getPaymentStatus())) {
                    paymentStatusClass = "payment-rejected";
                }
        %>
        <div class="booking-card">
            <div class="booking-title"><%= b.getEventTitle() %></div>

            <div class="booking-row">
                <div class="booking-label">Booking ID</div>
                <div class="booking-value"><%= b.getBookingId() %></div>
            </div>

            <div class="booking-row">
                <div class="booking-label">Event ID</div>
                <div class="booking-value"><%= b.getEventId() %></div>
            </div>

            <div class="booking-row">
                <div class="booking-label">Ticket Type</div>
                <div class="booking-value">
                    <%
                        String ttn = b.getTicketTypeName();
                        if (ttn != null && !ttn.trim().isEmpty()) {
                    %>
                        <span class="ticket-type-pill"><%= ttn %></span>
                    <%  } else { %>
                        <span style="color:#5a6a9a;">—</span>
                    <%  } %>
                </div>
            </div>

            <div class="booking-row">
                <div class="booking-label">Number of Tickets</div>
                <div class="booking-value"><%= b.getNumberOfTickets() %></div>
            </div>

            <div class="booking-row">
                <div class="booking-label">Total Amount</div>
                <div class="booking-value">LKR <%= String.format("%.2f", b.getTotalAmount()) %></div>
            </div>

            <div class="booking-row">
                <div class="booking-label">Booking Date</div>
                <div class="booking-value"><%= b.getBookingDate() %></div>
            </div>

            <div class="booking-row">
                <div class="booking-label">Booking Status</div>
                <div class="booking-value">
                    <span class="status-pill <%= bookingStatusClass %>"><%= b.getStatus() %></span>
                </div>
            </div>

            <div class="booking-row">
                <div class="booking-label">Payment Status</div>
                <div class="booking-value">
                    <span class="status-pill <%= paymentStatusClass %>"><%= b.getPaymentStatus() %></span>
                </div>
            </div>

            <div class="booking-row">
                <div class="booking-label">Payment Reference</div>
                <div class="booking-value">
                    <%= (b.getPaymentReference() == null || b.getPaymentReference().trim().isEmpty())
                            ? "-"
                            : b.getPaymentReference() %>
                </div>
            </div>

            <div class="actions">
                <% if ("APPROVED".equalsIgnoreCase(b.getPaymentStatus())
                        && !"CANCELLED".equalsIgnoreCase(b.getStatus())) { %>
                    <a class="btn btn-primary"
                       href="<%= request.getContextPath() %>/ticket?action=viewTickets&bookingId=<%= b.getBookingId() %>">
                        View Tickets
                    </a>
                <% } %>

                <% if ("PENDING".equalsIgnoreCase(b.getPaymentStatus())
                        && !"CANCELLED".equalsIgnoreCase(b.getStatus())) { %>
                    <a class="btn btn-secondary"
                       href="<%= request.getContextPath() %>/ticket?action=viewTickets&bookingId=<%= b.getBookingId() %>">
                        Check Ticket Status
                    </a>
                <% } %>

                <% if (!"CANCELLED".equalsIgnoreCase(b.getStatus())
                        && !"APPROVED".equalsIgnoreCase(b.getPaymentStatus())) { %>
                    <form method="post" action="<%= request.getContextPath() %>/booking" style="display:inline;">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                        <button type="submit" class="btn btn-danger"
                                onclick="return confirm('Are you sure you want to cancel this booking?');">
                            Cancel Booking
                        </button>
                    </form>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>

    <% } %>
</div>

</body>
</html>
