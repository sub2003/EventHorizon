<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

    Object userId = session.getAttribute("userId");
    Object role = session.getAttribute("role");

    if (userId == null || role == null || !"CUSTOMER".equals(role.toString())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout – EventHorizon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { background: #020617; min-height: 100vh; }

        .checkout-wrapper {
            max-width: 860px;
            margin: 100px auto 60px;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 28px;
        }

        @media (max-width: 720px) {
            .checkout-wrapper { grid-template-columns: 1fr; margin-top: 80px; }
        }

        .card {
            background: rgba(15,23,42,0.85);
            border: 1px solid rgba(255,255,255,0.09);
            border-radius: 24px;
            padding: 30px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
            backdrop-filter: blur(12px);
        }

        .card-title {
            font-size: 1.1rem;
            font-weight: 800;
            color: #f1f5f9;
            margin: 0 0 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-title i { color: #7c3aed; font-size: 1.15rem; }

        .order-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            font-size: 0.92rem;
            color: #94a3b8;
            gap: 16px;
        }

        .order-row:last-child { border-bottom: none; }

        .order-row .val {
            color: #f1f5f9;
            font-weight: 700;
            text-align: right;
        }

        .order-total-row {
            display: flex;
            justify-content: space-between;
            padding: 16px 0 0;
            font-size: 1.12rem;
            font-weight: 800;
            color: #f1f5f9;
            border-top: 2px solid rgba(124,58,237,0.35);
            margin-top: 12px;
            gap: 16px;
        }

        .order-total-row .val { color: #a78bfa; font-size: 1.3rem; }

        .bank-box {
            background: rgba(124,58,237,0.08);
            border: 1px solid rgba(124,58,237,0.25);
            border-radius: 16px;
            padding: 18px;
            margin: 16px 0 0;
        }

        .bank-row {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            align-items: flex-start;
        }

        .bank-row:last-child { margin-bottom: 0; }

        .bank-label {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            color: #7c3aed;
            font-weight: 700;
            min-width: 110px;
            padding-top: 2px;
        }

        .bank-val {
            color: #e2e8f0;
            font-weight: 700;
            font-size: 0.95rem;
            word-break: break-all;
        }

        .bank-notice {
            margin-top: 14px;
            padding: 12px 14px;
            background: rgba(250,204,21,0.07);
            border: 1px solid rgba(250,204,21,0.2);
            border-radius: 12px;
            font-size: 0.84rem;
            color: #fde68a;
            line-height: 1.55;
        }

        .form-group { margin-bottom: 20px; }

        label {
            display: block;
            font-size: 0.83rem;
            font-weight: 700;
            color: #94a3b8;
            margin-bottom: 8px;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        input[type="text"] {
            width: 100%;
            padding: 14px 16px;
            background: rgba(2,6,23,0.6);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 14px;
            color: #f1f5f9;
            font-size: 0.96rem;
            outline: none;
            transition: border 0.2s;
            box-sizing: border-box;
        }

        input[type="text"]:focus {
            border-color: #7c3aed;
            box-shadow: 0 0 0 3px rgba(124,58,237,0.18);
        }

        input[type="text"]::placeholder { color: #475569; }

        .btn-pay {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #7c3aed, #06b6d4);
            border: none;
            border-radius: 14px;
            color: #fff;
            font-size: 1.02rem;
            font-weight: 800;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.2s;
            margin-top: 6px;
        }

        .btn-pay:hover { opacity: 0.92; transform: translateY(-1px); }

        .btn-pay:disabled {
            opacity: 0.75;
            cursor: not-allowed;
            transform: none;
        }

        .alert-error {
            padding: 12px 16px;
            background: rgba(239,68,68,0.1);
            border: 1px solid rgba(239,68,68,0.3);
            border-radius: 12px;
            color: #fca5a5;
            font-size: 0.9rem;
            margin-bottom: 18px;
        }

        .steps {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-top: 18px;
        }

        .step {
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .step-num {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: linear-gradient(135deg, #7c3aed, #06b6d4);
            color: #fff;
            font-size: 0.8rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .step-text {
            font-size: 0.88rem;
            color: #94a3b8;
            line-height: 1.5;
            padding-top: 4px;
        }

        .step-text strong { color: #e2e8f0; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <div class="hamburger"><span></span><span></span><span></span></div>
    <ul class="navbar-links">
        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/event?action=list">Events</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?action=myBookings">My Bookings</a></li>
        <li><a href="${pageContext.request.contextPath}/profile.jsp">Profile</a></li>
        <li><a href="${pageContext.request.contextPath}/user?action=logout" class="btn-nav">Logout</a></li>
    </ul>
</nav>

<div class="checkout-wrapper">

    <div>
        <div class="card">
            <p class="card-title"><i class="fa-solid fa-receipt"></i> Order Summary</p>

            <div class="order-row">
                <span>Event</span>
                <span class="val">${event.title}</span>
            </div>
            <div class="order-row">
                <span>Date</span>
                <span class="val">${event.date}</span>
            </div>
            <div class="order-row">
                <span>Time</span>
                <span class="val">${event.time}</span>
            </div>
            <div class="order-row">
                <span>Venue</span>
                <span class="val">${event.venue}</span>
            </div>
            <div class="order-row">
                <span>Tickets</span>
                <span class="val">${tickets}</span>
            </div>
            <div class="order-row">
                <span>Price per ticket</span>
                <span class="val">LKR ${event.ticketPrice}</span>
            </div>

            <div class="order-total-row">
                <span>Total Payable</span>
                <span class="val">LKR ${total}</span>
            </div>
        </div>

        <div class="card" style="margin-top: 20px;">
            <p class="card-title"><i class="fa-solid fa-circle-info"></i> How it works</p>
            <div class="steps">
                <div class="step">
                    <div class="step-num">1</div>
                    <div class="step-text">Transfer <strong>LKR ${total}</strong> to the bank account shown on the right.</div>
                </div>
                <div class="step">
                    <div class="step-num">2</div>
                    <div class="step-text">Copy your bank's <strong>Transaction Reference / Slip Number</strong>.</div>
                </div>
                <div class="step">
                    <div class="step-num">3</div>
                    <div class="step-text">Paste the reference and click <strong>Confirm Payment</strong>.</div>
                </div>
                <div class="step">
                    <div class="step-num">4</div>
                    <div class="step-text">After admin verifies, your <strong>unique QR tickets</strong> will be issued automatically.</div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <p class="card-title"><i class="fa-solid fa-building-columns"></i> Payment Details</p>

        <div class="bank-box">
            <div class="bank-row">
                <span class="bank-label">Bank</span>
                <span class="bank-val">Bank of Ceylon</span>
            </div>
            <div class="bank-row">
                <span class="bank-label">Branch</span>
                <span class="bank-val">Colombo 03</span>
            </div>
            <div class="bank-row">
                <span class="bank-label">Account Name</span>
                <span class="bank-val">EventHorizon Pvt Ltd</span>
            </div>
            <div class="bank-row">
                <span class="bank-label">Account No.</span>
                <span class="bank-val">76543210</span>
            </div>
            <div class="bank-row">
                <span class="bank-label">Amount</span>
                <span class="bank-val" style="color:#a78bfa; font-size:1.1rem;">LKR <strong>${total}</strong></span>
            </div>
        </div>

        <div class="bank-notice">
            ⚠ Use <strong>${event.title}</strong> as your transfer description or remark so we can match your payment quickly.
        </div>

        <hr style="border: none; border-top: 1px solid rgba(255,255,255,0.07); margin: 22px 0;">

        <c:if test="${param.error == 'noReference'}">
            <div class="alert-error">⚠ Please enter your transaction reference before confirming.</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/booking" method="post" id="paymentForm">
            <input type="hidden" name="action" value="confirmPayment">
            <input type="hidden" name="eventId" value="${event.eventId}">
            <input type="hidden" name="numberOfTickets" value="${tickets}">

            <div class="form-group">
                <label for="paymentReference">Transaction Reference / Slip Number</label>
                <input type="text"
                       id="paymentReference"
                       name="paymentReference"
                       placeholder="e.g. TXN20260414123456"
                       required
                       autocomplete="off">
            </div>

            <button type="submit" class="btn-pay" id="confirmPayBtn">
                <i class="fa-solid fa-lock"></i>&nbsp; Confirm Payment – LKR ${total}
            </button>
        </form>
    </div>

</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    document.getElementById('paymentForm').addEventListener('submit', function () {
        var btn = document.getElementById('confirmPayBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>&nbsp; Processing...';
    });
</script>
</body>
</html>