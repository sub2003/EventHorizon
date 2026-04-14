<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Tickets – EventHorizon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- QR Code generation library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        body { background: #020617; min-height: 100vh; }

        .tickets-page {
            max-width: 1100px;
            margin: 100px auto 60px;
            padding: 0 20px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 14px;
        }

        .page-header h1 {
            font-size: 2rem;
            font-weight: 900;
            color: #f1f5f9;
        }

        .btn-back {
            padding: 10px 20px;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            color: #94a3b8;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.9rem;
            transition: all 0.2s;
        }
        .btn-back:hover { background: rgba(255,255,255,0.1); color: #f1f5f9; }

        /* Pending state */
        .pending-box {
            background: rgba(250,204,21,0.07);
            border: 1px solid rgba(250,204,21,0.22);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
        }
        .pending-box .pending-icon { font-size: 3rem; margin-bottom: 16px; }
        .pending-box h2 { color: #fde68a; font-size: 1.5rem; margin: 0 0 10px; }
        .pending-box p  { color: #94a3b8; max-width: 460px; margin: 0 auto; line-height: 1.6; }

        /* Ticket grid */
        .tickets-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
        }

        .ticket-card {
            background: linear-gradient(145deg, rgba(15,23,42,0.95), rgba(30,41,59,0.9));
            border: 1px solid rgba(124,58,237,0.3);
            border-radius: 24px;
            padding: 26px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .ticket-card::before {
            content: '';
            position: absolute;
            top: -40px; right: -40px;
            width: 120px; height: 120px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(124,58,237,0.18), transparent);
        }
        .ticket-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 28px 56px rgba(0,0,0,0.5), 0 0 30px rgba(124,58,237,0.15);
        }

        .ticket-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 18px;
        }
        .ticket-num {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: #7c3aed;
            font-weight: 800;
        }
        .ticket-badge-used {
            font-size: 0.72rem;
            padding: 4px 10px;
            border-radius: 999px;
            background: rgba(239,68,68,0.15);
            border: 1px solid rgba(239,68,68,0.3);
            color: #fca5a5;
            font-weight: 700;
        }
        .ticket-badge-valid {
            font-size: 0.72rem;
            padding: 4px 10px;
            border-radius: 999px;
            background: rgba(34,197,94,0.12);
            border: 1px solid rgba(34,197,94,0.25);
            color: #86efac;
            font-weight: 700;
        }

        /* QR code container */
        .qr-wrapper {
            display: flex;
            justify-content: center;
            margin: 16px 0;
        }
        .qr-box {
            background: #fff;
            border-radius: 12px;
            padding: 10px;
            display: inline-block;
            line-height: 0;
        }

        .ticket-id-row {
            text-align: center;
            margin-top: 12px;
        }
        .ticket-id-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: #475569;
            margin-bottom: 4px;
        }
        .ticket-id-val {
            font-family: 'Courier New', monospace;
            font-size: 0.8rem;
            color: #64748b;
            word-break: break-all;
        }

        .divider {
            border: none;
            border-top: 1px dashed rgba(255,255,255,0.08);
            margin: 16px 0;
        }

        .ticket-info-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            margin-bottom: 8px;
        }
        .ticket-info-row .lbl { color: #475569; }
        .ticket-info-row .vl  { color: #e2e8f0; font-weight: 700; }

        .empty-state {
            text-align: center;
            padding: 64px 20px;
            color: #475569;
        }
        .empty-state .emoji { font-size: 3.5rem; display: block; margin-bottom: 16px; }

        @media print {
            .navbar, .btn-back, .page-header a { display: none !important; }
            .ticket-card { break-inside: avoid; page-break-inside: avoid; }
        }

        @media (max-width: 600px) {
            .tickets-page { margin-top: 75px; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <div class="hamburger"><span></span><span></span><span></span></div>
    <ul class="navbar-links">
        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/event?action=list">Events</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?action=myBookings" class="active">My Bookings</a></li>
        <li><a href="${pageContext.request.contextPath}/user?action=logout" class="btn-nav">Logout</a></li>
    </ul>
</nav>

<div class="tickets-page">
    <div class="page-header">
        <h1>🎟 My Tickets</h1>
        <a href="${pageContext.request.contextPath}/booking?action=myBookings" class="btn-back">
            <i class="fa-solid fa-arrow-left"></i> Back to Bookings
        </a>
    </div>

    <%-- Payment still pending --%>
    <c:if test="${paymentPending}">
        <div class="pending-box">
            <div class="pending-icon">⏳</div>
            <h2>Payment Under Review</h2>
            <p>
                Your payment reference has been received.
                Once our team verifies your bank transfer, your QR tickets will appear here automatically.
                This usually takes a few hours.
            </p>
            <p style="margin-top:12px; font-size:0.85rem; color:#64748b;">
                Booking: <strong style="color:#a78bfa;">${booking.bookingId}</strong> &nbsp;|&nbsp;
                Reference: <strong style="color:#a78bfa;">${booking.paymentReference}</strong>
            </p>
        </div>
    </c:if>

    <%-- Tickets available --%>
    <c:if test="${not paymentPending}">
        <c:choose>
            <c:when test="${not empty tickets}">
                <div class="tickets-grid" id="ticketGrid">
                    <c:forEach var="t" items="${tickets}" varStatus="status">
                        <div class="ticket-card">
                            <div class="ticket-header">
                                <span class="ticket-num">Ticket #${status.count}</span>
                                <c:choose>
                                    <c:when test="${t.used}">
                                        <span class="ticket-badge-used">✗ Used</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="ticket-badge-valid">✓ Valid</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- QR Code rendered by JS --%>
                            <div class="qr-wrapper">
                                <div class="qr-box">
                                    <div class="qr-canvas"
                                         id="qr-${status.index}"
                                         data-token="${t.qrToken}"
                                         style="width:180px;height:180px;">
                                    </div>
                                </div>
                            </div>

                            <div class="ticket-id-row">
                                <div class="ticket-id-label">Ticket ID</div>
                                <div class="ticket-id-val">${t.ticketId}</div>
                            </div>

                            <hr class="divider">

                            <div class="ticket-info-row">
                                <span class="lbl">Booking</span>
                                <span class="vl">${t.bookingId}</span>
                            </div>
                            <div class="ticket-info-row">
                                <span class="lbl">Event ID</span>
                                <span class="vl">${t.eventId}</span>
                            </div>
                            <div class="ticket-info-row">
                                <span class="lbl">Issued</span>
                                <span class="vl">${t.createdAt}</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <span class="emoji">🎭</span>
                    <h3 style="color:#64748b;">No tickets found</h3>
                    <p>Tickets are issued after payment is approved.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    // Generate a QR code for each ticket using its unique qrToken
    document.querySelectorAll('.qr-canvas').forEach(function (el) {
        var token = el.getAttribute('data-token');
        new QRCode(el, {
            text: token,
            width: 180,
            height: 180,
            colorDark: '#0f172a',
            colorLight: '#ffffff',
            correctLevel: QRCode.CorrectLevel.H
        });
    });
</script>
</body>
</html>
