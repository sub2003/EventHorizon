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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700;0,800;1,700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --ivory:       #FAF7F2;
            --cream:       #F2EDE3;
            --white:       #FFFFFF;
            --gold:        #A87832;
            --gold-mid:    #C49A45;
            --gold-pale:   #F0E4CC;
            --espresso:    #1C1208;
            --charcoal:    #2E2416;
            --brown-soft:  #6B5235;
            --muted:       #8C7355;
            --border:      rgba(168,120,50,0.18);
            --shadow-card: 0 4px 24px rgba(28,18,8,0.09);
            --shadow-gold: 0 8px 28px rgba(168,120,50,0.22);
            --radius:      14px;
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--ivory);
            color: var(--charcoal);
            -webkit-font-smoothing: antialiased;
            line-height: 1.6;
        }

        /* ━━━━━━━━━━━━━━ NAVBAR ━━━━━━━━━━━━━━ */
        .navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            background: rgba(250, 247, 242, 0.95);
            border-bottom: 1px solid var(--border);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
        }

        .navbar-inner {
            width: min(95%, 1360px);
            margin: 0 auto;
            height: 66px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .brand {
            display: inline-flex;
            align-items: center;
            gap: 11px;
            text-decoration: none;
            flex-shrink: 0;
        }

        .brand-mark {
            width: 36px;
            height: 36px;
            border-radius: 9px;
            background: linear-gradient(145deg, var(--gold), var(--gold-mid));
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 0.9rem;
            box-shadow: 0 4px 12px rgba(168,120,50,0.30);
            flex-shrink: 0;
        }

        .brand-name {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.28rem;
            color: var(--espresso);
            letter-spacing: 1.5px;
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
            padding: 8px 13px;
            border-radius: 9px;
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--brown-soft);
            border: 1px solid transparent;
            transition: all 0.18s ease;
            white-space: nowrap;
        }

        .nav-link:hover, .nav-link.active {
            color: var(--gold);
            background: var(--gold-pale);
            border-color: rgba(168,120,50,0.22);
        }

        .nav-bell {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            position: relative;
            width: 38px;
            height: 38px;
            border-radius: 9px;
            color: var(--brown-soft);
            background: var(--cream);
            border: 1px solid var(--border);
            text-decoration: none;
            transition: all 0.18s ease;
        }

        .nav-bell:hover {
            color: var(--gold);
            border-color: rgba(168,120,50,0.35);
            background: var(--gold-pale);
        }

        .bell-badge {
            position: absolute;
            top: -5px; right: -5px;
            min-width: 16px; height: 16px;
            padding: 0 4px;
            border-radius: 999px;
            background: #D94F38;
            color: #fff;
            font-size: 0.62rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .nav-btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 9px 18px;
            border-radius: 9px;
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 600;
            white-space: nowrap;
            transition: all 0.20s ease;
            border: 1.5px solid transparent;
        }

        .nav-btn-gold {
            background: linear-gradient(135deg, var(--gold), var(--gold-mid));
            color: #fff;
            box-shadow: var(--shadow-gold);
        }

        .nav-btn-gold:hover {
            transform: translateY(-1px);
            box-shadow: 0 12px 32px rgba(168,120,50,0.30);
        }

        .nav-btn-outline {
            color: var(--gold);
            border-color: rgba(168,120,50,0.40);
            background: transparent;
        }

        .nav-btn-outline:hover {
            background: var(--gold-pale);
            border-color: var(--gold);
        }

        /* ━━━━━━━━━━━━━━ HERO ━━━━━━━━━━━━━━ */
        .hero {
            position: relative;
            min-height: 88vh;
            display: flex;
            align-items: center;
            overflow: hidden;
        }

        /* Full-bleed background image — clearly visible */
        .hero-img {
            position: absolute;
            inset: 0;
            background-image: url("https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?auto=format&fit=crop&w=1920&q=90");
            background-size: cover;
            background-position: center 35%;
            z-index: 0;
        }

        /* Soft left-fade only — image stays bright on the right */
        .hero-img::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(
                100deg,
                rgba(250,247,242,0.55) 0%,
                rgba(250,247,242,0.10) 52%,
                rgba(250,247,242,0.00) 100%
            );
        }

        .hero-panel {
            position: relative;
            z-index: 2;
            width: min(95%, 1360px);
            margin: 0 auto;
            padding: 80px 0 110px;
            display: flex;
            align-items: center;
        }

        /* Warm-white frosted card — text sits on this, NOT the image */
        .hero-card {
            background: rgba(255, 252, 248, 0.94);
            border: 1px solid rgba(168,120,50,0.18);
            border-radius: 20px;
            padding: 52px 52px;
            max-width: 570px;
            box-shadow:
                0 2px 0 rgba(168,120,50,0.12),
                0 24px 64px rgba(28,18,8,0.16),
                0 4px 16px rgba(28,18,8,0.07);
        }

        .hero-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 24px;
            padding: 6px 14px 6px 10px;
            border-radius: 100px;
            background: var(--gold-pale);
            border: 1px solid rgba(168,120,50,0.25);
        }

        .eyebrow-dot {
            width: 7px; height: 7px;
            border-radius: 50%;
            background: var(--gold);
            flex-shrink: 0;
        }

        .hero-eyebrow span {
            font-size: 0.73rem;
            font-weight: 600;
            letter-spacing: 1.4px;
            text-transform: uppercase;
            color: var(--gold);
        }

        .hero-heading {
            font-family: 'Playfair Display', serif;
            font-size: clamp(2.4rem, 4.5vw, 3.8rem);
            font-weight: 800;
            line-height: 1.10;
            color: var(--espresso);
            margin-bottom: 20px;
            letter-spacing: -0.5px;
        }

        .hero-heading em {
            font-style: italic;
            color: var(--gold);
        }

        .hero-sub {
            font-size: 1rem;
            font-weight: 400;
            color: var(--brown-soft);
            line-height: 1.75;
            margin-bottom: 36px;
        }

        .hero-btns {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .btn-hero-primary {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 13px 28px;
            border-radius: 10px;
            font-size: 0.92rem;
            font-weight: 600;
            text-decoration: none;
            background: linear-gradient(135deg, var(--gold), var(--gold-mid));
            color: #fff;
            box-shadow: var(--shadow-gold);
            transition: all 0.22s ease;
            border: none;
        }

        .btn-hero-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 36px rgba(168,120,50,0.32);
        }

        .btn-hero-outline {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 0.92rem;
            font-weight: 600;
            text-decoration: none;
            border: 1.5px solid rgba(168,120,50,0.40);
            color: var(--charcoal);
            background: rgba(255,252,248,0.70);
            transition: all 0.22s ease;
        }

        .btn-hero-outline:hover {
            border-color: var(--gold);
            color: var(--gold);
            background: var(--gold-pale);
        }

        /* ━━━━━━━━━━━━━━ STATS ━━━━━━━━━━━━━━ */
        .stats-bar {
            position: relative;
            z-index: 3;
            width: min(95%, 1360px);
            margin: -38px auto 0;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid var(--border);
            box-shadow: 0 8px 32px rgba(28,18,8,0.10);
            background: #fff;
        }

        .stat-item {
            padding: 30px 32px;
            text-align: center;
            border-right: 1px solid var(--border);
            background: #fff;
            transition: background 0.2s ease;
        }

        .stat-item:last-child { border-right: none; }
        .stat-item:hover { background: var(--gold-pale); }

        .stat-num {
            font-family: 'Playfair Display', serif;
            font-size: 2.4rem;
            font-weight: 800;
            color: var(--gold);
            line-height: 1;
            margin-bottom: 6px;
        }

        .stat-label {
            font-size: 0.77rem;
            font-weight: 600;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 1.2px;
        }

        /* ━━━━━━━━━━━━━━ FEATURES ━━━━━━━━━━━━━━ */
        .features-section {
            padding: 110px 0 80px;
        }

        .container {
            width: min(95%, 1360px);
            margin: 0 auto;
        }

        .sec-label {
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            color: var(--gold);
            display: block;
            margin-bottom: 12px;
        }

        .sec-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.9rem, 3.5vw, 2.9rem);
            font-weight: 700;
            color: var(--espresso);
            line-height: 1.15;
            margin-bottom: 14px;
            letter-spacing: -0.3px;
        }

        .sec-title em {
            font-style: italic;
            color: var(--gold);
        }

        .sec-sub {
            font-size: 0.975rem;
            color: var(--muted);
            line-height: 1.72;
            max-width: 480px;
        }

        .section-header { margin-bottom: 52px; }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 22px;
        }

        .feat-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 34px 28px;
            position: relative;
            overflow: hidden;
            transition: transform 0.24s ease, box-shadow 0.24s ease, border-color 0.24s ease;
        }

        .feat-card::after {
            content: '';
            position: absolute;
            bottom: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--gold), var(--gold-mid));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.28s ease;
        }

        .feat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 16px 44px rgba(28,18,8,0.10), 0 4px 12px rgba(168,120,50,0.12);
            border-color: rgba(168,120,50,0.28);
        }

        .feat-card:hover::after { transform: scaleX(1); }

        .feat-icon {
            width: 50px; height: 50px;
            border-radius: 12px;
            background: var(--gold-pale);
            border: 1px solid rgba(168,120,50,0.20);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            margin-bottom: 20px;
            color: var(--gold);
        }

        .feat-card h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.18rem;
            font-weight: 700;
            color: var(--espresso);
            margin-bottom: 10px;
        }

        .feat-card p {
            font-size: 0.875rem;
            color: var(--muted);
            line-height: 1.72;
        }

        /* ━━━━━━━━━━━━━━ CTA ━━━━━━━━━━━━━━ */
        .cta-section { padding: 0 0 110px; }

        .cta-box {
            border-radius: 22px;
            border: 1px solid rgba(168,120,50,0.18);
            overflow: hidden;
            position: relative;
            background: linear-gradient(115deg, #FFFDF8 0%, #FDF5E4 60%, #F5E8CC 100%);
            box-shadow: 0 8px 40px rgba(168,120,50,0.12), 0 2px 8px rgba(28,18,8,0.06);
        }

        /* Subtle image texture on right side */
        .cta-box::before {
            content: '';
            position: absolute;
            top: 0; right: 0;
            width: 52%;
            height: 100%;
            background-image: url("https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?auto=format&fit=crop&w=900&q=80");
            background-size: cover;
            background-position: center;
            opacity: 0.14;
            border-radius: 0 22px 22px 0;
        }

        /* Gold top accent line */
        .cta-box::after {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--gold), var(--gold-mid), transparent);
        }

        .cta-inner {
            position: relative;
            z-index: 1;
            padding: 72px 64px;
            max-width: 620px;
        }

        .cta-inner h2 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.8rem, 3vw, 2.6rem);
            font-weight: 800;
            color: var(--espresso);
            line-height: 1.18;
            margin-bottom: 16px;
            letter-spacing: -0.3px;
        }

        .cta-inner h2 em { font-style: italic; color: var(--gold); }

        .cta-inner p {
            font-size: 0.975rem;
            color: var(--brown-soft);
            line-height: 1.72;
            margin-bottom: 36px;
        }

        .btn-cta {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 32px;
            border-radius: 10px;
            font-size: 0.92rem;
            font-weight: 600;
            text-decoration: none;
            background: linear-gradient(135deg, var(--gold), var(--gold-mid));
            color: #fff;
            box-shadow: var(--shadow-gold);
            transition: all 0.22s ease;
        }

        .btn-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 36px rgba(168,120,50,0.32);
        }

        /* ━━━━━━━━━━━━━━ FOOTER ━━━━━━━━━━━━━━ */
        .footer {
            background: #F5EFE4;
            border-top: 1px solid rgba(168,120,50,0.18);
        }

        .footer-main {
            width: min(95%, 1360px);
            margin: 0 auto;
            padding: 72px 0 56px;
            display: grid;
            grid-template-columns: 1.8fr 1fr 1fr 1fr;
            gap: 52px;
        }

        .footer-brand-name {
            font-family: 'Playfair Display', serif;
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--espresso);
            letter-spacing: 1.5px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .f-mark {
            width: 28px; height: 28px;
            background: linear-gradient(135deg, var(--gold), var(--gold-mid));
            border-radius: 7px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 0.75rem;
        }

        .footer-desc {
            font-size: 0.875rem;
            color: var(--muted);
            line-height: 1.78;
            max-width: 270px;
        }

        .footer-col h4 {
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: var(--gold);
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
            color: var(--brown-soft);
            text-decoration: none;
            transition: color 0.17s ease;
        }

        .footer-col ul li a:hover { color: var(--gold); }

        .footer-bottom {
            border-top: 1px solid rgba(168,120,50,0.14);
        }

        .footer-bottom-inner {
            width: min(95%, 1360px);
            margin: 0 auto;
            padding: 22px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.8rem;
            color: var(--muted);
        }

        /* ━━━━━━━━━━━━━━ RESPONSIVE ━━━━━━━━━━━━━━ */
        @media (max-width: 1100px) {
            .features-grid { grid-template-columns: repeat(2, 1fr); }
            .footer-main { grid-template-columns: 1fr 1fr; gap: 36px; }
        }

        @media (max-width: 768px) {
            .navbar-inner { height: auto; padding: 14px 0; flex-direction: column; align-items: stretch; }
            .brand { justify-content: center; }
            .nav-links { justify-content: center; }

            .hero { min-height: auto; }
            .hero-panel { padding: 36px 0 110px; }
            .hero-card { padding: 32px 22px; max-width: 100%; }
            .hero-heading { font-size: 2.1rem; }
            .hero-btns { flex-direction: column; }
            .btn-hero-primary, .btn-hero-outline { justify-content: center; }

            .stats-bar { margin-top: -20px; }
            .stats-grid { grid-template-columns: 1fr; border-radius: 12px; }
            .stat-item { border-right: none; border-bottom: 1px solid var(--border); }
            .stat-item:last-child { border-bottom: none; }

            .features-section { padding: 72px 0 56px; }
            .features-grid { grid-template-columns: 1fr; }

            .cta-inner { padding: 44px 24px; }
            .cta-box::before { width: 100%; opacity: 0.07; border-radius: 22px; }

            .footer-main { grid-template-columns: 1fr; gap: 32px; padding: 48px 0 36px; }
            .footer-bottom-inner { flex-direction: column; gap: 6px; text-align: center; }
        }
    </style>
