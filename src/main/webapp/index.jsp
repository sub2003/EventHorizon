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
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:           #F6F7F9;
            --bg-card:      #FFFFFF;
            --bg-silver:    #EEF0F4;
            --midnight:     #181C2E;
            --midnight-80:  rgba(24,28,46,0.80);
            --midnight-08:  rgba(24,28,46,0.08);
            --midnight-06:  rgba(24,28,46,0.06);
            --silver:       #8A96A8;
            --silver-light: #C8CDD6;
            --silver-pale:  #F0F2F5;
            --text:         #181C2E;
            --text-sub:     #4A5368;
            --text-muted:   #8A96A8;
            --border:       rgba(24,28,46,0.10);
            --border-mid:   rgba(24,28,46,0.16);
            --shadow-sm:    0 1px 3px rgba(24,28,46,0.07), 0 4px 12px rgba(24,28,46,0.05);
            --shadow-md:    0 4px 20px rgba(24,28,46,0.10), 0 1px 4px rgba(24,28,46,0.06);
            --shadow-lg:    0 12px 40px rgba(24,28,46,0.14), 0 2px 8px rgba(24,28,46,0.07);
            --radius-sm:    8px;
            --radius-md:    12px;
            --radius-lg:    18px;
            --radius-xl:    24px;
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg);
            color: var(--text);
            -webkit-font-smoothing: antialiased;
            line-height: 1.6;
        }

        /* ━━━━━━━━━━━━━━━━ NAVBAR ━━━━━━━━━━━━━━━━ */
        .navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            background: rgba(246, 247, 249, 0.94);
            border-bottom: 1px solid var(--border);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
        }

        .navbar-inner {
            width: min(96%, 1380px);
            margin: 0 auto;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        .brand {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            flex-shrink: 0;
        }

        .brand-mark {
            width: 34px;
            height: 34px;
            border-radius: var(--radius-sm);
            background: var(--midnight);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 0.85rem;
            flex-shrink: 0;
        }

        .brand-name {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 1.12rem;
            color: var(--midnight);
            letter-spacing: 1.8px;
            text-transform: uppercase;
        }

        .nav-links {
            list-style: none;
            display: flex;
            align-items: center;
            gap: 2px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .nav-links li { list-style: none; }

        .nav-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 13px;
            border-radius: var(--radius-sm);
            text-decoration: none;
            font-size: 0.865rem;
            font-weight: 500;
            color: var(--text-sub);
            border: 1px solid transparent;
            transition: all 0.16s ease;
            white-space: nowrap;
        }

        .nav-link:hover {
            color: var(--midnight);
            background: var(--midnight-06);
            border-color: var(--border);
        }

        .nav-link.active {
            color: var(--midnight);
            background: var(--midnight-08);
            border-color: var(--border-mid);
            font-weight: 600;
        }

        .nav-bell {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            position: relative;
            width: 36px;
            height: 36px;
            border-radius: var(--radius-sm);
            color: var(--text-sub);
            background: var(--bg-card);
            border: 1px solid var(--border);
            text-decoration: none;
            transition: all 0.16s ease;
        }

        .nav-bell:hover {
            color: var(--midnight);
            border-color: var(--border-mid);
            background: var(--silver-pale);
        }

        .bell-badge {
            position: absolute;
            top: -5px; right: -5px;
            min-width: 16px; height: 16px;
            padding: 0 4px;
            border-radius: 999px;
            background: #E04040;
            color: #fff;
            font-size: 0.60rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .nav-btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 18px;
            border-radius: var(--radius-sm);
            text-decoration: none;
            font-size: 0.865rem;
            font-weight: 600;
            white-space: nowrap;
            transition: all 0.18s ease;
            border: 1.5px solid transparent;
            font-family: 'Inter', sans-serif;
        }

        .nav-btn-dark {
            background: var(--midnight);
            color: #fff;
            box-shadow: 0 4px 14px rgba(24,28,46,0.22);
        }

        .nav-btn-dark:hover {
            background: #252A40;
            transform: translateY(-1px);
            box-shadow: 0 8px 20px rgba(24,28,46,0.28);
        }

        .nav-btn-outline {
            color: var(--midnight);
            border-color: var(--border-mid);
            background: var(--bg-card);
        }

        .nav-btn-outline:hover {
            background: var(--silver-pale);
            border-color: var(--silver);
        }

        /* ━━━━━━━━━━━━━━━━ HERO ━━━━━━━━━━━━━━━━ */
        .hero {
            position: relative;
            min-height: 90vh;
            display: flex;
            align-items: center;
            overflow: hidden;
        }

        .hero-img {
            position: absolute;
            inset: 0;
            background-image: url("https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?auto=format&fit=crop&w=1920&q=90");
            background-size: cover;
            background-position: center 35%;
            z-index: 0;
        }

        /* Light silver-left scrim — keeps right image visible */
        .hero-img::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(
                100deg,
                rgba(246,247,249,0.52) 0%,
                rgba(246,247,249,0.12) 50%,
                rgba(246,247,249,0.00) 100%
            );
        }

        .hero-wrap {
            position: relative;
            z-index: 2;
            width: min(96%, 1380px);
            margin: 0 auto;
            padding: 80px 0 120px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Crisp white card — midnight border, sharp shadow */
        .hero-card {
            background: rgba(255, 255, 255, 0.96);
            border: 1.5px solid var(--midnight);
            border-radius: var(--radius-xl);
            padding: 56px 60px;
            max-width: 600px;
            width: 100%;
            text-align: center;
            box-shadow:
                6px 6px 0px var(--midnight),
                0 20px 60px rgba(24,28,46,0.18);
        }

        .hero-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--silver-pale);
            border: 1px solid var(--border-mid);
            border-radius: 999px;
            padding: 5px 14px;
            margin-bottom: 28px;
        }

        .hero-tag-dot {
            width: 6px; height: 6px;
            border-radius: 50%;
            background: var(--midnight);
            flex-shrink: 0;
        }

        .hero-tag span {
            font-size: 0.71rem;
            font-weight: 600;
            letter-spacing: 1.6px;
            text-transform: uppercase;
            color: var(--text-sub);
        }

        .hero-heading {
            font-family: 'Syne', sans-serif;
            font-size: clamp(2.4rem, 5vw, 4rem);
            font-weight: 800;
            line-height: 1.06;
            color: var(--midnight);
            margin-bottom: 20px;
            letter-spacing: -1px;
        }

        .hero-heading mark {
            background: none;
            color: var(--silver);
            position: relative;
        }

        .hero-sub {
            font-size: 1rem;
            font-weight: 400;
            color: var(--text-sub);
            line-height: 1.75;
            margin-bottom: 38px;
            max-width: 460px;
            margin-left: auto;
            margin-right: auto;
        }

        .hero-btns {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            justify-content: center;
        }

        .btn-midnight {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 13px 28px;
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            background: var(--midnight);
            color: #fff;
            border: 1.5px solid var(--midnight);
            box-shadow: 0 4px 16px rgba(24,28,46,0.22);
            transition: all 0.20s ease;
            font-family: 'Inter', sans-serif;
        }

        .btn-midnight:hover {
            background: #252A40;
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(24,28,46,0.28);
        }

        .btn-ghost {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 12px 26px;
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            border: 1.5px solid var(--border-mid);
            color: var(--midnight);
            background: transparent;
            transition: all 0.20s ease;
            font-family: 'Inter', sans-serif;
        }

        .btn-ghost:hover {
            background: var(--silver-pale);
            border-color: var(--silver);
        }

        /* ━━━━━━━━━━━━━━━━ STATS ━━━━━━━━━━━━━━━━ */
        .stats-wrap {
            position: relative;
            z-index: 3;
            width: min(96%, 1380px);
            margin: -44px auto 0;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            border-radius: var(--radius-lg);
            overflow: hidden;
            border: 1px solid var(--border);
            box-shadow: var(--shadow-lg);
            background: var(--bg-card);
        }

        .stat-item {
            padding: 32px 36px;
            text-align: center;
            border-right: 1px solid var(--border);
            transition: background 0.18s ease;
        }

        .stat-item:last-child { border-right: none; }
        .stat-item:hover { background: var(--silver-pale); }

        .stat-num {
            font-family: 'Syne', sans-serif;
            font-size: 2.6rem;
            font-weight: 800;
            color: var(--midnight);
            line-height: 1;
            margin-bottom: 6px;
            letter-spacing: -1px;
        }

        .stat-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1.4px;
        }

        /* ━━━━━━━━━━━━━━━━ FEATURES ━━━━━━━━━━━━━━━━ */
        .features-section {
            padding: 120px 0 80px;
        }

        .container {
            width: min(96%, 1380px);
            margin: 0 auto;
        }

        .sec-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
        }

        .sec-eyebrow-line {
            width: 24px;
            height: 2px;
            background: var(--silver);
            border-radius: 2px;
        }

        .sec-eyebrow span {
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 2.2px;
            text-transform: uppercase;
            color: var(--silver);
        }

        .sec-title {
            font-family: 'Syne', sans-serif;
            font-size: clamp(1.9rem, 3.5vw, 2.8rem);
            font-weight: 800;
            color: var(--midnight);
            line-height: 1.12;
            margin-bottom: 14px;
            letter-spacing: -0.5px;
        }

        .sec-title mark {
            background: none;
            color: var(--silver);
        }

        .sec-sub {
            font-size: 0.975rem;
            color: var(--text-sub);
            line-height: 1.72;
            max-width: 460px;
        }

        .section-header { margin-bottom: 56px; }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .feat-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 36px 28px;
            position: relative;
            overflow: hidden;
            transition: transform 0.22s ease, box-shadow 0.22s ease, border-color 0.22s ease;
        }

        .feat-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: var(--midnight);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.28s ease;
        }

        .feat-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
            border-color: var(--border-mid);
        }

        .feat-card:hover::before { transform: scaleX(1); }

        .feat-icon {
            width: 48px; height: 48px;
            border-radius: var(--radius-md);
            background: var(--bg-silver);
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            margin-bottom: 20px;
            color: var(--midnight);
        }

        .feat-card h3 {
            font-family: 'Syne', sans-serif;
            font-size: 1.08rem;
            font-weight: 700;
            color: var(--midnight);
            margin-bottom: 10px;
            letter-spacing: -0.2px;
        }

        .feat-card p {
            font-size: 0.875rem;
            color: var(--text-sub);
            line-height: 1.70;
        }

        /* ━━━━━━━━━━━━━━━━ CTA ━━━━━━━━━━━━━━━━ */
        .cta-section { padding: 0 0 110px; }

        .cta-box {
            border-radius: var(--radius-xl);
            overflow: hidden;
            position: relative;
            min-height: 400px;
            display: flex;
            align-items: center;
            box-shadow: 8px 8px 0px var(--midnight), var(--shadow-lg);
            border: 1.5px solid var(--midnight);
        }

        .cta-bg {
            position: absolute;
            inset: 0;
            background-image: url("https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?auto=format&fit=crop&w=1400&q=90");
            background-size: cover;
            background-position: center 45%;
            z-index: 0;
        }

        .cta-bg::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(
                100deg,
                rgba(24,28,46,0.90) 0%,
                rgba(24,28,46,0.72) 55%,
                rgba(24,28,46,0.35) 100%
            );
        }

        .cta-inner {
            position: relative;
            z-index: 2;
            padding: 76px 76px;
            max-width: 660px;
        }

        .cta-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
        }

        .cta-eyebrow-line {
            width: 20px;
            height: 2px;
            background: var(--silver-light);
            border-radius: 2px;
        }

        .cta-eyebrow span {
            font-size: 0.71rem;
            font-weight: 600;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: var(--silver-light);
        }

        .cta-inner h2 {
            font-family: 'Syne', sans-serif;
            font-size: clamp(1.9rem, 3.2vw, 2.9rem);
            font-weight: 800;
            color: #FFFFFF;
            line-height: 1.12;
            margin-bottom: 16px;
            letter-spacing: -0.5px;
        }

        .cta-inner h2 mark {
            background: none;
            color: var(--silver-light);
        }

        .cta-inner p {
            font-size: 1rem;
            color: rgba(255,255,255,0.65);
            line-height: 1.72;
            margin-bottom: 38px;
            max-width: 460px;
        }

        .btn-cta {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 32px;
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            background: #FFFFFF;
            color: var(--midnight);
            border: 1.5px solid #FFFFFF;
            box-shadow: 0 4px 20px rgba(0,0,0,0.20);
            transition: all 0.20s ease;
            font-family: 'Inter', sans-serif;
        }

        .btn-cta:hover {
            background: var(--silver-pale);
            transform: translateY(-2px);
            box-shadow: 0 10px 32px rgba(0,0,0,0.28);
        }

        /* ━━━━━━━━━━━━━━━━ FOOTER ━━━━━━━━━━━━━━━━ */
        .footer {
            background: var(--midnight);
            color: rgba(255,255,255,0.65);
        }

        .footer-main {
            width: min(96%, 1380px);
            margin: 0 auto;
            padding: 76px 0 60px;
            display: grid;
            grid-template-columns: 1.8fr 1fr 1fr 1fr;
            gap: 56px;
        }

        .footer-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 16px;
        }

        .footer-brand-mark {
            width: 30px; height: 30px;
            border-radius: 7px;
            background: rgba(255,255,255,0.12);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 0.8rem;
        }

        .footer-brand-name {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 1rem;
            color: #fff;
            letter-spacing: 1.8px;
            text-transform: uppercase;
        }

        .footer-desc {
            font-size: 0.875rem;
            color: rgba(255,255,255,0.42);
            line-height: 1.78;
            max-width: 260px;
        }

        .footer-col h4 {
            font-family: 'Syne', sans-serif;
            font-size: 0.68rem;
            font-weight: 700;
            letter-spacing: 2.2px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.35);
            margin-bottom: 20px;
        }

        .footer-col ul {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 11px;
        }

        .footer-col ul li a {
            font-size: 0.875rem;
            color: rgba(255,255,255,0.52);
            text-decoration: none;
            transition: color 0.16s ease;
        }

        .footer-col ul li a:hover { color: #fff; }

        .footer-bottom {
            border-top: 1px solid rgba(255,255,255,0.08);
        }

        .footer-bottom-inner {
            width: min(96%, 1380px);
            margin: 0 auto;
            padding: 22px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.78rem;
            color: rgba(255,255,255,0.28);
        }

        /* ━━━━━━━━━━━━━━━━ RESPONSIVE ━━━━━━━━━━━━━━━━ */
        @media (max-width: 1100px) {
            .features-grid { grid-template-columns: repeat(2, 1fr); }
            .footer-main { grid-template-columns: 1fr 1fr; gap: 36px; }
        }

        @media (max-width: 768px) {
            .navbar-inner { height: auto; padding: 14px 0; flex-direction: column; align-items: stretch; }
            .brand { justify-content: center; }
            .nav-links { justify-content: center; }

            .hero { min-height: auto; }
            .hero-wrap { padding: 40px 0 120px; }
            .hero-card { padding: 36px 24px; }
            .hero-heading { font-size: 2.2rem; }
            .hero-btns { flex-direction: column; align-items: center; }

            .stats-wrap { margin-top: -24px; }
            .stats-grid { grid-template-columns: 1fr; border-radius: var(--radius-md); }
            .stat-item { border-right: none; border-bottom: 1px solid var(--border); }
            .stat-item:last-child { border-bottom: none; }

            .features-section { padding: 80px 0 56px; }
            .features-grid { grid-template-columns: 1fr; }

            .cta-inner { padding: 48px 28px; }
            .cta-inner p { max-width: 100%; }

            .footer-main { grid-template-columns: 1fr; gap: 32px; padding: 52px 0 40px; }
            .footer-bottom-inner { flex-direction: column; gap: 8px; text-align: center; }
        }
    </style>
</head>
<body>

<!-- ══════════════════════ NAVBAR ══════════════════════ -->
<nav class="navbar">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="brand">
            <span class="brand-mark"><i class="fa-regular fa-hexagon"></i></span>
            <span class="brand-name">EventHorizon</span>
        </a>

        <ul class="nav-links">
            <li>
                <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link active">
                    <i class="fa-solid fa-house"></i> Home
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/event?action=list" class="nav-link">
                    <i class="fa-solid fa-calendar-days"></i> Events
                </a>
            </li>

            <c:choose>
                <c:when test="${not empty sessionScope.userId and sessionScope.role == 'CUSTOMER'}">
                    <li>
                        <a href="${pageContext.request.contextPath}/booking?action=myBookings" class="nav-link">
                            <i class="fa-solid fa-ticket"></i> My Bookings
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/IssueServlet?action=myIssues" class="nav-bell" title="Notifications">
                            <i class="fa-regular fa-bell"></i>
                            <% if (navIssueCount > 0) { %>
                                <span class="bell-badge"><%= navIssueCount %></span>
                            <% } %>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link">
                            <i class="fa-regular fa-user"></i> Profile
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/user?action=logout" class="nav-btn nav-btn-dark">
                            <i class="fa-solid fa-right-from-bracket"></i> Logout
                        </a>
                    </li>
                </c:when>

                <c:when test="${not empty sessionScope.userId and sessionScope.role == 'ADMIN'}">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="nav-link">
                            <i class="fa-solid fa-gauge-high"></i> Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link">
                            <i class="fa-regular fa-user"></i> Profile
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/user?action=logout" class="nav-btn nav-btn-dark">
                            <i class="fa-solid fa-right-from-bracket"></i> Logout
                        </a>
                    </li>
                </c:when>

                <c:otherwise>
                    <li>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="nav-link">
                            <i class="fa-solid fa-right-to-bracket"></i> Login
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="nav-btn nav-btn-outline">
                            <i class="fa-solid fa-user-plus"></i> Register
                        </a>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>

<!-- ══════════════════════ HERO ══════════════════════ -->
<section class="hero">
    <div class="hero-img"></div>

    <div class="hero-wrap">
        <div class="hero-card">
            <h1 class="hero-heading">
                Experience the<br><mark>Extraordinary</mark>
            </h1>

            <p class="hero-sub">
                Discover concerts, sports events, tech summits and cultural shows.
                Book your tickets in seconds with a seamless and secure experience.
            </p>

            <div class="hero-btns">
                <a href="${pageContext.request.contextPath}/event?action=list" class="btn-midnight">
                    <i class="fa-solid fa-ticket"></i> Browse Events
                </a>
                <c:if test="${empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn-ghost">
                        <i class="fa-solid fa-user-plus"></i> Create Account
                    </a>
                </c:if>
                <c:if test="${not empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/IssueServlet?action=report" class="btn-ghost">
                        <i class="fa-regular fa-flag"></i> Report an Issue
                    </a>
                </c:if>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════ STATS ══════════════════════ -->
<div class="stats-wrap">
    <div class="stats-grid">
        <div class="stat-item">
            <div class="stat-num">500+</div>
            <div class="stat-label">Live Events</div>
        </div>
        <div class="stat-item">
            <div class="stat-num">80K+</div>
            <div class="stat-label">Tickets Sold</div>
        </div>
        <div class="stat-item">
            <div class="stat-num">4.9 ★</div>
            <div class="stat-label">User Rating</div>
        </div>
    </div>
</div>

<!-- ══════════════════════ FEATURES ══════════════════════ -->
<section class="features-section">
    <div class="container">
        <div class="section-header">
            <div class="sec-eyebrow">
                <span class="sec-eyebrow-line"></span>
                <span>Why choose us</span>
            </div>
            <h2 class="sec-title">Why <mark>EventHorizon?</mark></h2>
            <p class="sec-sub">Built for speed, security, and unforgettable experiences.</p>
        </div>

        <div class="features-grid">
            <div class="feat-card">
                <div class="feat-icon"><i class="fa-solid fa-bolt"></i></div>
                <h3>Instant Booking</h3>
                <p>Reserve your seat in real-time with no waiting and no confusion.</p>
            </div>
            <div class="feat-card">
                <div class="feat-icon"><i class="fa-solid fa-shield-halved"></i></div>
                <h3>Secure &amp; Safe</h3>
                <p>Your account, payments, and bookings stay protected and reliable.</p>
            </div>
            <div class="feat-card">
                <div class="feat-icon"><i class="fa-solid fa-masks-theater"></i></div>
                <h3>All Categories</h3>
                <p>Concerts, sports, tech, and cultural events — all in one place.</p>
            </div>
            <div class="feat-card">
                <div class="feat-icon"><i class="fa-solid fa-mobile-screen"></i></div>
                <h3>Easy to Use</h3>
                <p>A clean modern interface that works beautifully on desktop and mobile.</p>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════ CTA ══════════════════════ -->
<section class="cta-section">
    <div class="container">
        <div class="cta-box">
            <div class="cta-bg"></div>
            <div class="cta-inner">
                <div class="cta-eyebrow">
                    <span class="cta-eyebrow-line"></span>
                    <span>Don't miss out</span>
                </div>
                <h2>Ready to book your <mark>next experience?</mark></h2>
                <p>Explore trending events and reserve your seat before they sell out.</p>
                <a href="${pageContext.request.contextPath}/event?action=list" class="btn-cta">
                    <i class="fa-solid fa-arrow-right"></i> Explore Events
                </a>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════ FOOTER ══════════════════════ -->
<footer class="footer">
    <div class="footer-main">
        <div>
            <div class="footer-brand">
                <span class="footer-brand-mark"><i class="fa-regular fa-hexagon"></i></span>
                <span class="footer-brand-name">EventHorizon</span>
            </div>
            <p class="footer-desc">
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
        <div class="footer-bottom-inner">
            <p>© 2026 EventHorizon. All rights reserved.</p>
            <p>Designed for modern event experiences.</p>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
