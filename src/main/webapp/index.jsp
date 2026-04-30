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
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,600;1,700&family=DM+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        :root {
            --ivory: #FEFAF3;
            --cream: #F7EEDB;
            --cream-strong: #FFF7E8;
            --tan: #E1CFAD;

            --gold: #A86F08;
            --gold-main: #C4922A;
            --gold-light: #DDB555;
            --gold-pale: #FFF0C9;

            --espresso: #130C04;
            --brown: #2A1A08;
            --brown-soft: #4E3514;
            --mocha: #63451D;

            --text: #1B1207;
            --text-muted: #604928;
            --white: #FFFFFF;

            --shadow-gold: rgba(168, 111, 8, 0.22);
            --shadow-soft: rgba(30, 15, 5, 0.12);
            --shadow-strong: rgba(30, 15, 5, 0.22);
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--ivory);
            color: var(--text);
            -webkit-font-smoothing: antialiased;
            overflow-x: hidden;
        }

        a {
            text-decoration: none;
        }

        .container {
            width: min(94%, 1300px);
            margin: 0 auto;
        }

        /* ── NAVBAR ─────────────────────────────────── */

        .eh-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: rgba(254, 250, 243, 0.96);
            border-bottom: 1px solid rgba(168,111,8,0.22);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            box-shadow: 0 10px 28px rgba(30,15,5,0.06);
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
            color: var(--espresso);
            font-family: 'Cormorant Garamond', serif;
            font-weight: 700;
            font-size: 1.58rem;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .eh-brand-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            border-radius: 9px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 0.9rem;
            box-shadow: 0 8px 18px var(--shadow-gold);
        }

        .eh-nav-links {
            list-style: none;
            display: flex;
            align-items: center;
            gap: 6px;
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
            gap: 7px;
            min-height: 40px;
            padding: 9px 15px;
            border-radius: 10px;
            font-size: 0.88rem;
            font-weight: 800;
            font-family: 'DM Sans', sans-serif;
            transition: all 0.22s ease;
            border: 1px solid transparent;
            letter-spacing: 0.1px;
            white-space: nowrap;
        }

        .eh-nav-link {
            color: var(--brown);
        }

        .eh-nav-link:hover {
            color: var(--gold);
            background: var(--gold-pale);
        }

        .eh-nav-link.active {
            color: var(--gold);
            background: var(--gold-pale);
            border-color: rgba(168,111,8,0.30);
            box-shadow: 0 8px 20px rgba(168,111,8,0.10);
        }

        .eh-nav-bell {
            position: relative;
            color: var(--brown);
            width: 42px;
            padding: 0;
            background: var(--cream);
            border-color: var(--tan);
        }

        .eh-nav-bell:hover {
            color: var(--gold);
            border-color: rgba(168,111,8,0.42);
            background: var(--gold-pale);
        }

        .eh-bell-badge {
            position: absolute;
            top: -6px;
            right: -6px;
            min-width: 18px;
            height: 18px;
            padding: 0 5px;
            border-radius: 999px;
            background: linear-gradient(135deg, #D94321, #F07848);
            color: #fff;
            font-size: 0.65rem;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 6px 14px rgba(217,67,33,0.35);
        }

        .eh-nav-btn {
            color: #fff;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            box-shadow: 0 10px 22px var(--shadow-gold);
        }

        .eh-nav-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 14px 30px var(--shadow-gold);
        }

        .eh-nav-btn-outline {
            color: var(--gold);
            border-color: rgba(168,111,8,0.48);
            background: rgba(255,255,255,0.66);
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
            isolation: isolate;
            background: var(--ivory);
        }

        .hero-bg {
            position: absolute;
            inset: 0;
            z-index: -4;
            background-image: url("https://static.standard.co.uk/2023/09/16/20/f045d1418c2861ccadddc79f143d0086Y29udGVudHNlYXJjaGFwaSwxNjk0OTc3MzM2-2.73750182.jpg?crop=8:5,smart&quality=75&auto=webp&width=1000");
            background-size: cover;
            background-position: center 35%;
            background-repeat: no-repeat;
            transform: scale(1.02);
            filter: brightness(0.88) contrast(1.12) saturate(1.08);
            animation: heroZoom 18s ease-in-out infinite alternate;
        }

        @keyframes heroZoom {
            from {
                transform: scale(1.02);
            }

            to {
                transform: scale(1.0);
            }
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            z-index: -3;
            background:
                linear-gradient(
                    90deg,
                    rgba(254,250,243,0.98) 0%,
                    rgba(254,250,243,0.94) 31%,
                    rgba(254,250,243,0.55) 52%,
                    rgba(254,250,243,0.10) 73%,
                    rgba(19,12,4,0.28) 100%
                ),
                linear-gradient(
                    180deg,
                    rgba(19,12,4,0.02) 0%,
                    rgba(19,12,4,0.18) 100%
                );
        }

        .hero::after {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
            height: 150px;
            z-index: -2;
            background: linear-gradient(180deg, transparent, var(--ivory));
        }

        .hero-content {
            position: relative;
            z-index: 2;
            width: min(94%, 1400px);
            margin: 0 auto;
            padding: 84px 0 128px;
            display: flex;
            align-items: center;
        }

        .hero-readable-panel {
            max-width: 700px;
            padding: 44px 48px 48px;
            border-radius: 28px;
            background:
                linear-gradient(135deg, rgba(255,255,255,0.96), rgba(255,247,232,0.92));
            border: 1px solid rgba(168,111,8,0.26);
            box-shadow:
                0 30px 90px var(--shadow-strong),
                inset 0 1px 0 rgba(255,255,255,0.95);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }

        .hero-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: var(--gold-pale);
            border: 1px solid rgba(168,111,8,0.34);
            border-radius: 100px;
            padding: 7px 17px 7px 10px;
            margin-bottom: 28px;
            box-shadow: 0 10px 22px rgba(168,111,8,0.10);
            animation: fadeUp 0.7s ease both;
        }

        .hero-eyebrow-dot {
            width: 9px;
            height: 9px;
            border-radius: 50%;
            background: var(--gold);
            box-shadow: 0 0 0 4px rgba(168,111,8,0.18);
            animation: pulse 2s ease infinite;
        }

        @keyframes pulse {
            0%, 100% {
                box-shadow: 0 0 0 4px rgba(168,111,8,0.18);
            }

            50% {
                box-shadow: 0 0 0 7px rgba(168,111,8,0.08);
            }
        }

        .hero-eyebrow span {
            font-size: 0.78rem;
            font-weight: 800;
            color: var(--gold);
            letter-spacing: 1.25px;
            text-transform: uppercase;
        }

        .hero-title {
            font-family: 'Cormorant Garamond', serif !important;
            font-size: clamp(3.6rem, 7vw, 6.4rem) !important;
            font-weight: 700 !important;
            line-height: 0.98 !important;
            color: var(--espresso) !important;
            margin-bottom: 26px !important;
            letter-spacing: -1.6px !important;
            animation: fadeUp 0.7s 0.1s ease both;
            text-shadow: none !important;
        }

        .hero-title em {
            font-style: italic !important;
            color: var(--gold) !important;
            text-shadow: none !important;
        }

        .hero-subtitle {
            font-size: 1.08rem !important;
            font-weight: 700 !important;
            color: var(--brown-soft) !important;
            line-height: 1.75 !important;
            max-width: 570px;
            margin-bottom: 40px !important;
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
            from {
                opacity: 0;
                transform: translateY(22px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .btn-gold {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            min-height: 52px;
            padding: 14px 30px;
            border-radius: 12px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.93rem;
            font-weight: 800;
            letter-spacing: 0.2px;
            transition: all 0.22s ease;
            cursor: pointer;
        }

        .btn-gold-solid {
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            color: #fff;
            box-shadow: 0 14px 30px var(--shadow-gold), 0 2px 6px rgba(0,0,0,0.10);
        }

        .btn-gold-solid:hover {
            transform: translateY(-2px);
            box-shadow: 0 18px 40px var(--shadow-gold);
        }

        .btn-gold-outline {
            border: 1.5px solid rgba(168,111,8,0.50);
            color: var(--brown);
            background: rgba(255,255,255,0.88);
            box-shadow: 0 10px 24px rgba(30,15,5,0.06);
        }

        .btn-gold-outline:hover {
            border-color: var(--gold);
            color: var(--gold);
            background: var(--gold-pale);
            transform: translateY(-2px);
        }

        /* hero stats strip */

        .hero-stats {
            position: relative;
            z-index: 5;
            width: min(94%, 1400px);
            margin: -68px auto 0;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1px;
            background: rgba(168,111,8,0.20);
            border: 1px solid rgba(168,111,8,0.18);
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 24px 64px var(--shadow-soft);
        }

        .hero-stat {
            background: rgba(255,255,255,0.98);
            padding: 30px 32px;
            text-align: center;
            animation: fadeUp 0.7s 0.4s ease both;
        }

        .hero-stat-num {
            font-family: 'Cormorant Garamond', serif;
            font-size: 2.7rem;
            font-weight: 700;
            color: var(--gold);
            line-height: 1;
            margin-bottom: 8px;
        }

        .hero-stat-label {
            font-size: 0.78rem;
            font-weight: 800;
            color: var(--brown-soft);
            text-transform: uppercase;
            letter-spacing: 1.2px;
        }

        /* ── FEATURES ────────────────────────────────── */

        .features-section {
            padding: 124px 0 84px;
            background:
                radial-gradient(circle at top left, rgba(168,111,8,0.07), transparent 28%),
                linear-gradient(180deg, var(--ivory), var(--cream-strong));
        }

        .section-header {
            text-align: center;
            margin-bottom: 64px;
        }

        .section-label {
            display: inline-block;
            font-size: 0.74rem;
            font-weight: 800;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 14px;
        }

        .section-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(2.4rem, 4vw, 3.6rem);
            font-weight: 700;
            color: var(--espresso);
            line-height: 1.1;
            margin-bottom: 16px;
            letter-spacing: -0.7px;
        }

        .section-title em {
            font-style: italic;
            color: var(--gold);
        }

        .section-subtitle {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-muted);
            max-width: 520px;
            margin: 0 auto;
            line-height: 1.7;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 22px;
        }

        .feature-card {
            background: rgba(255,255,255,0.98);
            border: 1px solid rgba(168,111,8,0.18);
            border-radius: 18px;
            padding: 36px 28px;
            position: relative;
            overflow: hidden;
            transition: all 0.28s ease;
            cursor: default;
            box-shadow: 0 14px 36px rgba(30,15,5,0.06);
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--gold), var(--gold-light));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.32s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 24px 58px var(--shadow-soft), 0 4px 12px var(--shadow-gold);
            border-color: rgba(168,111,8,0.28);
        }

        .feature-card:hover::before {
            transform: scaleX(1);
        }

        .feature-icon-wrap {
            width: 54px;
            height: 54px;
            border-radius: 15px;
            background: linear-gradient(135deg, var(--gold-pale), var(--cream));
            border: 1px solid rgba(168,111,8,0.22);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 22px;
            font-size: 1.45rem;
        }

        .feature-card h3 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--espresso);
            margin-bottom: 10px;
            letter-spacing: -0.2px;
        }

        .feature-card p {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-muted);
            line-height: 1.7;
        }

        /* ── CTA BAND ─────────────────────────────────── */

        .home-cta {
            padding: 0 0 120px;
            background: var(--cream-strong);
        }

        .cta-box {
            position: relative;
            border-radius: 26px;
            overflow: hidden;
            padding: 84px 60px;
            text-align: center;
            background: var(--espresso);
            box-shadow: 0 34px 86px rgba(19,12,4,0.28);
        }

        .cta-box::before {
            content: '';
            position: absolute;
            inset: 0;
            background-image: url("https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=1200&q=90");
            background-size: cover;
            background-position: center;
            opacity: 0.22;
            filter: brightness(0.72) contrast(1.12) saturate(1.08);
        }

        .cta-box::after {
            content: "";
            position: absolute;
            inset: 0;
            background:
                linear-gradient(135deg, rgba(19,12,4,0.90), rgba(42,26,8,0.86)),
                radial-gradient(circle at top, rgba(221,181,85,0.20), transparent 34%);
        }

        .cta-box-inner {
            position: relative;
            z-index: 2;
        }

        .cta-label {
            display: inline-block;
            font-size: 0.74rem;
            font-weight: 800;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            color: var(--gold-light);
            margin-bottom: 18px;
        }

        .cta-box h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(2.2rem, 4vw, 3.2rem);
            font-weight: 700;
            color: #fff;
            margin-bottom: 16px;
            line-height: 1.12;
            letter-spacing: -0.5px;
        }

        .cta-box h2 em {
            font-style: italic;
            color: var(--gold-light);
        }

        .cta-box p {
            color: rgba(255,255,255,0.82);
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 36px;
            line-height: 1.7;
        }

        .btn-gold-cta {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-height: 52px;
            padding: 15px 36px;
            border-radius: 12px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.93rem;
            font-weight: 800;
            letter-spacing: 0.2px;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            color: #fff;
            box-shadow: 0 14px 34px rgba(168,111,8,0.40);
            transition: all 0.22s ease;
        }

        .btn-gold-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 18px 44px rgba(168,111,8,0.48);
        }

        /* ── FOOTER ──────────────────────────────────── */

        .footer {
            background: var(--espresso);
            color: rgba(255,255,255,0.82);
        }

        .footer-container {
            display: grid;
            grid-template-columns: 1.6fr 1fr 1fr 1fr;
            gap: 48px;
            padding: 72px 0 60px;
        }

        .footer-logo {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.55rem;
            font-weight: 700;
            letter-spacing: 2px;
            color: var(--white);
            margin-bottom: 18px;
        }

        .footer-logo span {
            color: var(--gold-light);
        }

        .footer-text {
            font-size: 0.9rem;
            font-weight: 500;
            line-height: 1.75;
            color: rgba(255,255,255,0.68);
            max-width: 300px;
        }

        .footer-col h4 {
            font-family: 'DM Sans', sans-serif;
            font-size: 0.74rem;
            font-weight: 800;
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
            font-size: 0.9rem;
            font-weight: 600;
            color: rgba(255,255,255,0.66);
            transition: color 0.18s ease;
        }

        .footer-col ul li a:hover {
            color: var(--gold-light);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255,255,255,0.10);
        }

        .footer-bottom-inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 22px 0;
            font-size: 0.82rem;
            font-weight: 600;
            color: rgba(255,255,255,0.52);
        }

        /* ── RESPONSIVE ──────────────────────────────── */

        @media (max-width: 1024px) {
            .features-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .footer-container {
                grid-template-columns: 1fr 1fr;
                gap: 36px;
            }

            .hero-stats {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 768px) {
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
                padding: 56px 0 140px;
            }

            .hero-readable-panel {
                padding: 34px 24px 38px;
                border-radius: 22px;
            }

            .hero-title {
                font-size: clamp(3.1rem, 13vw, 4.6rem) !important;
                letter-spacing: -1px !important;
            }

            .hero-subtitle {
                font-size: 1rem !important;
            }

            .hero-stats {
                grid-template-columns: 1fr;
                margin-top: -34px;
            }

            .features-section {
                padding-top: 104px;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }

            .footer-container {
                grid-template-columns: 1fr;
                gap: 28px;
                padding: 48px 0 36px;
            }

            .cta-box {
                padding: 56px 24px;
            }

            .footer-bottom-inner {
                flex-direction: column;
                gap: 8px;
                text-align: center;
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
                width: 40px;
                padding: 0;
            }

            .hero-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .btn-gold {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<nav class="eh-navbar">
    <div class="eh-navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="eh-brand">
            <span class="eh-brand-icon"><i class="fa-solid fa-diamond"></i></span>
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
    <div class="hero-bg"></div>
    <div class="hero-overlay"></div>

    <div class="hero-content">
        <div class="hero-readable-panel">
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
    </div>
</section>

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

<section class="features-section">
    <div class="container">
        <div class="section-header">
            <span class="section-label">Why choose us</span>
            <h2 class="section-title">Why <em>EventHorizon?</em></h2>
            <p class="section-subtitle">
                Built for speed, security, and unforgettable experiences.
            </p>
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