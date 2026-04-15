<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.Ticket" %>
<%@ page import="com.eventhorizon.model.Booking" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;

    if (currentSession == null || role == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Boolean paymentPending = (Boolean) request.getAttribute("paymentPending");
    if (paymentPending == null) paymentPending = false;

    Booking booking = (Booking) request.getAttribute("booking");
    List<Ticket> tickets = (List<Ticket>) request.getAttribute("tickets");
    if (tickets == null) tickets = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Tickets - EventHorizon</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: Arial, sans-serif; }
        body { background: #050816; color: #eef2ff; }
        .navbar {
            background: linear-gradient(90deg, #060b1f, #0b1434);
            border-bottom: 1px solid rgba(130, 90, 255, 0.22);
            padding: 18px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .brand { font-size: 32px; font-weight: 800; color: #7c5cff; }
        .nav-links a { color: #d9defa; text-decoration: none; margin-left: 22px; font-weight: 600; }
        .container { width: 92%; max-width: 1300px; margin: 30px auto; }
        .page-title { font-size: 34px; font-weight: 800; margin-bottom: 22px; }

        .notice-box, .ticket-card {
            background: linear-gradient(180deg, #0b1431, #09112a);
            border: 1px solid rgba(126, 93, 255, 0.18);
            border-radius: 22px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.22);
        }

        .notice-box { padding: 28px; }
        .notice-box h2 { margin-bottom: 10px; font-size: 28px; }
        .notice-box p { color: #a8b3de; line-height: 1.6; margin-bottom: 12px; }

        .btn {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            border: none;
            border-radius: 12px;
            padding: 12px 18px;
            font-weight: 800;
            cursor: pointer;
            background: linear-gradient(90deg, #7c5cff, #2bc0ff);
            color: #fff;
        }

        .ticket-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(360px, 1fr));
            gap: 22px;
        }

        .ticket-card { padding: 22px; }
        .ticket-badge {
            display: inline-block;
            margin-bottom: 14px;
            padding: 7px 12px;
            border-radius: 999px;
            background: rgba(124, 92, 255, 0.18);
            color: #bca8ff;
            font-size: 12px;
            font-weight: 800;
        }
        .ticket-title { font-size: 24px; font-weight: 800; margin-bottom: 16px; }

        .row {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .label { color: #99a5d7; font-weight: 600; }
        .value { color: #f8f9ff; font-weight: 700; text-align: right; word-break: break-word; }

        .qr-box {
            margin-top: 20px;
            background: #fff;
            border-radius: 18px;
            padding: 18px;
            text-align: center;
        }
        .qr-box img {
            width: 260px;
            max-width: 100%;
            height: auto;
            border-radius: 12px;
            background: #fff;
        }
        .qr-note {
            margin-top: 10px;
            color: #222;
            font-size: 13px;
            font-weight: 700;
            word-break: break-all;
        }

        .used { color: #ff8f8f; font-weight: 800; }
        .unused { color: #7ef0aa; font-weight: 800; }
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
    <div class="page-title">My Tickets</div>

    <% if (paymentPending) { %>
        <div class="notice-box">
            <h2>Tickets are not available yet</h2>
            <p>Your payment is still waiting for admin approval.</p>
            <% if (booking != null) { %>
                <p><strong>Booking ID:</strong> <%= booking.getBookingId() %></p>
                <p><strong>Event:</strong> <%= booking.getEventTitle() %></p>
                <p><strong>Payment Status:</strong> <%= booking.getPaymentStatus() %></p>
            <% } %>
            <a class="btn" href="<%= request.getContextPath() %>/booking?action=myBookings">Back to My Bookings</a>
        </div>
    <% } else if (tickets.isEmpty()) { %>
        <div class="notice-box">
            <h2>No tickets found</h2>
            <p>No generated tickets are linked to this booking yet.</p>
            <a class="btn" href="<%= request.getContextPath() %>/booking?action=myBookings">Back to My Bookings</a>
        </div>
    <% } else { %>
        <div class="ticket-grid">
            <% int i = 1; for (Ticket t : tickets) { %>
            <div class="ticket-card">
                <div class="ticket-badge">TICKET <%= i++ %></div>
                <div class="ticket-title"><%= booking != null ? booking.getEventTitle() : "Event Ticket" %></div>

                <div class="row">
                    <div class="label">Ticket ID</div>
                    <div class="value"><%= t.getTicketId() %></div>
                </div>
                <div class="row">
                    <div class="label">Booking ID</div>
                    <div class="value"><%= t.getBookingId() %></div>
                </div>
                <div class="row">
                    <div class="label">Event ID</div>
                    <div class="value"><%= t.getEventId() %></div>
                </div>
                <div class="row">
                    <div class="label">Customer ID</div>
                    <div class="value"><%= t.getCustomerId() %></div>
                </div>
                <div class="row">
                    <div class="label">Issued At</div>
                    <div class="value"><%= t.getCreatedAt() == null ? "-" : t.getCreatedAt() %></div>
                </div>
                <div class="row">
                    <div class="label">Status</div>
                    <div class="value <%= t.isUsed() ? "used" : "unused" %>">
                        <%= t.isUsed() ? "USED" : "APPROVED" %>
                    </div>
                </div>

                <div class="qr-box">
                    <img src="<%= request.getContextPath() %>/ticket?action=qr&token=<%= java.net.URLEncoder.encode(t.getQrToken(), "UTF-8") %>&v=<%= java.net.URLEncoder.encode(t.getTicketId(), "UTF-8") %>"
                         alt="QR Code">
                    <div class="qr-note">Secure ticket token stored in system</div>
                </div>
            </div>
            <% } %>
        </div>
    <% } %>
</div>

</body>
</html>