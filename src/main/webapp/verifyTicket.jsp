<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhorizon.model.Ticket" %>
<%@ page import="com.eventhorizon.model.Booking" %>
<%
    Ticket ticket = (Ticket) request.getAttribute("ticket");
    Booking booking = (Booking) request.getAttribute("booking");
    Boolean approved = (Boolean) request.getAttribute("approved");
    String scannedToken = (String) request.getAttribute("scannedToken");
    if (approved == null) approved = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ticket Verification - EventHorizon</title>
    <style>
        * {
            box-sizing: border-box;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        body {
            background: #050816;
            color: #eef2ff;
            min-height: 100vh;
        }

        .navbar {
            width: 100%;
            background: linear-gradient(90deg, #060b1f, #0b1434);
            border-bottom: 1px solid rgba(130, 90, 255, 0.22);
            padding: 18px 30px;
        }

        .brand {
            font-size: 32px;
            font-weight: 800;
            letter-spacing: 1px;
            color: #7c5cff;
        }

        .container {
            width: 92%;
            max-width: 900px;
            margin: 40px auto;
        }

        .card {
            background: linear-gradient(180deg, #0b1431, #09112a);
            border: 1px solid rgba(126, 93, 255, 0.18);
            border-radius: 24px;
            padding: 32px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.22);
        }

        .title {
            font-size: 38px;
            font-weight: 800;
            margin-bottom: 24px;
        }

        .status-box {
            padding: 20px;
            border-radius: 18px;
            margin-bottom: 24px;
            font-size: 28px;
            font-weight: 800;
            text-align: center;
        }

        .approved {
            background: rgba(46, 204, 113, 0.14);
            border: 1px solid rgba(46, 204, 113, 0.35);
            color: #8df0b0;
        }

        .not-approved {
            background: rgba(231, 76, 60, 0.14);
            border: 1px solid rgba(231, 76, 60, 0.35);
            color: #ffb1a8;
        }

        .row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            padding: 14px 0;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }

        .row:last-child {
            border-bottom: none;
        }

        .label {
            color: #9eabd9;
            font-weight: 700;
        }

        .value {
            color: #ffffff;
            font-weight: 800;
            text-align: right;
            word-break: break-word;
        }

        .note {
            margin-top: 24px;
            color: #9eabd9;
            line-height: 1.7;
        }

        @media (max-width: 768px) {
            .row {
                flex-direction: column;
            }

            .value {
                text-align: left;
            }

            .title {
                font-size: 30px;
            }

            .status-box {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="brand">EVENTHORIZON</div>
</div>

<div class="container">
    <div class="card">
        <div class="title">Ticket Verification</div>

        <% if (approved && ticket != null && booking != null) { %>
            <div class="status-box approved">APPROVED</div>

            <div class="row">
                <div class="label">Ticket ID</div>
                <div class="value"><%= ticket.getTicketId() %></div>
            </div>

            <div class="row">
                <div class="label">Booking ID</div>
                <div class="value"><%= ticket.getBookingId() %></div>
            </div>

            <div class="row">
                <div class="label">Event ID</div>
                <div class="value"><%= ticket.getEventId() %></div>
            </div>

            <div class="row">
                <div class="label">Customer ID</div>
                <div class="value"><%= ticket.getCustomerId() %></div>
            </div>

            <div class="row">
                <div class="label">Booking Payment</div>
                <div class="value"><%= booking.getPaymentStatus() %></div>
            </div>

            <div class="row">
                <div class="label">Booking Status</div>
                <div class="value"><%= booking.getStatus() %></div>
            </div>

            <div class="row">
                <div class="label">Scanned Token</div>
                <div class="value"><%= scannedToken == null ? "-" : scannedToken %></div>
            </div>

            <div class="note">
                This is a valid ticket issued by the EventHorizon system.
            </div>
        <% } else { %>
            <div class="status-box not-approved">NOT APPROVED</div>

            <div class="row">
                <div class="label">Scanned Token</div>
                <div class="value"><%= scannedToken == null ? "-" : scannedToken %></div>
            </div>

            <div class="note">
                This QR code is not a valid approved EventHorizon ticket.
                It may be fake, expired, or not found in the system.
            </div>
        <% } %>
    </div>
</div>

</body>
</html>