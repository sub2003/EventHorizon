<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.Ticket" %>
<%@ page import="com.eventhorizon.model.Booking" %>
<%@ page import="com.eventhorizon.service.IssueService" %>

<%
    int ehNavIssueCount = 0;
    String ehNavRole = (String) session.getAttribute("role");
    Object ehNavUserIdObj = session.getAttribute("userId");

    if ("CUSTOMER".equals(ehNavRole) && ehNavUserIdObj != null) {
        try {
            String numericPart = String.valueOf(ehNavUserIdObj).replaceAll("\\D+", "");
            if (!numericPart.isEmpty()) {
                ehNavIssueCount = new IssueService()
                        .countIssuesWithRepliesByUser(Integer.parseInt(numericPart));
            }
        } catch (Exception ignored) {
        }
    }
%>
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

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,SOFT,WONK@9..144,600..900,40,0..1&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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

        /* Ticket type badge */
        .type-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 5px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.4px;
            text-transform: uppercase;
            background: rgba(43,192,255,0.13);
            color: #2bc0ff;
            border: 1px solid rgba(43,192,255,0.22);
        }

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

        /* ================= EVENTHORIZON PREMIUM LIGHT THEME ================= */
        :root {
            --linen: #FAF8F4;
            --paper: #FFFFFF;
            --forest: #1E4A3A;
            --forest-dark: #123528;
            --forest-soft: #E8F1EC;
            --text: #18251F;
            --text-soft: #52635A;
            --muted: #7C8A82;
            --border: rgba(30, 74, 58, 0.14);
            --border-strong: rgba(30, 74, 58, 0.24);
            --shadow-soft: 0 18px 50px rgba(24, 37, 31, 0.09);
        }

        body {
            font-family: 'Inter', sans-serif !important;
            background:
                radial-gradient(circle at top left, rgba(30, 74, 58, 0.08), transparent 32%),
                radial-gradient(circle at top right, rgba(176, 141, 101, 0.10), transparent 30%),
                linear-gradient(180deg, #ffffff 0%, var(--linen) 48%, #F7F3EA 100%) !important;
            color: var(--text) !important;
            overflow-x: hidden;
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
            z-index: -10;
            pointer-events: none;
            background-image:
                radial-gradient(circle at 1px 1px, rgba(30, 74, 58, 0.10) 1.2px, transparent 1.4px),
                linear-gradient(135deg, rgba(30, 74, 58, 0.035) 25%, transparent 25%),
                linear-gradient(45deg, rgba(176, 141, 101, 0.035) 25%, transparent 25%);
            background-size: 34px 34px, 88px 88px, 88px 88px;
            background-position: 0 0, 0 0, 44px 44px;
            opacity: 0.70;
        }

        .eh-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: rgba(250, 248, 244, 0.94) !important;
            border-bottom: 1px solid var(--border) !important;
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            box-shadow: 0 10px 28px rgba(24, 37, 31, 0.05);
        }

        .eh-navbar-inner {
            width: min(92%, 1240px);
            min-height: 76px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .eh-brand {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            color: var(--forest-dark) !important;
            font-weight: 900;
            letter-spacing: 1.8px;
            text-transform: uppercase;
            text-decoration: none;
        }

        .eh-brand-mark {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            background: linear-gradient(135deg, var(--forest), var(--forest-dark));
            box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24);
        }

        .eh-brand-text {
            font-size: 1.08rem;
        }

        .eh-nav-links {
            list-style: none;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
            flex-wrap: wrap;
            margin: 0;
            padding: 0;
        }

        .eh-nav-links li {
            list-style: none;
        }

        .eh-nav-link,
        .eh-nav-bell,
        .eh-nav-btn,
        .eh-nav-btn-outline {
            min-height: 42px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 10px 15px;
            border-radius: 13px;
            border: 1px solid transparent;
            font-size: 0.88rem;
            font-weight: 800;
            color: var(--text-soft) !important;
            transition: 0.22s ease;
            white-space: nowrap;
            text-decoration: none;
        }

        .eh-nav-link:hover,
        .eh-nav-link.active {
            color: var(--forest) !important;
            background: var(--forest-soft) !important;
            border-color: var(--border) !important;
        }

        .eh-nav-bell {
            position: relative;
            width: 44px;
            padding: 0;
            background: rgba(255, 255, 255, 0.82) !important;
            border-color: var(--border) !important;
            box-shadow: 0 8px 18px rgba(24, 37, 31, 0.05);
        }

        .eh-nav-bell:hover,
        .eh-nav-bell.active {
            color: var(--forest) !important;
            background: var(--forest-soft) !important;
            border-color: var(--border-strong) !important;
        }

        .eh-bell-badge {
            position: absolute;
            top: -7px;
            right: -7px;
            min-width: 19px;
            height: 19px;
            padding: 0 6px;
            border-radius: 999px;
            background: linear-gradient(135deg, #D94B32, #F08A4C);
            color: #ffffff;
            font-size: 0.64rem;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 18px rgba(217, 75, 50, 0.30);
        }

        .eh-nav-btn {
            color: #ffffff !important;
            background: linear-gradient(135deg, var(--forest), var(--forest-dark)) !important;
            box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24);
        }

        .eh-nav-btn-outline {
            color: var(--forest) !important;
            background: rgba(255, 255, 255, 0.86) !important;
            border-color: var(--border-strong) !important;
        }

        .hero-card,
        .contact-card,
        .policy-card,
        .card,
        .auth-card,
        .ticket-card,
        .notice-box,
        .booking-card,
        .profile-card,
        .checkout-card,
        .summary-card,
        .payment-card,
        .event-card,
        .detail-card,
        .table-card,
        .faq-card,
        .info-card {
            background: rgba(255, 255, 255, 0.96) !important;
            border: 1px solid var(--border) !important;
            box-shadow: var(--shadow-soft) !important;
            color: var(--text) !important;
        }

        h1,
        h2,
        h3,
        .title,
        .page-title,
        .section-title,
        .auth-logo,
        .hero-card h1,
        .hero-card h2 {
            color: var(--forest-dark) !important;
        }

        h1,
        .title,
        .page-title,
        .hero-card h1,
        .hero-card h2 {
            font-family: 'Fraunces', serif !important;
            font-weight: 900 !important;
        }

        p,
        li,
        label,
        td,
        th,
        .muted,
        .breadcrumb,
        .hero-card p,
        .policy-card p,
        .contact-card p {
            color: var(--text-soft) !important;
        }

        input,
        select,
        textarea {
            background: rgba(255, 255, 255, 0.96) !important;
            color: var(--text) !important;
            border: 1px solid var(--border-strong) !important;
        }

        .btn,
        .primary-btn,
        .submit-btn,
        button[type="submit"] {
            background: linear-gradient(135deg, var(--forest), var(--forest-dark)) !important;
            color: #ffffff !important;
            border: 1px solid rgba(30, 74, 58, 0.20) !important;
            box-shadow: 0 14px 30px rgba(30, 74, 58, 0.22) !important;
        }

        @media (max-width: 768px) {
            .eh-navbar-inner {
                min-height: auto;
                padding: 14px 0;
                flex-direction: column;
                justify-content: center;
            }

            .eh-brand {
                justify-content: center;
            }

            .eh-nav-links {
                justify-content: center;
            }
        }

        @media (max-width: 520px) {
            .eh-nav-link span,
            .eh-nav-btn span,
            .eh-nav-btn-outline span {
                display: none;
            }

            .eh-nav-link,
            .eh-nav-btn,
            .eh-nav-btn-outline {
                width: 42px;
                padding: 0;
            }
        }
