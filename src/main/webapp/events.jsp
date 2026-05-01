<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    int navIssueCount = 0;
    String navRole = (String) session.getAttribute("role");
    Object navUserIdObj = session.getAttribute("userId");
    if ("CUSTOMER".equals(navRole) && navUserIdObj != null) {
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
    <title>Events – EventHorizon</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,SOFT,WONK@9..144,600..900,40,0..1&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
        .events-hero {
            position: relative;
            padding-top: 10px;
        }

        .events-hero::before {
            content: "";
            position: absolute;
            top: 30px;
            left: 50%;
            transform: translateX(-50%);
            width: 540px;
            height: 220px;
            background: radial-gradient(circle, rgba(124,58,237,0.18) 0%, rgba(6,182,212,0.10) 35%, rgba(0,0,0,0) 75%);
            filter: blur(18px);
            pointer-events: none;
            z-index: 0;
        }

        .section-header {
            position: relative;
            z-index: 1;
        }

        .search-panel {
            position: relative;
            z-index: 1;
            max-width: 1020px;
            margin: 34px auto 38px auto;
            padding: 20px;
            border-radius: 26px;
            background: linear-gradient(135deg, rgba(14,20,38,0.96), rgba(20,26,48,0.88));
            border: 1px solid rgba(148,163,184,0.10);
            box-shadow:
                    0 0 0 1px rgba(255,255,255,0.02) inset,
                    0 18px 40px rgba(2,6,23,0.34),
                    0 0 30px rgba(124,58,237,0.12);
            backdrop-filter: blur(14px);
            animation: fadeSlideDown 0.8s ease;
            overflow: hidden;
        }

        .search-panel::before {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(120deg, rgba(124,58,237,0.08), rgba(56,189,248,0.05), rgba(255,255,255,0.01));
            pointer-events: none;
        }

        .search-form {
            position: relative;
            display: flex;
            gap: 14px;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            z-index: 1;
        }

        .search-input,
        .search-select {
            background: rgba(255,255,255,0.04);
            color: #ffffff;
            border: 1px solid rgba(148,163,184,0.12);
            border-radius: 16px;
            padding: 15px 17px;
            font-size: 15px;
            outline: none;
            transition: all 0.28s ease;
            box-shadow: 0 0 0 rgba(0,0,0,0);
        }

        .search-input {
            flex: 1;
            min-width: 290px;
            max-width: 440px;
        }

        .search-input::placeholder {
            color: #94a3b8;
        }

        .search-select {
            min-width: 230px;
            cursor: pointer;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image:
                    linear-gradient(45deg, transparent 50%, #c4b5fd 50%),
                    linear-gradient(135deg, #c4b5fd 50%, transparent 50%);
            background-position:
                    calc(100% - 22px) calc(50% - 3px),
                    calc(100% - 16px) calc(50% - 3px);
            background-size: 6px 6px, 6px 6px;
            background-repeat: no-repeat;
            padding-right: 44px;
        }

        .search-select option {
            background: #14143a;
            color: #ffffff;
        }

        .search-input:focus,
        .search-select:focus {
            border-color: rgba(56, 189, 248, 0.55);
            box-shadow:
                    0 0 0 4px rgba(56,189,248,0.08),
                    0 10px 24px rgba(56,189,248,0.08);
            transform: translateY(-2px);
            background: rgba(255,255,255,0.065);
        }

        .search-btn {
            border: none;
            border-radius: 16px;
            padding: 15px 28px;
            font-size: 15px;
            font-weight: 700;
            color: white;
            cursor: pointer;
            background: linear-gradient(90deg, #7c3aed, #8b5cf6, #38bdf8);
            background-size: 220% 220%;
            transition: transform 0.25s ease, box-shadow 0.28s ease;
            animation: gradientMove 5s ease infinite;
            letter-spacing: 0.2px;
            box-shadow: 0 10px 24px rgba(124,58,237,0.26);
        }

        .search-btn:hover {
            transform: translateY(-3px) scale(1.03);
            box-shadow: 0 14px 28px rgba(124,58,237,0.34);
        }

        .search-btn:active {
            transform: translateY(-1px) scale(1.01);
        }

        .filter-summary {
            text-align: center;
            margin: 0 0 26px 0;
            color: var(--text-muted);
            font-size: 0.96rem;
            animation: fadeIn 0.7s ease;
        }

        .filter-summary strong {
            color: #ffffff;
            font-weight: 700;
        }

        .clear-link {
            color: var(--accent-blue);
            text-decoration: none;
            font-weight: 700;
            margin-left: 8px;
            transition: color 0.25s ease, text-shadow 0.25s ease;
        }

        .clear-link:hover {
            color: #67e8f9;
            text-shadow: 0 0 12px rgba(103,232,249,0.35);
        }

        .events-grid .card {
            animation: fadeUp 0.65s ease both;
            transition: transform 0.30s ease, box-shadow 0.30s ease, border-color 0.30s ease;
            border: 1px solid rgba(148,163,184,0.08);
            overflow: hidden;
            position: relative;
            background: linear-gradient(180deg, rgba(13,18,34,0.98), rgba(10,15,30,0.98));
            border-radius: 18px;
            box-shadow: 0 14px 30px rgba(2,6,23,0.34);
        }

        .events-grid .card::before {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(124,58,237,0.04), rgba(6,182,212,0.02), transparent);
            pointer-events: none;
        }

        .events-grid .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(2,6,23,0.45);
            border-color: rgba(124,58,237,0.18);
        }

        .card-img-placeholder img,
        .card-img-placeholder div {
            transition: transform 0.45s ease, filter 0.45s ease;
        }

        .card:hover .card-img-placeholder img,
        .card:hover .card-img-placeholder div {
            transform: scale(1.05);
            filter: saturate(1.05);
        }

        .card-category {
            box-shadow: 0 0 0 1px rgba(255,255,255,0.06) inset;
            backdrop-filter: blur(8px);
        }

        .card-title {
            transition: color 0.25s ease;
        }

        .card:hover .card-title {
            color: #c4b5fd;
        }

        .empty-state {
            animation: fadeIn 0.8s ease;
        }

        .empty-state .emoji {
            display: inline-block;
            animation: floaty 2.8s ease-in-out infinite;
        }

        @keyframes fadeSlideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(28px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to   { opacity: 1; }
        }

        @keyframes gradientMove {
            0%   { background-position: 0% 50%; }
            50%  { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        @keyframes floaty {
            0%, 100% { transform: translateY(0); }
            50%      { transform: translateY(-8px); }
        }

        @media (max-width: 768px) {
            .search-panel {
                padding: 16px;
                border-radius: 20px;
            }

            .search-input,
            .search-select,
            .search-btn {
                width: 100%;
                max-width: 100%;
            }

            .events-hero::before {
                width: 320px;
                height: 180px;
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
<body class="events-page">


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
                <a href="${pageContext.request.contextPath}/event?action=list" class="eh-nav-link active">
                    <i class="fa-solid fa-calendar-days"></i><span>Events</span>
                </a>
            </li>

            <% if (ehNavUserIdObj != null && "CUSTOMER".equals(ehNavRole)) { %>
                <li>
                    <a href="${pageContext.request.contextPath}/booking?action=myBookings" class="eh-nav-link">
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


<div class="container events-hero">
    <div class="section-header">
        <h2 class="section-title">Upcoming <span>Events</span></h2>
        <div class="section-divider"></div>
        <p style="color:var(--text-muted);margin-top:12px;font-size:0.95rem;">
            Browse and book tickets for the hottest events in Sri Lanka
        </p>
    </div>

    <div class="search-panel">
        <form action="${pageContext.request.contextPath}/event" method="get" class="search-form">
            <input type="hidden" name="action" value="list">

            <input type="text"
                   name="keyword"
                   class="search-input"
                   placeholder="Search by title or venue..."
                   value="${keyword}">

            <select name="category" class="search-select">
                <option value="">All Categories</option>
                <option value="Concert" ${category == 'Concert' ? 'selected' : ''}>Concert</option>
                <option value="Sports" ${category == 'Sports' ? 'selected' : ''}>Sports</option>
                <option value="Technology" ${category == 'Technology' ? 'selected' : ''}>Technology</option>
                <option value="Cultural" ${category == 'Cultural' ? 'selected' : ''}>Cultural</option>
                <option value="Theater" ${category == 'Theater' ? 'selected' : ''}>Theater</option>
                <option value="Comedy" ${category == 'Comedy' ? 'selected' : ''}>Comedy</option>
            </select>

            <button type="submit" class="search-btn">⬡ Search</button>
        </form>
    </div>

    <c:if test="${not empty keyword or not empty category}">
        <div class="filter-summary">
            Showing results
            <c:if test="${not empty keyword}">
                for <strong>${keyword}</strong>
            </c:if>
            <c:if test="${not empty category}">
                in <strong>${category}</strong>
            </c:if>
            <a href="${pageContext.request.contextPath}/event?action=list" class="clear-link">Clear Filters</a>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty events}">
            <div class="events-grid">
                <c:forEach var="event" items="${events}" varStatus="status">
                    <div class="card" style="animation-delay:${status.index * 0.08}s;">

                        <div class="card-img-placeholder" style="overflow:hidden;">
                            <img src="${pageContext.request.contextPath}/event?action=image&id=${event.eventId}"
                                 alt="${event.title}"
                                 style="width:100%; height:220px; object-fit:cover; display:block;"
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">

                            <div style="display:none; width:100%; height:220px; align-items:center; justify-content:center; font-size:3rem;">
                                <c:choose>
                                    <c:when test="${event.category == 'Concert'}">⬡</c:when>
                                    <c:when test="${event.category == 'Sports'}">⬡</c:when>
                                    <c:when test="${event.category == 'Technology'}">⬡</c:when>
                                    <c:when test="${event.category == 'Cultural'}">⬡</c:when>
                                    <c:when test="${event.category == 'Theater'}">⬡</c:when>
                                    <c:when test="${event.category == 'Comedy'}">⬡</c:when>
                                    <c:otherwise>⬡</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card-body">
                            <div class="card-category">${event.category}</div>
                            <div class="card-title">${event.title}</div>

                            <div class="card-meta">
                                <span>⬡ ${event.date} at ${event.time}</span>
                                <span>⬡ ${event.venue}</span>
                                <span>⬡ ${event.availableSeats} seats left</span>
                            </div>

                            <c:if test="${not empty event.description}">
                                <p style="color:var(--text-muted); margin-top:10px; font-size:0.9rem; line-height:1.5;">
                                    ${event.description}
                                </p>
                            </c:if>

                            <div class="seats-bar">
                                <div class="seats-bar-fill"
                                     data-pct="${(event.availableSeats * 100) / event.totalSeats}">
                                </div>
                            </div>
                        </div>

                        <div class="card-footer">
                            <div class="price">LKR ${event.ticketPrice}</div>
                            <a href="${pageContext.request.contextPath}/event?action=view&id=${event.eventId}"
                               class="btn btn-primary btn-sm">
                                View Details
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="empty-state">
                <span class="emoji">⬡</span>
                <h3>No Events Found</h3>
                <p>Try a different title, venue, or category.</p>
                <a href="${pageContext.request.contextPath}/event?action=list"
                   class="btn btn-outline"
                   style="margin-top:16px;">
                    Show All Events
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer class="mini-footer">
    <div class="container mini-footer-inner">
        <div class="mini-footer-brand">
            <span class="mini-footer-icon">⬡</span>
            <span class="mini-footer-name">EVENTHORIZON</span>
        </div>
        <p class="mini-footer-text">SE1020 – Object Oriented Programming Project © 2026</p>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>