</head>
<body>

<!-- ════════════════════ NAVBAR ════════════════════ -->
<nav class="navbar">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="brand">
            <span class="brand-mark"><i class="fa-regular fa-hexagon"></i></span>
            <span class="brand-name">EVENTHORIZON</span>
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
                        <a href="${pageContext.request.contextPath}/user?action=logout" class="nav-btn nav-btn-gold">
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
                        <a href="${pageContext.request.contextPath}/user?action=logout" class="nav-btn nav-btn-gold">
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

<!-- ════════════════════ HERO ════════════════════ -->
<section class="hero">
    <div class="hero-img"></div>

    <div class="hero-panel">
        <div class="hero-card">
            <div class="hero-eyebrow">
                <span class="eyebrow-dot"></span>
                <span>Premium Event Booking Platform</span>
            </div>

            <h1 class="hero-heading">
                Experience the<br><em>Extraordinary</em>
            </h1>

            <p class="hero-sub">
                Discover concerts, sports events, tech summits and cultural shows.
                Book your tickets in seconds with a seamless and secure experience.
            </p>

            <div class="hero-btns">
                <a href="${pageContext.request.contextPath}/event?action=list" class="btn-hero-primary">
                    <i class="fa-solid fa-ticket"></i> Browse Events
                </a>
                <c:if test="${empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn-hero-outline">
                        <i class="fa-solid fa-user-plus"></i> Create Account
                    </a>
                </c:if>
                <c:if test="${not empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/IssueServlet?action=report" class="btn-hero-outline">
                        <i class="fa-regular fa-flag"></i> Report an Issue
                    </a>
                </c:if>
            </div>
        </div>
    </div>
</section>

<!-- ════════════════════ STATS ════════════════════ -->
<div class="stats-bar">
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

<!-- ════════════════════ FEATURES ════════════════════ -->
<section class="features-section">
    <div class="container">
        <div class="section-header">
            <span class="sec-label">Why choose us</span>
            <h2 class="sec-title">Why <em>EventHorizon?</em></h2>
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

<!-- ════════════════════ CTA ════════════════════ -->
<section class="cta-section">
    <div class="container">
        <div class="cta-box">
            <div class="cta-inner">
                <span class="sec-label">Don't miss out</span>
                <h2>Ready to book your <em>next experience?</em></h2>
                <p>Explore trending events and reserve your seat before they sell out.</p>
                <a href="${pageContext.request.contextPath}/event?action=list" class="btn-cta">
                    <i class="fa-solid fa-arrow-right"></i> Explore Events
                </a>
            </div>
        </div>
    </div>
</section>

<!-- ════════════════════ FOOTER ════════════════════ -->
<footer class="footer">
    <div class="footer-main">
        <div>
            <div class="footer-brand-name">
                <span class="f-mark"><i class="fa-regular fa-hexagon"></i></span>
                EVENTHORIZON
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