</style>
</head>
<body>


<nav class="eh-navbar">
    <div class="eh-navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="eh-brand">
            <span class="eh-brand-mark"><i class="fa-solid fa-leaf"></i></span>
            <span class="eh-brand-text">EVENTHORIZON</span>
        </a>

        <ul class="eh-nav-links">
            <li>
                <a href="${pageContext.request.contextPath}/index.jsp" class="eh-nav-link">
                    <i class="fa-solid fa-house"></i><span>Home</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/event?action=list" class="eh-nav-link">
                    <i class="fa-solid fa-calendar-days"></i><span>Events</span>
                </a>
            </li>

            <% if (ehNavUserIdObj != null && "CUSTOMER".equals(ehNavRole)) { %>
                <li>
                    <a href="${pageContext.request.contextPath}/booking?action=myBookings" class="eh-nav-link active">
                        <i class="fa-solid fa-ticket"></i><span>My Bookings</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/IssueServlet?action=myIssues" class="eh-nav-bell" title="Issue notifications">
                        <i class="fa-regular fa-bell"></i>
                        <% if (ehNavIssueCount > 0) { %>
                            <span class="eh-bell-badge"><%= ehNavIssueCount %></span>
                        <% } %>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/profile.jsp" class="eh-nav-link">
                        <i class="fa-regular fa-user"></i><span>Profile</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/user?action=logout" class="eh-nav-btn">
                        <i class="fa-solid fa-right-from-bracket"></i><span>Logout</span>
                    </a>
                </li>
            <% } else if (ehNavUserIdObj != null && "ADMIN".equals(ehNavRole)) { %>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="eh-nav-link">
                        <i class="fa-solid fa-gauge-high"></i><span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/profile.jsp" class="eh-nav-link">
                        <i class="fa-regular fa-user"></i><span>Profile</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/user?action=logout" class="eh-nav-btn">
                        <i class="fa-solid fa-right-from-bracket"></i><span>Logout</span>
                    </a>
                </li>
            <% } else { %>
                <li>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="eh-nav-link">
                        <i class="fa-solid fa-right-to-bracket"></i><span>Login</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="eh-nav-btn-outline">
                        <i class="fa-solid fa-user-plus"></i><span>Register</span>
                    </a>
                </li>
            <% } %>
        </ul>
    </div>
</nav>


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

                <%-- Ticket type --%>
                <div class="row">
                    <div class="label">Ticket Type</div>
                    <div class="value">
                        <%
                            String ttn = t.getTicketTypeName();
                            if (ttn != null && !ttn.trim().isEmpty()) {
                        %>
                            <span class="type-pill"><%= ttn %></span>
                        <%  } else { %>
                            <span style="color:#5a6a9a;">—</span>
                        <%  } %>
                    </div>
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
