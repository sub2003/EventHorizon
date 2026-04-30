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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400;1,600&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --ivory:        #FEFAF3;
            --cream:        #F5EDD8;
            --tan:          #E8DCC6;
            --gold:         #C4922A;
            --gold-light:   #DDB555;
            --gold-pale:    #F5E8C8;
            --espresso:     #1A1108;
            --brown:        #3D2B10;
            --mocha:        #7A5C30;
            --text:         #2C1F0E;
            --text-muted:   #7A6548;
            --white:        #FFFFFF;
            --shadow-gold:  rgba(196,146,42,0.18);
            --shadow-soft:  rgba(30,15,5,0.10);
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--ivory);
            color: var(--text);
            -webkit-font-smoothing: antialiased;
        }

        /* ── NAVBAR ─────────────────────────────────── */
        .eh-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: rgba(254, 250, 243, 0.88);
            border-bottom: 1px solid rgba(196,146,42,0.20);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
        }

        .eh-navbar-inner {
            width: min(94%, 1400px);
            margin: 0 auto;
            padding: 14px 0;
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
            color: var(--espresso);
            font-family: 'Cormorant Garamond', serif;
            font-weight: 700;
            font-size: 1.55rem;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .eh-brand-icon {
            width: 34px;
            height: 34px;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 0.85rem;
            box-shadow: 0 4px 12px var(--shadow-gold);
        }

        .eh-nav-links {
            list-style: none;
            display: flex;
            align-items: center;
            gap: 4px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .eh-nav-links li { list-style: none; }

        .eh-nav-link,
        .eh-nav-bell,
        .eh-nav-btn,
        .eh-nav-btn-outline {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            min-height: 38px;
            padding: 8px 14px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 500;
            font-family: 'DM Sans', sans-serif;
            transition: all 0.2s ease;
            border: 1px solid transparent;
            letter-spacing: 0.2px;
        }

        .eh-nav-link { color: var(--brown); }

        .eh-nav-link:hover {
            color: var(--gold);
            background: var(--gold-pale);
        }

        .eh-nav-link.active {
            color: var(--gold);
            background: var(--gold-pale);
            border-color: rgba(196,146,42,0.28);
            font-weight: 600;
        }

        .eh-nav-bell {
            position: relative;
            color: var(--brown);
            width: 40px;
            padding: 0;
            background: var(--cream);
            border-color: var(--tan);
        }

        .eh-nav-bell:hover {
            color: var(--gold);
            border-color: rgba(196,146,42,0.40);
            background: var(--gold-pale);
        }

        .eh-bell-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            min-width: 17px;
            height: 17px;
            padding: 0 4px;
            border-radius: 999px;
            background: linear-gradient(135deg, #E05C3A, #F07848);
            color: #fff;
            font-size: 0.65rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 10px rgba(224,92,58,0.35);
        }

        .eh-nav-btn {
            color: #fff;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            box-shadow: 0 6px 18px var(--shadow-gold);
            font-weight: 600;
            letter-spacing: 0.3px;
        }

        .eh-nav-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 24px var(--shadow-gold);
        }

        .eh-nav-btn-outline {
            color: var(--gold);
            border-color: rgba(196,146,42,0.45);
            background: transparent;
            font-weight: 600;
        }

        .eh-nav-btn-outline:hover {
            background: var(--gold-pale);
            border-color: var(--gold);
        }

        /* ── HERO ────────────────────────────────────── */
        .hero {
            position: relative;
            min-height: 92vh;
            display: flex;
            align-items: center;
            overflow: hidden;
        }

        .hero-bg {
            position: absolute;
            inset: 0;
            background-image: url("https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?auto=format&fit=crop&w=1920&q=90");
            background-size: cover;
            background-position: center 30%;
            background-repeat: no-repeat;
            transform: scale(1.04);
            animation: heroZoom 18s ease-in-out infinite alternate;
        }

        @keyframes heroZoom {
            from { transform: scale(1.04); }
            to   { transform: scale(1.0); }
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(
                105deg,
                rgba(254,250,243,0.97) 0%,
                rgba(245,237,216,0.88) 38%,
                rgba(196,146,42,0.12)  65%,
                rgba(26,17,8,0.20)     100%
            );
        }

        .hero-content {
            position: relative;
            z-index: 2;
            width: min(94%, 1400px);
            margin: 0 auto;
            padding: 80px 0 100px;
            max-width: 680px;
        }

        .hero-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: var(--gold-pale);
            border: 1px solid rgba(196,146,42,0.30);
            border-radius: 100px;
            padding: 6px 16px 6px 10px;
            margin-bottom: 32px;
            animation: fadeUp 0.7s ease both;
        }

        .hero-eyebrow-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--gold);
            box-shadow: 0 0 0 3px rgba(196,146,42,0.20);
            animation: pulse 2s ease infinite;
        }

        @keyframes pulse {
            0%, 100% { box-shadow: 0 0 0 3px rgba(196,146,42,0.20); }
            50%       { box-shadow: 0 0 0 6px rgba(196,146,42,0.08); }
        }

        .hero-eyebrow span {
            font-size: 0.78rem;
            font-weight: 600;
            color: var(--gold);
            letter-spacing: 1.2px;
            text-transform: uppercase;
        }

        .hero-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(3.4rem, 7vw, 6rem);
            font-weight: 700;
            line-height: 1.04;
            color: var(--espresso);
            margin-bottom: 26px;
            letter-spacing: -1px;
            animation: fadeUp 0.7s 0.1s ease both;
        }

        .hero-title em {
            font-style: italic;
            color: var(--gold);
        }

        .hero-subtitle {
            font-size: 1.05rem;
            font-weight: 400;
            color: var(--mocha);
            line-height: 1.75;
            max-width: 520px;
            margin-bottom: 44px;
            animation: fadeUp 0.7s 0.2s ease both;
        }

        .hero-actions {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 14px;
            animation: fadeUp 0.7s 0.3s ease both;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(22px); }
            to   { opacity: 1; transform: translateY(0);    }
        }

        .btn-gold {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 14px 30px;
            border-radius: 10px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.92rem;
            font-weight: 600;
            letter-spacing: 0.3px;
            text-decoration: none;
            transition: all 0.22s ease;
            cursor: pointer;
        }

        .btn-gold-solid {
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            color: #fff;
            box-shadow: 0 10px 28px var(--shadow-gold), 0 2px 6px rgba(0,0,0,0.08);
        }

        .btn-gold-solid:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 36px var(--shadow-gold);
        }

        .btn-gold-outline {
            border: 1.5px solid rgba(196,146,42,0.50);
            color: var(--brown);
            background: rgba(254,250,243,0.80);
        }

        .btn-gold-outline:hover {
            border-color: var(--gold);
            color: var(--gold);
            background: var(--gold-pale);
        }

        /* hero stats strip */
        .hero-stats {
            position: relative;
            z-index: 2;
            width: min(94%, 1400px);
            margin: -60px auto 0;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1px;
            background: rgba(196,146,42,0.18);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 20px 60px var(--shadow-soft), 0 2px 0 rgba(196,146,42,0.15);
        }

        .hero-stat {
            background: var(--white);
            padding: 28px 32px;
            text-align: center;
            animation: fadeUp 0.7s 0.4s ease both;
        }

        .hero-stat-num {
            font-family: 'Cormorant Garamond', serif;
            font-size: 2.6rem;
            font-weight: 700;
            color: var(--gold);
            line-height: 1;
            margin-bottom: 6px;
        }

        .hero-stat-label {
            font-size: 0.78rem;
            font-weight: 500;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* ── FEATURES ────────────────────────────────── */
        .features-section {
            padding: 120px 0 80px;
        }

        .container {
            width: min(94%, 1300px);
            margin: 0 auto;
        }

        .section-header {
            text-align: center;
            margin-bottom: 64px;
        }

        .section-label {
            display: inline-block;
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 14px;
        }

        .section-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(2.2rem, 4vw, 3.4rem);
            font-weight: 700;
            color: var(--espresso);
            line-height: 1.12;
            margin-bottom: 16px;
            letter-spacing: -0.5px;
        }

        .section-title em {
            font-style: italic;
            color: var(--gold);
        }

        .section-subtitle {
            font-size: 1rem;
            color: var(--text-muted);
            max-width: 480px;
            margin: 0 auto;
            line-height: 1.7;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .feature-card {
            background: var(--white);
            border: 1px solid var(--tan);
            border-radius: 16px;
            padding: 36px 28px;
            position: relative;
            overflow: hidden;
            transition: all 0.28s ease;
            cursor: default;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--gold), var(--gold-light));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.32s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 50px var(--shadow-soft), 0 4px 12px var(--shadow-gold);
            border-color: rgba(196,146,42,0.25);
        }

        .feature-card:hover::before { transform: scaleX(1); }

        .feature-icon-wrap {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            background: linear-gradient(135deg, var(--gold-pale), var(--cream));
            border: 1px solid rgba(196,146,42,0.22);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 22px;
            font-size: 1.4rem;
        }

        .feature-card h3 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--espresso);
            margin-bottom: 10px;
            letter-spacing: -0.2px;
        }

        .feature-card p {
            font-size: 0.88rem;
            color: var(--text-muted);
            line-height: 1.7;
        }

        /* ── CTA BAND ─────────────────────────────────── */
        .home-cta {
            padding: 0 0 120px;
        }

        .cta-box {
            position: relative;
            border-radius: 24px;
            overflow: hidden;
            padding: 80px 60px;
            text-align: center;
            background: linear-gradient(135deg, var(--espresso) 0%, var(--brown) 100%);
            box-shadow: 0 30px 80px rgba(26,17,8,0.22);
        }

        .cta-box::before {
            content: '';
            position: absolute;
            inset: 0;
            background-image: url("https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=1200&q=80");
            background-size: cover;
            background-position: center;
            opacity: 0.12;
        }

        .cta-box-inner {
            position: relative;
            z-index: 1;
        }

        .cta-label {
            display: inline-block;
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            color: var(--gold-light);
            margin-bottom: 18px;
        }

        .cta-box h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(2rem, 4vw, 3rem);
            font-weight: 700;
            color: #fff;
            margin-bottom: 16px;
            line-height: 1.15;
            letter-spacing: -0.5px;
        }

        .cta-box h2 em {
            font-style: italic;
            color: var(--gold-light);
        }

        .cta-box p {
            color: rgba(255,255,255,0.65);
            font-size: 1rem;
            margin-bottom: 36px;
            line-height: 1.7;
        }

        .btn-gold-cta {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 15px 36px;
            border-radius: 10px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.92rem;
            font-weight: 600;
            letter-spacing: 0.3px;
            text-decoration: none;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            color: #fff;
            box-shadow: 0 10px 30px rgba(196,146,42,0.35);
            transition: all 0.22s ease;
        }

        .btn-gold-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 40px rgba(196,146,42,0.45);
        }

        /* ── FOOTER ──────────────────────────────────── */
        .footer {
            background: var(--espresso);
            color: rgba(255,255,255,0.72);
        }

        .footer-container {
            display: grid;
            grid-template-columns: 1.6fr 1fr 1fr 1fr;
            gap: 48px;
            padding: 72px 0 60px;
        }

        .footer-logo {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: 2px;
            color: var(--white);
            margin-bottom: 18px;
        }

        .footer-logo span {
            color: var(--gold-light);
        }

        .footer-text {
            font-size: 0.875rem;
            line-height: 1.75;
            color: rgba(255,255,255,0.50);
            max-width: 280px;
        }

        .footer-col h4 {
            font-family: 'DM Sans', sans-serif;
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: var(--gold-light);
            margin-bottom: 20px;
        }

        .footer-col ul {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .footer-col ul li a {
            font-size: 0.875rem;
            color: rgba(255,255,255,0.52);
            text-decoration: none;
            transition: color 0.18s ease;
        }

        .footer-col ul li a:hover { color: var(--gold-light); }

        .footer-bottom {
            border-top: 1px solid rgba(255,255,255,0.08);
        }

        .footer-bottom-inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 22px 0;
            font-size: 0.8rem;
            color: rgba(255,255,255,0.30);
        }

        .footer-bottom-inner a {
            color: rgba(255,255,255,0.30);
            text-decoration: none;
        }

        /* ── RESPONSIVE ──────────────────────────────── */
        @media (max-width: 1024px) {
            .features-grid { grid-template-columns: repeat(2, 1fr); }
            .footer-container { grid-template-columns: 1fr 1fr; gap: 36px; }
            .hero-stats { grid-template-columns: repeat(3, 1fr); }
        }

        @media (max-width: 768px) {
            .eh-navbar-inner { flex-direction: column; align-items: stretch; }
            .eh-nav-links { justify-content: center; }
            .eh-brand { justify-content: center; }
            .hero-content { padding: 60px 0 160px; }
            .hero-stats { grid-template-columns: 1fr; margin-top: -30px; }
            .features-grid { grid-template-columns: 1fr; }
            .footer-container { grid-template-columns: 1fr; gap: 28px; padding: 48px 0 36px; }
            .cta-box { padding: 50px 24px; }
            .footer-bottom-inner { flex-direction: column; gap: 8px; text-align: center; }
        }
    </style>
