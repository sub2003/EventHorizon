<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
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

int navIssueCount = 0;
Object navUserIdObj = currentSession != null ? currentSession.getAttribute("userId") : null;
if (navUserIdObj != null) {
    try {
        String numericPart = String.valueOf(navUserIdObj).replaceAll("\\D+", "");
        if (!numericPart.isEmpty()) {
            navIssueCount = new IssueService().countIssuesWithRepliesByUser(Integer.parseInt(numericPart));
        }
    } catch (Exception ignored) { }
}

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - EventHorizon</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,SOFT,WONK@9..144,600..900,40,0..1&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
    .eh-navbar {
        position: sticky;
        top: 0;
        z-index: 1000;
        width: 100%;
        background: linear-gradient(90deg, #060b1f, #0b1434);
        border-bottom: 1px solid rgba(130, 90, 255, 0.22);
        backdrop-filter: blur(12px);
    }

    .eh-navbar-inner {
        width: min(94%, 1400px);
        margin: 0 auto;
        padding: 16px 0;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
    }

    .eh-brand {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        text-decoration: none;
        color: #e8ecff;
        font-weight: 800;
        letter-spacing: 0.6px;
        font-size: 1.55rem;
    }

    .eh-brand i {
        color: #7c5cff;
        font-size: 1.1rem;
    }

    .eh-nav-links {
        list-style: none;
        display: flex;
        align-items: center;
        gap: 10px;
        margin: 0;
        padding: 0;
        flex-wrap: wrap;
        justify-content: flex-end;
    }

    .eh-nav-links li {
        list-style: none;
    }

    .eh-nav-link,
    .eh-nav-bell,
    .eh-nav-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        min-height: 40px;
        padding: 10px 14px;
        border-radius: 12px;
        text-decoration: none;
        font-size: 0.92rem;
        font-weight: 700;
        transition: 0.22s ease;
        border: 1px solid transparent;
    }

    .eh-nav-link {
        color: #d9defa;
    }

    .eh-nav-link:hover {
        color: #ffffff;
        background: rgba(255,255,255,0.05);
    }

    .eh-nav-link.active {
        color: #ffffff;
        background: linear-gradient(135deg, rgba(124,92,255,0.24), rgba(43,192,255,0.18));
        border-color: rgba(124,92,255,0.28);
        box-shadow: 0 8px 20px rgba(124,92,255,0.12);
    }

    .eh-nav-bell {
        position: relative;
        color: #d9defa;
        width: 42px;
        padding: 0;
        background: rgba(255,255,255,0.05);
        border-color: rgba(255,255,255,0.08);
    }

    .eh-nav-bell:hover,
    .eh-nav-bell.active {
        color: #ffffff;
        border-color: rgba(124,92,255,0.35);
        background: linear-gradient(135deg, rgba(124,92,255,0.24), rgba(43,192,255,0.18));
        box-shadow: 0 8px 18px rgba(124,92,255,0.14);
    }

    .eh-nav-bell i {
        font-size: 1rem;
    }

    .eh-bell-badge {
        position: absolute;
        top: -6px;
        right: -6px;
        min-width: 18px;
        height: 18px;
        padding: 0 5px;
        border-radius: 999px;
        background: linear-gradient(135deg, #ff5d73, #ff7b54);
        color: #fff;
        font-size: 0.68rem;
        font-weight: 800;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 6px 14px rgba(255,93,115,0.3);
    }

    .eh-nav-btn {
        color: #ffffff;
        background: linear-gradient(135deg, #7c5cff, #9b6bff);
        box-shadow: 0 10px 20px rgba(124,92,255,0.18);
    }

    .eh-nav-btn:hover {
        transform: translateY(-1px);
        opacity: 0.95;
    }

    @media (max-width: 900px) {
        .eh-navbar-inner {
            flex-direction: column;
            align-items: stretch;
        }

        .eh-nav-links {
            justify-content: center;
        }

        .eh-brand {
            justify-content: center;
        }
    }
</style>

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
