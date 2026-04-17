<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhorizon.model.Event" %>
<%@ page import="com.eventhorizon.model.EventTicketType" %>
<%
    Event event = (Event) request.getAttribute("event");
    EventTicketType ticketType = (EventTicketType) request.getAttribute("ticketType");
    Integer tickets = (Integer) request.getAttribute("tickets");
    Double total = (Double) request.getAttribute("total");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout – EventHorizon</title>
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
            min-height: 100vh;
        }

        /* ── Navbar ── */
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
            text-decoration: none;
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

        .nav-links a:hover { color: #8c6cff; }

        /* ── Page shell ── */
        .container {
            width: 92%;
            max-width: 860px;
            margin: 40px auto 60px;
        }

        .breadcrumb {
            font-size: 0.9rem;
            color: #7c8ab8;
            margin-bottom: 24px;
        }

        .breadcrumb a {
            color: #7c8ab8;
            text-decoration: none;
        }

        .breadcrumb a:hover { color: #a0aee0; }

        /* ── Card ── */
        .card {
            background: linear-gradient(180deg, #0b1431, #09112a);
            border: 1px solid rgba(126, 93, 255, 0.18);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
        }

        .card-head {
            padding: 24px 28px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.07);
            background: rgba(255, 255, 255, 0.018);
        }

        .card-head h1 {
            font-size: 28px;
            font-weight: 800;
            color: #ffffff;
        }

        .card-body {
            padding: 28px;
        }

        /* ── Error alert ── */
        .alert-error {
            background: rgba(231, 76, 60, 0.12);
            border: 1px solid rgba(231, 76, 60, 0.35);
            color: #ffb1a8;
            border-radius: 14px;
            padding: 14px 16px;
            font-weight: 700;
            margin-bottom: 22px;
        }

        /* ── Order summary ── */
        .summary {
            background: rgba(124, 92, 255, 0.06);
            border: 1px solid rgba(124, 92, 255, 0.18);
            border-radius: 18px;
            padding: 22px;
            margin-bottom: 28px;
        }

        .summary-title {
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: #7c8ab8;
            margin-bottom: 16px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            padding: 11px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            flex-wrap: wrap;
        }

        .summary-row:last-child { border-bottom: none; }

        .s-label { color: #9ba8d8; font-size: 14px; font-weight: 600; }
        .s-value { color: #f3f6ff; font-size: 14px; font-weight: 800; text-align: right; }

        .type-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 5px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.4px;
            text-transform: uppercase;
            background: rgba(43, 192, 255, 0.14);
            color: #2bc0ff;
            border: 1px solid rgba(43, 192, 255, 0.25);
        }

        .total-row {
            margin-top: 6px;
            padding-top: 14px;
            border-top: 1px solid rgba(255, 255, 255, 0.10);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

        .total-label {
            font-size: 14px;
            color: #9ba8d8;
            font-weight: 700;
        }

        .total-amount {
            font-size: 26px;
            font-weight: 800;
            color: #2bc0ff;
            font-family: 'Orbitron', monospace, Arial, sans-serif;
        }

        /* ── Form ── */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            color: #cbd5e1;
            margin-bottom: 10px;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border-radius: 14px;
            border: 1px solid rgba(255, 255, 255, 0.10);
            background: rgba(7, 13, 28, 0.92);
            color: #ffffff;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s ease;
        }

        .form-group input:focus {
            border-color: rgba(124, 92, 255, 0.45);
        }

        .form-group input::placeholder { color: #5a6a9a; }

        .hint {
            margin-top: 8px;
            font-size: 13px;
            color: #7c8ab8;
            line-height: 1.5;
        }

        /* ── Buttons ── */
        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 24px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 14px 22px;
            border-radius: 14px;
            border: none;
            font-weight: 800;
            font-size: 15px;
            cursor: pointer;
            text-decoration: none;
            transition: 0.2s ease;
            gap: 8px;
        }

        .btn:hover { transform: translateY(-1px); opacity: 0.94; }

        .btn-primary {
            background: linear-gradient(90deg, #7c5cff, #2bc0ff);
            color: #ffffff;
            box-shadow: 0 10px 28px rgba(124, 92, 255, 0.3);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.06);
            color: #d9defa;
            border: 1px solid rgba(255, 255, 255, 0.10);
        }

        /* ── Invalid / empty state ── */
        .empty-card {
            text-align: center;
            padding: 48px 28px;
        }

        .empty-card p {
            color: #7c8ab8;
            margin-bottom: 20px;
        }

        /* ── Responsive ── */
        @media (max-width: 600px) {
            .navbar { flex-direction: column; gap: 12px; padding: 16px 18px; }
            .nav-links { flex-wrap: wrap; justify-content: center; gap: 14px; }
            .total-amount { font-size: 22px; }
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="<%= request.getContextPath() %>/index.jsp" class="brand">EVENTHORIZON</a>
    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/index.jsp">Home</a>
        <a href="<%= request.getContextPath() %>/event?action=list">Events</a>
        <a href="<%= request.getContextPath() %>/booking?action=myBookings">My Bookings</a>
        <a href="<%= request.getContextPath() %>/user?action=logout">Logout</a>
    </div>
</div>

<div class="container">
    <div class="breadcrumb">
        <a href="<%= request.getContextPath() %>/event?action=list">Events</a>
        &nbsp;/&nbsp;
        <% if (event != null) { %>
            <a href="<%= request.getContextPath() %>/event?action=view&id=<%= event.getEventId() %>"><%= event.getTitle() %></a>
            &nbsp;/&nbsp;
        <% } %>
        Checkout
    </div>

    <% if (event == null || ticketType == null || tickets == null || total == null) { %>

        <div class="card">
            <div class="card-body empty-card">
                <p>Invalid checkout request. Please go back and select a ticket.</p>
                <a class="btn btn-secondary" href="<%= request.getContextPath() %>/event?action=list">← Back to Events</a>
            </div>
        </div>

    <% } else { %>

        <div class="card">
            <div class="card-head">
                <h1>🎟️ Order Checkout</h1>
            </div>

            <div class="card-body">

                <% if ("noReference".equals(error)) { %>
                    <div class="alert-error">⚠ Payment reference is required. Please enter your transfer/reference number.</div>
                <% } %>

                <!-- Order Summary -->
                <div class="summary">
                    <div class="summary-title">Order Summary</div>

                    <div class="summary-row">
                        <span class="s-label">Event</span>
                        <span class="s-value"><%= event.getTitle() %></span>
                    </div>

                    <div class="summary-row">
                        <span class="s-label">Venue</span>
                        <span class="s-value"><%= event.getVenue() %></span>
                    </div>

                    <div class="summary-row">
                        <span class="s-label">Date &amp; Time</span>
                        <span class="s-value"><%= event.getDate() %> &nbsp; <%= event.getTime() %></span>
                    </div>

                    <div class="summary-row">
                        <span class="s-label">Ticket Type</span>
                        <span class="s-value">
                            <span class="type-badge"><%= ticketType.getTypeName() %></span>
                        </span>
                    </div>

                    <div class="summary-row">
                        <span class="s-label">Price per Ticket</span>
                        <span class="s-value">LKR <%= String.format("%.2f", ticketType.getPrice()) %></span>
                    </div>

                    <div class="summary-row">
                        <span class="s-label">Quantity</span>
                        <span class="s-value"><%= tickets %> ticket<%= tickets > 1 ? "s" : "" %></span>
                    </div>

                    <div class="total-row">
                        <span class="total-label">Total Amount</span>
                        <span class="total-amount">LKR <%= String.format("%.2f", total) %></span>
                    </div>
                </div>

                <!-- Payment form -->
                <form action="<%= request.getContextPath() %>/booking" method="post">
                    <input type="hidden" name="action"          value="confirmPayment">
                    <input type="hidden" name="eventId"         value="<%= event.getEventId() %>">
                    <input type="hidden" name="ticketTypeId"    value="<%= ticketType.getTicketTypeId() %>">
                    <input type="hidden" name="numberOfTickets" value="<%= tickets %>">

                    <div class="form-group">
                        <label for="paymentReference">Payment Reference Number</label>
                        <input type="text"
                               id="paymentReference"
                               name="paymentReference"
                               placeholder="Enter your bank transfer / payment slip reference"
                               required
                               autocomplete="off">
                        <div class="hint">
                            Transfer the total amount shown above and enter the reference number or slip ID here.
                            An admin will review and approve your booking.
                        </div>
                    </div>

                    <div class="actions">
                        <button type="submit" class="btn btn-primary">
                            ✅ Confirm Payment Submission
                        </button>
                        <a class="btn btn-secondary"
                           href="<%= request.getContextPath() %>/event?action=view&id=<%= event.getEventId() %>">
                            ← Go Back
                        </a>
                    </div>
                </form>

            </div>
        </div>

    <% } %>
</div>

</body>
</html>
