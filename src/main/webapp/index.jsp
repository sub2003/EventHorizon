<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.eventhorizon.service.IssueService" %>
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
    <title>EventHorizon – Book Your Experience</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        :root {
            --eh-bg: #f6f8ff;
            --eh-surface: rgba(255, 255, 255, 0.88);
            --eh-surface-solid: #ffffff;
            --eh-text: #10172a;
            --eh-muted: #64748b;
            --eh-soft: #eef4ff;
            --eh-border: rgba(15, 23, 42, 0.10);
            --eh-purple: #6d5dfc;
            --eh-purple-dark: #5745e8;
            --eh-blue: #0ea5e9;
            --eh-cyan: #06b6d4;
            --eh-shadow: 0 24px 70px rgba(15, 23, 42, 0.12);
            --eh-shadow-soft: 0 14px 38px rgba(15, 23, 42, 0.08);
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            color: var(--eh-text);
            background:
                radial-gradient(circle at top left, rgba(109, 93, 252, 0.13), transparent 34%),
                radial-gradient(circle at top right, rgba(14, 165, 233, 0.14), transparent 30%),
                linear-gradient(180deg, #f8fbff 0%, #eef4ff 48%, #f8fbff 100%);
            font-family: "Inter", "Segoe UI", Arial, sans-serif;
            overflow-x: hidden;
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            background-image:
                linear-gradient(rgba(15, 23, 42, 0.035) 1px, transparent 1px),
                linear-gradient(90deg, rgba(15, 23, 42, 0.035) 1px, transparent 1px);
            background-size: 44px 44px;
            mask-image: linear-gradient(to bottom, rgba(0,0,0,0.55), transparent 70%);
            z-index: -1;
        }

        .container {
            width: min(92%, 1180px);
            margin: 0 auto;
        }

        .eh-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: rgba(255, 255, 255, 0.82);
            border-bottom: 1px solid rgba(15, 23, 42, 0.08);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            box-shadow: 0 10px 34px rgba(15, 23, 42, 0.07);
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
            color: #10172a;
            font-weight: 900;
            letter-spacing: 0.8px;
            font-size: 1.55rem;
        }

        .eh-brand i {
            color: var(--eh-purple);
            font-size: 1.1rem;
            filter: drop-shadow(0 8px 14px rgba(109, 93, 252, 0.25));
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
        .eh-nav-btn,
        .eh-nav-btn-outline {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 40px;
            padding: 10px 14px;
            border-radius: 14px;
            text-decoration: none;
            font-size: 0.92rem;
            font-weight: 800;
            transition: 0.22s ease;
            border: 1px solid transparent;
            white-space: nowrap;
        }

        .eh-nav-link {
            color: #334155;
        }

        .eh-nav-link:hover {
            color: #0f172a;
            background: rgba(109, 93, 252, 0.08);
            border-color: rgba(109, 93, 252, 0.12);
            transform: translateY(-1px);
        }

        .eh-nav-link.active {
            color: #ffffff;
            background: linear-gradient(135deg, var(--eh-purple), var(--eh-blue));
            border-color: rgba(109, 93, 252, 0.25);
            box-shadow: 0 14px 30px rgba(109, 93, 252, 0.24);
        }

        .eh-nav-bell {
            position: relative;
            color: #334155;
            width: 42px;
            padding: 0;
            background: rgba(248, 250, 252, 0.95);
            border-color: rgba(15, 23, 42, 0.09);
            box-shadow: 0 10px 22px rgba(15, 23, 42, 0.06);
        }

        .eh-nav-bell:hover,
        .eh-nav-bell.active {
            color: #ffffff;
            border-color: rgba(109, 93, 252, 0.25);
            background: linear-gradient(135deg, var(--eh-purple), var(--eh-blue));
            box-shadow: 0 14px 28px rgba(109, 93, 252, 0.22);
            transform: translateY(-1px);
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
            background: linear-gradient(135deg, #ff4d6d, #ff8a3d);
            color: #fff;
            font-size: 0.68rem;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 18px rgba(255, 77, 109, 0.35);
        }

        .eh-nav-btn {
            color: #ffffff;
            background: linear-gradient(135deg, var(--eh-purple), var(--eh-blue));
            box-shadow: 0 14px 30px rgba(109, 93, 252, 0.24);
        }

        .eh-nav-btn:hover {
            transform: translateY(-1px);
            opacity: 0.95;
        }

        .eh-nav-btn-outline {
            color: #0369a1;
            border-color: rgba(14, 165, 233, 0.25);
            background: rgba(14, 165, 233, 0.08);
        }

        .eh-nav-btn-outline:hover {
            color: #ffffff;
            border-color: rgba(14, 165, 233, 0.35);
            background: linear-gradient(135deg, var(--eh-blue), var(--eh-cyan));
            box-shadow: 0 14px 28px rgba(14, 165, 233, 0.22);
            transform: translateY(-1px);
        }

        .hero {
            position: relative;
            min-height: 700px;
            display: flex;
            align-items: center;
            overflow: hidden;
            background:
                linear-gradient(90deg, rgba(255, 255, 255, 0.96), rgba(255, 255, 255, 0.82), rgba(255, 255, 255, 0.42)),
                url("https://c.pxhere.com/photos/d0/80/crowd_concert_festival_music_purple-145331.jpg!d");
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            border-bottom: 1px solid rgba(15, 23, 42, 0.08);
        }

        .hero::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at 18% 30%, rgba(109, 93, 252, 0.18), transparent 30%),
                radial-gradient(circle at 80% 18%, rgba(14, 165, 233, 0.16), transparent 28%),
                linear-gradient(180deg, rgba(248, 251, 255, 0.18), rgba(248, 251, 255, 0.92));
            pointer-events: none;
        }

        .hero::after {
            content: "";
            position: absolute;
            width: 520px;
            height: 520px;
            right: -160px;
            bottom: -190px;
            background: radial-gradient(circle, rgba(109, 93, 252, 0.22), transparent 64%);
            filter: blur(8px);
            pointer-events: none;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            width: min(92%, 1180px);
            margin: 0 auto;
            padding: 110px 0;
            max-width: 760px;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 999px;
            color: #4338ca;
            background: rgba(109, 93, 252, 0.10);
            border: 1px solid rgba(109, 93, 252, 0.20);
            box-shadow: 0 12px 28px rgba(109, 93, 252, 0.10);
            font-weight: 900;
            letter-spacing: 0.3px;
        }

        .hero-title {
            margin: 24px 0 18px;
            color: #0f172a;
            font-size: clamp(3rem, 7vw, 6.8rem);
            line-height: 0.94;
            font-weight: 950;
            letter-spacing: -4px;
            text-shadow: 0 16px 38px rgba(15, 23, 42, 0.10);
        }

        .hero-subtitle {
            max-width: 680px;
            color: #475569;
            font-size: 1.18rem;
            line-height: 1.8;
            margin: 0 0 34px;
            font-weight: 500;
        }

        .hero-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 48px;
            padding: 14px 22px;
            border-radius: 16px;
            text-decoration: none;
            font-weight: 900;
            transition: 0.24s ease;
            border: 1px solid transparent;
            cursor: pointer;
        }

        .btn-primary {
            color: #ffffff;
            background: linear-gradient(135deg, var(--eh-purple), var(--eh-blue));
            box-shadow: 0 18px 38px rgba(109, 93, 252, 0.27);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 22px 46px rgba(109, 93, 252, 0.34);
        }

        .btn-outline {
            color: #0f172a;
            background: rgba(255, 255, 255, 0.78);
            border-color: rgba(15, 23, 42, 0.12);
            box-shadow: 0 14px 32px rgba(15, 23, 42, 0.08);
            backdrop-filter: blur(16px);
        }

        .btn-outline:hover {
            color: #4338ca;
            border-color: rgba(109, 93, 252, 0.25);
            background: rgba(255, 255, 255, 0.94);
            transform: translateY(-2px);
        }

        .features-section {
            padding: 95px 0;
            background:
                radial-gradient(circle at 15% 10%, rgba(109, 93, 252, 0.08), transparent 28%),
                linear-gradient(180deg, #ffffff 0%, #f6f8ff 100%);
        }

        .section-header {
            text-align: center;
            margin-bottom: 46px;
        }

        .section-title {
            margin: 0;
            color: #0f172a;
            font-size: clamp(2rem, 4vw, 3.2rem);
            font-weight: 950;
            letter-spacing: -1.5px;
        }

        .section-title span {
            background: linear-gradient(135deg, var(--eh-purple), var(--eh-blue));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .section-subtitle {
            color: #64748b;
            margin: 14px auto 0;
            max-width: 620px;
            line-height: 1.7;
            font-weight: 500;
        }

        .section-divider {
            width: 86px;
            height: 5px;
            border-radius: 999px;
            margin: 24px auto 0;
            background: linear-gradient(135deg, var(--eh-purple), var(--eh-blue));
            box-shadow: 0 12px 28px rgba(109, 93, 252, 0.22);
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 22px;
        }

        .card,
        .feature-card {
            background: rgba(255, 255, 255, 0.88);
            border: 1px solid rgba(15, 23, 42, 0.08);
            border-radius: 28px;
            box-shadow: var(--eh-shadow-soft);
            backdrop-filter: blur(18px);
            transition: 0.25s ease;
        }

        .feature-card {
            padding: 32px 24px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at top, rgba(109, 93, 252, 0.10), transparent 34%),
                linear-gradient(180deg, rgba(255,255,255,0.4), transparent);
            pointer-events: none;
        }

        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--eh-shadow);
            border-color: rgba(109, 93, 252, 0.18);
        }

        .feature-icon {
            position: relative;
            z-index: 1;
            width: 66px;
            height: 66px;
            margin: 0 auto 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 22px;
            background: linear-gradient(135deg, rgba(109, 93, 252, 0.12), rgba(14, 165, 233, 0.12));
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.7), 0 16px 28px rgba(15, 23, 42, 0.08);
            font-size: 1.85rem;
        }

        .feature-card h3 {
            position: relative;
            z-index: 1;
            margin: 0 0 10px;
            color: #0f172a;
            font-size: 1.18rem;
            font-weight: 950;
        }

        .feature-card p {
            position: relative;
            z-index: 1;
            margin: 0;
            color: #64748b;
            line-height: 1.65;
            font-weight: 500;
        }

        .home-cta {
            padding: 30px 0 100px;
            background:
                radial-gradient(circle at 80% 20%, rgba(14, 165, 233, 0.10), transparent 28%),
                linear-gradient(180deg, #f6f8ff 0%, #ffffff 100%);
        }

        .cta-box {
            position: relative;
            overflow: hidden;
            text-align: center;
            padding: 60px 28px;
            border-radius: 34px;
            background:
                linear-gradient(135deg, rgba(255,255,255,0.95), rgba(244,248,255,0.92)),
                radial-gradient(circle at top left, rgba(109, 93, 252, 0.16), transparent 34%);
            border: 1px solid rgba(15, 23, 42, 0.08);
            box-shadow: var(--eh-shadow);
        }

        .cta-box::before {
            content: "";
            position: absolute;
            width: 420px;
            height: 420px;
            left: -190px;
            top: -210px;
            background: radial-gradient(circle, rgba(109, 93, 252, 0.18), transparent 64%);
            pointer-events: none;
        }

        .cta-box::after {
            content: "";
            position: absolute;
            width: 380px;
            height: 380px;
            right: -180px;
            bottom: -210px;
            background: radial-gradient(circle, rgba(14, 165, 233, 0.18), transparent 64%);
            pointer-events: none;
        }

        .cta-box h2 {
            position: relative;
            z-index: 1;
            margin: 0 0 12px;
            color: #0f172a;
            font-size: clamp(1.8rem, 4vw, 3rem);
            font-weight: 950;
            letter-spacing: -1.4px;
        }

        .cta-box p {
            position: relative;
            z-index: 1;
            color: #64748b;
            margin: 0 auto 28px;
            max-width: 620px;
            line-height: 1.7;
            font-weight: 500;
        }

        .cta-box .btn {
            position: relative;
            z-index: 1;
        }

        .footer {
            background: linear-gradient(180deg, #ffffff 0%, #eef4ff 100%);
            color: #334155;
            border-top: 1px solid rgba(15, 23, 42, 0.08);
        }

        .footer-container {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr 1fr;
            gap: 34px;
            padding: 70px 0 44px;
        }

        .footer-logo {
            margin: 0 0 14px;
            color: #0f172a;
            font-size: 1.45rem;
            font-weight: 950;
            letter-spacing: 0.8px;
        }

        .footer-text {
            color: #64748b;
            line-height: 1.75;
            max-width: 420px;
            margin: 0;
            font-weight: 500;
        }

        .footer-col h4 {
            color: #0f172a;
            margin: 0 0 18px;
            font-size: 1rem;
            font-weight: 950;
        }

        .footer-col ul {
            list-style: none;
            padding: 0;
            margin: 0;
            display: grid;
            gap: 12px;
        }

        .footer-col li {
            list-style: none;
        }

        .footer-col a {
            color: #64748b;
            text-decoration: none;
            font-weight: 700;
            transition: 0.2s ease;
        }

        .footer-col a:hover {
            color: var(--eh-purple);
            padding-left: 3px;
        }

        .footer-bottom {
            border-top: 1px solid rgba(15, 23, 42, 0.08);
            background: rgba(255,255,255,0.65);
        }

        .footer-bottom-inner {
            padding: 20px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            color: #64748b;
            font-size: 0.92rem;
            font-weight: 600;
        }

        .footer-bottom-inner p {
            margin: 0;
        }

        @media (max-width: 1100px) {
            .features-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .footer-container {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
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

            .hero {
                min-height: auto;
            }

            .hero-content {
                padding: 80px 0;
                text-align: center;
            }

            .hero-actions {
                justify-content: center;
            }

            .hero-title {
                letter-spacing: -2px;
            }
        }

        @media (max-width: 640px) {
            .features-grid {
                grid-template-columns: 1fr;
            }

            .footer-container {
                grid-template-columns: 1fr;
            }

            .footer-bottom-inner {
                flex-direction: column;
                text-align: center;
            }

            .eh-nav-links {
                gap: 8px;
            }

            .eh-nav-link,
            .eh-nav-btn,
            .eh-nav-btn-outline {
                padding: 9px 12px;
                font-size: 0.86rem;
            }
        }
    </style>
</head>
<body>

<nav class="eh-navbar">
    <div class="eh-navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="eh-brand">
            <i class="fa-regular fa-hexagon"></i>
            <span>EVENTHORIZON</span>
        </a>

        <ul class="eh-nav-links">
            <li>
                <a href="${pageContext.request.contextPath}/index.jsp" class="eh-nav-link active">
                    <i class="fa-solid fa-house"></i><span>Home</span>
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/event?action=list" class="eh-nav-link">
                    <i class="fa-solid fa-calendar-days"></i><span>Events</span>
                </a>
            </li>

            <c:choose>
                <c:when test="${not empty sessionScope.userId and sessionScope.role == 'CUSTOMER'}">
                    <li>
                        <a href="${pageContext.request.contextPath}/booking?action=myBookings" class="eh-nav-link">
                            <i class="fa-solid fa-ticket"></i><span>My Bookings</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/IssueServlet?action=myIssues" class="eh-nav-bell" title="Issue notifications">
                            <i class="fa-regular fa-bell"></i>
                            <% if (navIssueCount > 0) { %>
                                <span class="eh-bell-badge"><%= navIssueCount %></span>
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
                </c:when>

                <c:when test="${not empty sessionScope.userId and sessionScope.role == 'ADMIN'}">
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
                </c:when>

                <c:otherwise>
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
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>

<section class="hero">
    <div class="hero-content">
        <span class="hero-badge">Premium Event Booking Platform</span>

        <h1 class="hero-title">Experience the<br>Extraordinary</h1>

        <p class="hero-subtitle">
            Discover concerts, sports events, tech summits and cultural shows.
            Book your tickets in seconds with a seamless and secure experience.
        </p>

        <div class="hero-actions">
            <a href="${pageContext.request.contextPath}/event?action=list" class="btn btn-primary">🎟 Browse Events</a>
            <c:if test="${empty sessionScope.userId}">
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline">Create Account</a>
            </c:if>
            <c:if test="${not empty sessionScope.userId}">
                <a href="${pageContext.request.contextPath}/IssueServlet?action=report" class="btn btn-outline">Report an Issue</a>
            </c:if>
        </div>
    </div>
</section>

<section class="features-section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">Why <span>EventHorizon?</span></h2>
            <p class="section-subtitle">
                Built for speed, security, and unforgettable experiences.
            </p>
            <div class="section-divider"></div>
        </div>

        <div class="features-grid">
            <div class="card feature-card">
                <div class="feature-icon">⚡</div>
                <h3>Instant Booking</h3>
                <p>Reserve your seat in real-time with no waiting and no confusion.</p>
            </div>

            <div class="card feature-card">
                <div class="feature-icon">🔒</div>
                <h3>Secure &amp; Safe</h3>
                <p>Your account, payments, and bookings stay protected and reliable.</p>
            </div>

            <div class="card feature-card">
                <div class="feature-icon">🎭</div>
                <h3>All Categories</h3>
                <p>Concerts, sports, tech, and cultural events — all in one place.</p>
            </div>

            <div class="card feature-card">
                <div class="feature-icon">📱</div>
                <h3>Easy to Use</h3>
                <p>A clean modern interface that works beautifully on desktop and mobile.</p>
            </div>
        </div>
    </div>
</section>

<section class="home-cta">
    <div class="container">
        <div class="cta-box">
            <h2>Ready to book your next experience?</h2>
            <p>Explore trending events and reserve your seat before they sell out.</p>
            <a href="${pageContext.request.contextPath}/event?action=list" class="btn btn-primary">Explore Events</a>
        </div>
    </div>
</section>

<footer class="footer">
    <div class="container footer-container">
        <div class="footer-col footer-brand-col">
            <h2 class="footer-logo">⬡ EVENTHORIZON</h2>
            <p class="footer-text">
                EventHorizon helps you discover, explore, and book unforgettable
                experiences with a fast, secure, and modern platform.
            </p>
        </div>

        <div class="footer-col">
            <h4>Quick Links</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/event?action=list">Events</a></li>
                <c:if test="${not empty sessionScope.userId and sessionScope.role == 'CUSTOMER'}">
                    <li><a href="${pageContext.request.contextPath}/booking?action=myBookings">My Bookings</a></li>
                </c:if>
                <c:if test="${not empty sessionScope.userId}">
                    <li><a href="${pageContext.request.contextPath}/profile.jsp">Profile</a></li>
                </c:if>
            </ul>
        </div>

        <div class="footer-col">
            <h4>Company</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/aboutUs.jsp">About Us</a></li>
                <li><a href="${pageContext.request.contextPath}/contacts.jsp">Contact</a></li>
                <li><a href="${pageContext.request.contextPath}/privacyPolicy.jsp">Privacy Policy</a></li>
                <li><a href="${pageContext.request.contextPath}/termsConditions.jsp">Terms &amp; Conditions</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4>Support</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/faqs.jsp">Help Center</a></li>
                <li><a href="${pageContext.request.contextPath}/faqs.jsp">FAQs</a></li>
                <li><a href="${pageContext.request.contextPath}/ticketPolicy.jsp">Ticket Policy</a></li>
                <li><a href="${pageContext.request.contextPath}/IssueServlet?action=report">Report an Issue</a></li>
            </ul>
        </div>
    </div>

    <div class="footer-bottom">
        <div class="container footer-bottom-inner">
            <p>© 2026 EventHorizon. All rights reserved.</p>
            <p>Designed for modern event experiences.</p>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>