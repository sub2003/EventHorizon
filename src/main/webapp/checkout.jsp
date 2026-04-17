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

        .nav-links a:hover {
            color: #8c6cff;
        }

        /* ── Page shell ── */
        .container {
            width: 92%;
            max-width: 1040px;
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

        .breadcrumb a:hover {
            color: #a0aee0;
        }

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

        /* ── Layout ── */
        .checkout-grid {
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            gap: 24px;
            align-items: start;
        }

        /* ── Order summary ── */
        .summary {
            background: rgba(124, 92, 255, 0.06);
            border: 1px solid rgba(124, 92, 255, 0.18);
            border-radius: 18px;
            padding: 22px;
            margin-bottom: 24px;
        }

        .summary-title,
        .panel-title {
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

        .summary-row:last-child {
            border-bottom: none;
        }

        .s-label {
            color: #9ba8d8;
            font-size: 14px;
            font-weight: 600;
        }

        .s-value {
            color: #f3f6ff;
            font-size: 14px;
            font-weight: 800;
            text-align: right;
        }

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
            font-size: 30px;
            font-weight: 800;
            color: #2bc0ff;
            font-family: 'Orbitron', monospace, Arial, sans-serif;
        }

        /* ── Side panels ── */
        .side-panel {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            padding: 20px;
            margin-bottom: 18px;
        }

        .bank-card {
            background: linear-gradient(180deg, rgba(43, 192, 255, 0.08), rgba(124, 92, 255, 0.05));
            border: 1px solid rgba(43, 192, 255, 0.18);
        }

        .bank-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 16px;
        }

        .bank-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.6px;
            text-transform: uppercase;
            color: #79d8ff;
            background: rgba(43, 192, 255, 0.12);
            border: 1px solid rgba(43, 192, 255, 0.2);
        }

        .bank-grid {
            display: grid;
            gap: 12px;
        }

        .bank-item {
            background: rgba(7, 13, 28, 0.55);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 14px;
            padding: 14px 16px;
        }

        .bank-label {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: #7c8ab8;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .bank-value {
            color: #ffffff;
            font-size: 16px;
            font-weight: 800;
            word-break: break-word;
        }

        .bank-note {
            margin-top: 14px;
            padding: 12px 14px;
            border-radius: 12px;
            background: rgba(255, 193, 7, 0.08);
            border: 1px solid rgba(255, 193, 7, 0.16);
            color: #ffe59b;
            font-size: 13px;
            line-height: 1.5;
        }

        .steps {
            display: grid;
            gap: 12px;
        }

        .step {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
        }

        .step:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .step-number {
            min-width: 28px;
            height: 28px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 800;
            background: linear-gradient(135deg, #7c5cff, #2bc0ff);
            color: #ffffff;
            box-shadow: 0 6px 16px rgba(124, 92, 255, 0.22);
        }

        .step-text {
            color: #dbe3ff;
            font-size: 14px;
            line-height: 1.6;
        }

        .step-text strong {
            color: #ffffff;
        }

        /* ── Form ── */
        .form-panel {
            background: rgba(124, 92, 255, 0.04);
            border: 1px solid rgba(124, 92, 255, 0.14);
            border-radius: 18px;
            padding: 22px;
            margin-top: 4px;
        }

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
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-group input:focus {
            border-color: rgba(124, 92, 255, 0.45);
            box-shadow: 0 0 0 3px rgba(124, 92, 255, 0.08);
        }

        .form-group input::placeholder {
            color: #5a6a9a;
        }

        .hint {
            margin-top: 8px;
            font-size: 13px;
            color: #7c8ab8;
            line-height: 1.55;
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

        .btn:hover {
            transform: translateY(-1px);
            opacity: 0.94;
        }

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

        @media (max-width: 900px) {
            .checkout-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 600px) {
            .navbar {
                flex-direction: column;
                gap: 12px;
                padding: 16px 18px;
            }

            .nav-links {
                flex-wrap: wrap;
                justify-content: center;
                gap: 14px;
            }

            .total-amount {
                font-size: 24px;
            }

            .card-body {
                padding: 20px;
            }

            .card-head {
                padding: 20px;
            }
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

                <div class="checkout-grid">

                    <!-- Left Column -->
                    <div>
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

                        <!-- Payment Form -->
                        <div class="form-panel">
                            <form action="<%= request.getContextPath() %>/booking" method="post">
                                <input type="hidden" name="action" value="confirmPayment">
                                <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                <input type="hidden" name="ticketTypeId" value="<%= ticketType.getTicketTypeId() %>">
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
                                        After completing the transfer, enter the transaction reference number, bank slip number, or payment note ID here.
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

                    <!-- Right Column -->
                    <div>
                        <!-- Bank Details -->
                        <div class="side-panel bank-card">
                            <div class="bank-header">
                                <div class="panel-title" style="margin-bottom:0;">Bank Transfer Details</div>
                                <span class="bank-badge">Official Payment</span>
                            </div>

                            <div class="bank-grid">
                                <div class="bank-item">
                                    <div class="bank-label">Bank Name</div>
                                    <div class="bank-value">HNB</div>
                                </div>

                                <div class="bank-item">
                                    <div class="bank-label">Account Number</div>
                                    <div class="bank-value">013020763635</div>
                                </div>

                                <div class="bank-item">
                                    <div class="bank-label">Account Name</div>
                                    <div class="bank-value">EventHorizon</div>
                                </div>

                                <div class="bank-item">
                                    <div class="bank-label">Payment Amount</div>
                                    <div class="bank-value">LKR <%= String.format("%.2f", total) %></div>
                                </div>
                            </div>

                            <div class="bank-note">
                                Please transfer the <strong>exact total amount</strong> shown on this page. Keep your bank slip or transaction receipt safe until your booking is approved.
                            </div>
                        </div>

                        <!-- Procedure Details -->
                        <div class="side-panel">
                            <div class="panel-title">Payment Procedure</div>

                            <div class="steps">
                                <div class="step">
                                    <div class="step-number">1</div>
                                    <div class="step-text">
                                        Transfer <strong>LKR <%= String.format("%.2f", total) %></strong> to the bank account shown above.
                                    </div>
                                </div>

                                <div class="step">
                                    <div class="step-number">2</div>
                                    <div class="step-text">
                                        Copy the <strong>transaction reference number</strong> or keep a clear payment slip screenshot.
                                    </div>
                                </div>

                                <div class="step">
                                    <div class="step-number">3</div>
                                    <div class="step-text">
                                        Enter that reference number in the <strong>Payment Reference Number</strong> field on this page.
                                    </div>
                                </div>

                                <div class="step">
                                    <div class="step-number">4</div>
                                    <div class="step-text">
                                        Click <strong>Confirm Payment Submission</strong> to send your booking for admin review.
                                    </div>
                                </div>

                                <div class="step">
                                    <div class="step-number">5</div>
                                    <div class="step-text">
                                        Once approved, your booking will appear in <strong>My Bookings</strong> and your digital tickets will be generated.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Important Notes -->
                        <div class="side-panel">
                            <div class="panel-title">Important Notes</div>

                            <div class="steps">
                                <div class="step">
                                    <div class="step-number">!</div>
                                    <div class="step-text">
                                        Your booking is not fully completed until the payment is reviewed and approved by an admin.
                                    </div>
                                </div>

                                <div class="step">
                                    <div class="step-number">!</div>
                                    <div class="step-text">
                                        Please make sure the payment reference is entered correctly to avoid approval delays.
                                    </div>
                                </div>

                                <div class="step">
                                    <div class="step-number">!</div>
                                    <div class="step-text">
                                        If you pay a different amount or submit a wrong reference number, your booking may be rejected.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>

    <% } %>
</div>

</body>
</html>