</head>
<body>

<!-- ═══════════════════════ NAVBAR ═══════════════════════ -->
<nav class="eh-navbar">
    <div class="eh-navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="eh-brand">
            <span class="eh-brand-icon"><i class="fa-regular fa-hexagon"></i></span>
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

<!-- ═══════════════════════ HERO ════════════════════════ -->
<section class="hero">
    <div class="hero-bg"></div>
    <div class="hero-overlay"></div>

    <div class="hero-content">
        <div class="hero-eyebrow">
            <span class="hero-eyebrow-dot"></span>
            <span>Premium Event Booking Platform</span>
        </div>

        <h1 class="hero-title">
            Experience<br>the <em>Extraordinary</em>
        </h1>

        <p class="hero-subtitle">
            Discover concerts, sports events, tech summits and cultural shows.
            Book your tickets in seconds with a seamless and secure experience.
        </p>

        <div class="hero-actions">
            <a href="${pageContext.request.contextPath}/event?action=list" class="btn-gold btn-gold-solid">
                <i class="fa-solid fa-ticket"></i> Browse Events
            </a>
            <c:if test="${empty sessionScope.userId}">
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn-gold btn-gold-outline">
                    <i class="fa-solid fa-user-plus"></i> Create Account
                </a>
            </c:if>
            <c:if test="${not empty sessionScope.userId}">
                <a href="${pageContext.request.contextPath}/IssueServlet?action=report" class="btn-gold btn-gold-outline">
                    <i class="fa-regular fa-flag"></i> Report an Issue
                </a>
            </c:if>
        </div>
    </div>
</section>

<!-- stats strip -->
<div class="hero-stats container">
    <div class="hero-stat">
        <div class="hero-stat-num">500+</div>
        <div class="hero-stat-label">Live Events</div>
    </div>
    <div class="hero-stat">
        <div class="hero-stat-num">80K+</div>
        <div class="hero-stat-label">Tickets Sold</div>
    </div>
    <div class="hero-stat">
        <div class="hero-stat-num">4.9★</div>
        <div class="hero-stat-label">User Rating</div>
    </div>
</div>

<!-- ═══════════════════ FEATURES ════════════════════════ -->
<section class="features-section">
    <div class="container">
        <div class="section-header">
            <span class="section-label">Why choose us</span>
            <h2 class="section-title">Why <em>EventHorizon?</em></h2>
            <p class="section-subtitle">Built for speed, security, and unforgettable experiences.</p>
        </div>

        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon-wrap">⚡</div>
                <h3>Instant Booking</h3>
                <p>Reserve your seat in real-time with no waiting and no confusion.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon-wrap">🔒</div>
                <h3>Secure &amp; Safe</h3>
                <p>Your account, payments, and bookings stay protected and reliable.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon-wrap">🎭</div>
                <h3>All Categories</h3>
                <p>Concerts, sports, tech, and cultural events — all in one place.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon-wrap">📱</div>
                <h3>Easy to Use</h3>
                <p>A clean modern interface that works beautifully on desktop and mobile.</p>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════ CTA ══════════════════════════ -->
<section class="home-cta">
    <div class="container">
        <div class="cta-box">
            <div class="cta-box-inner">
                <span class="cta-label">Don't miss out</span>
                <h2>Ready to book your<br><em>next experience?</em></h2>
                <p>Explore trending events and reserve your seat before they sell out.</p>
                <a href="${pageContext.request.contextPath}/event?action=list" class="btn-gold-cta">
                    <i class="fa-solid fa-arrow-right"></i> Explore Events
                </a>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════ FOOTER ══════════════════════════ -->
<footer class="footer">
    <div class="container footer-container">
        <div class="footer-col">
            <h2 class="footer-logo">⬡ EVENT<span>HORIZON</span></h2>
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
