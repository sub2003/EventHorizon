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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Playfair+Display:ital,wght@0,600;0,700;0,800;1,700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        :root {
            --ivory: #fbf7ef;
            --cream: #f3ead7;
            --cream-2: #fffaf1;
            --gold: #bf8c24;
            --gold-light: #d9ad52;
            --gold-soft: #f3dfad;
            --gold-pale: #fbf0d1;
            --espresso: #171008;
            --brown: #362512;
            --brown-soft: #6f5838;
            --muted: #7c6b55;
            --white: #ffffff;
            --border: rgba(191, 140, 36, 0.24);
            --dark-border: rgba(23, 16, 8, 0.10);
            --shadow-soft: 0 20px 60px rgba(34, 20, 5, 0.10);
            --shadow-strong: 0 30px 90px rgba(34, 20, 5, 0.18);
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--ivory);
            color: var(--espresso);
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        a {
            text-decoration: none;
        }

        .container {
            width: min(92%, 1240px);
            margin: 0 auto;
        }

        /* NAVBAR */

        .eh-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: rgba(255, 250, 241, 0.94);
            border-bottom: 1px solid rgba(191, 140, 36, 0.18);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            box-shadow: 0 10px 32px rgba(23, 16, 8, 0.05);
        }

        .eh-navbar-inner {
            width: min(92%, 1240px);
            margin: 0 auto;
            min-height: 72px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .eh-brand {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            color: var(--espresso);
            font-weight: 900;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .eh-brand-icon {
            width: 38px;
            height: 38px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            color: #fff;
            box-shadow: 0 12px 28px rgba(191, 140, 36, 0.24);
        }

        .eh-brand span:last-child {
            font-size: 1.08rem;
        }

        .eh-nav-links {
            list-style: none;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 7px;
            flex-wrap: wrap;
        }

        .eh-nav-link,
        .eh-nav-bell,
        .eh-nav-btn,
        .eh-nav-btn-outline {
            min-height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 9px 15px;
            border-radius: 10px;
            border: 1px solid transparent;
            font-size: 0.86rem;
            font-weight: 700;
            transition: 0.22s ease;
            white-space: nowrap;
        }

        .eh-nav-link {
            color: var(--brown);
        }

        .eh-nav-link:hover,
        .eh-nav-link.active {
            color: var(--gold);
            background: var(--gold-pale);
            border-color: rgba(191, 140, 36, 0.26);
        }

        .eh-nav-bell {
            position: relative;
            width: 42px;
            padding: 0;
            color: var(--brown);
            background: rgba(255, 255, 255, 0.62);
            border-color: rgba(191, 140, 36, 0.22);
        }

        .eh-nav-bell:hover {
            color: var(--gold);
            background: var(--gold-pale);
            border-color: rgba(191, 140, 36, 0.42);
        }

        .eh-bell-badge {
            position: absolute;
            top: -6px;
            right: -6px;
            min-width: 18px;
            height: 18px;
            padding: 0 5px;
            border-radius: 999px;
            background: linear-gradient(135deg, #e05235, #f1844d);
            color: #fff;
            font-size: 0.64rem;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 16px rgba(224, 82, 53, 0.26);
        }

        .eh-nav-btn {
            color: #fff;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            box-shadow: 0 12px 28px rgba(191, 140, 36, 0.22);
        }

        .eh-nav-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 16px 36px rgba(191, 140, 36, 0.28);
        }

        .eh-nav-btn-outline {
            color: var(--gold);
            background: rgba(255, 255, 255, 0.48);
            border-color: rgba(191, 140, 36, 0.42);
        }

        .eh-nav-btn-outline:hover {
            background: var(--gold-pale);
            border-color: var(--gold);
        }

        /* HERO */

        .hero {
            position: relative;
            min-height: calc(100vh - 72px);
            overflow: hidden;
            display: flex;
            align-items: center;
            isolation: isolate;
            background: var(--ivory);
        }

        .hero-bg {
            position: absolute;
            inset: 0;
            z-index: -4;
            background-image: url("https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?auto=format&fit=crop&w=1920&q=95");
            background-size: cover;
            background-position: center 38%;
            transform: scale(1.015);
            filter: contrast(1.10) saturate(1.08) brightness(0.92);
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            z-index: -3;
            background:
                linear-gradient(
                    90deg,
                    rgba(251, 247, 239, 0.98) 0%,
                    rgba(251, 247, 239, 0.94) 24%,
                    rgba(251, 247, 239, 0.66) 47%,
                    rgba(251, 247, 239, 0.14) 72%,
                    rgba(23, 16, 8, 0.18) 100%
                ),
                linear-gradient(
                    180deg,
                    rgba(23, 16, 8, 0.02) 0%,
                    rgba(23, 16, 8, 0.16) 100%
                );
        }

        .hero::after {
            content: "";
            position: absolute;
            inset: auto 0 0 0;
            height: 170px;
            z-index: -2;
            background: linear-gradient(180deg, transparent, var(--ivory));
        }

        .hero-inner {
            width: min(92%, 1240px);
            margin: 0 auto;
            padding: 78px 0 132px;
            display: grid;
            grid-template-columns: minmax(0, 0.96fr) minmax(360px, 0.72fr);
            align-items: center;
            gap: 44px;
        }

        .hero-panel {
            max-width: 680px;
            padding: 42px 44px;
            border-radius: 28px;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.86), rgba(255, 250, 241, 0.78));
            border: 1px solid rgba(191, 140, 36, 0.24);
            box-shadow: var(--shadow-strong);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }

        .hero-eyebrow {
            width: fit-content;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 8px 16px 8px 10px;
            margin-bottom: 24px;
            border-radius: 999px;
            background: rgba(251, 240, 209, 0.92);
            border: 1px solid rgba(191, 140, 36, 0.32);
            color: var(--gold);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            box-shadow: 0 12px 28px rgba(191, 140, 36, 0.10);
        }

        .hero-eyebrow-dot {
            width: 9px;
            height: 9px;
            border-radius: 999px;
            background: var(--gold);
            box-shadow: 0 0 0 4px rgba(191, 140, 36, 0.18);
        }

        .hero-title {
            font-family: 'Playfair Display', serif !important;
            font-size: clamp(3.3rem, 6.2vw, 6.3rem) !important;
            line-height: 0.98 !important;
            letter-spacing: -2.8px !important;
            font-weight: 800 !important;
            color: #120c05 !important;
            margin: 0 0 24px !important;
            text-shadow: none !important;
        }

        .hero-title em {
            display: inline-block;
            font-style: italic !important;
            color: var(--gold) !important;
            text-shadow: 0 8px 28px rgba(191, 140, 36, 0.18);
        }

        .hero-subtitle {
            max-width: 570px;
            margin: 0 0 34px !important;
            color: #4c3920 !important;
            font-size: 1.06rem !important;
            font-weight: 600 !important;
            line-height: 1.78 !important;
        }

        .hero-actions {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 14px;
        }

        .btn-gold {
            min-height: 52px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 14px 26px;
            border-radius: 12px;
            font-size: 0.92rem;
            font-weight: 800;
            transition: 0.24s ease;
        }

        .btn-gold-solid {
            color: #fff;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            box-shadow: 0 16px 36px rgba(191, 140, 36, 0.28);
        }

        .btn-gold-solid:hover {
            transform: translateY(-2px);
            box-shadow: 0 22px 46px rgba(191, 140, 36, 0.36);
        }

        .btn-gold-outline {
            color: var(--brown);
            background: rgba(255, 255, 255, 0.72);
            border: 1.5px solid rgba(191, 140, 36, 0.42);
            box-shadow: 0 10px 26px rgba(34, 20, 5, 0.06);
        }

        .btn-gold-outline:hover {
            color: var(--gold);
            background: var(--gold-pale);
            transform: translateY(-2px);
        }

        .hero-side-card {
            align-self: end;
            justify-self: end;
            width: min(100%, 420px);
            border-radius: 26px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.84);
            border: 1px solid rgba(255, 255, 255, 0.62);
            box-shadow: 0 34px 90px rgba(23, 16, 8, 0.24);
            backdrop-filter: blur(12px);
        }

        .hero-side-image {
            height: 250px;
            background-image:
                linear-gradient(180deg, rgba(23,16,8,0.02), rgba(23,16,8,0.44)),
                url("https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=900&q=90");
            background-size: cover;
            background-position: center;
        }

        .hero-side-body {
            padding: 24px;
        }

        .hero-side-tag {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            margin-bottom: 14px;
            padding: 7px 11px;
            border-radius: 999px;
            background: var(--gold-pale);
            color: var(--gold);
            font-size: 0.72rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .hero-side-body h3 {
            margin: 0 0 9px;
            color: var(--espresso);
            font-size: 1.15rem;
            font-weight: 900;
            letter-spacing: -0.4px;
        }

        .hero-side-body p {
            color: var(--muted);
            font-size: 0.9rem;
            font-weight: 600;
            line-height: 1.65;
        }

        /* STATS */

        .hero-stats {
            position: relative;
            z-index: 4;
            width: min(92%, 1240px);
            margin: -82px auto 0;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            overflow: hidden;
            border-radius: 20px;
            background: rgba(191, 140, 36, 0.20);
            border: 1px solid rgba(191, 140, 36, 0.20);
            box-shadow: var(--shadow-soft);
        }

        .hero-stat {
            background: rgba(255, 255, 255, 0.96);
            padding: 30px 28px;
            text-align: center;
            border-right: 1px solid rgba(191, 140, 36, 0.18);
        }

        .hero-stat:last-child {
            border-right: none;
        }

        .hero-stat-num {
            font-family: 'Playfair Display', serif;
            color: var(--gold);
            font-size: 2.45rem;
            line-height: 1;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .hero-stat-label {
            color: var(--muted);
            font-size: 0.76rem;
            font-weight: 900;
            letter-spacing: 1.4px;
            text-transform: uppercase;
        }

        /* FEATURES */

        .features-section {
            padding: 126px 0 86px;
            background:
                radial-gradient(circle at top left, rgba(191, 140, 36, 0.08), transparent 30%),
                linear-gradient(180deg, var(--ivory), var(--cream-2));
        }

        .section-header {
            max-width: 720px;
            margin: 0 auto 58px;
            text-align: center;
        }

        .section-label {
            display: inline-block;
            margin-bottom: 14px;
            color: var(--gold);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2.2px;
            text-transform: uppercase;
        }

        .section-title {
            font-family: 'Playfair Display', serif;
            color: var(--espresso);
            font-size: clamp(2.3rem, 4vw, 3.6rem);
            font-weight: 800;
            line-height: 1.08;
            letter-spacing: -1.4px;
            margin-bottom: 16px;
        }

        .section-title em {
            color: var(--gold);
            font-style: italic;
        }

        .section-subtitle {
            color: var(--muted);
            font-size: 1rem;
            font-weight: 600;
            line-height: 1.75;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 22px;
        }

        .feature-card {
            position: relative;
            min-height: 230px;
            padding: 34px 28px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.94);
            border: 1px solid rgba(191, 140, 36, 0.18);
            box-shadow: 0 14px 38px rgba(34, 20, 5, 0.06);
            transition: 0.28s ease;
            overflow: hidden;
        }

        .feature-card::before {
            content: "";
            position: absolute;
            inset: 0 0 auto 0;
            height: 4px;
            background: linear-gradient(90deg, var(--gold), var(--gold-light));
            transform: scaleX(0);
            transform-origin: left;
            transition: 0.28s ease;
        }

        .feature-card:hover {
            transform: translateY(-6px);
            border-color: rgba(191, 140, 36, 0.34);
            box-shadow: 0 24px 60px rgba(34, 20, 5, 0.11);
        }

        .feature-card:hover::before {
            transform: scaleX(1);
        }

        .feature-icon-wrap {
            width: 54px;
            height: 54px;
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            background: linear-gradient(135deg, var(--gold-pale), #fff8e8);
            border: 1px solid rgba(191, 140, 36, 0.22);
            font-size: 1.45rem;
        }

        .feature-card h3 {
            margin-bottom: 10px;
            color: var(--espresso);
            font-size: 1.15rem;
            font-weight: 900;
            letter-spacing: -0.4px;
        }

        .feature-card p {
            color: var(--muted);
            font-size: 0.9rem;
            font-weight: 600;
            line-height: 1.7;
        }

        /* CTA */

        .home-cta {
            padding: 0 0 110px;
            background: var(--cream-2);
        }

        .cta-box {
            position: relative;
            overflow: hidden;
            padding: 76px 46px;
            border-radius: 28px;
            text-align: center;
            background:
                linear-gradient(135deg, rgba(23,16,8,0.94), rgba(54,37,18,0.92)),
                url("https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=1300&q=90");
            background-size: cover;
            background-position: center;
            box-shadow: 0 34px 90px rgba(23, 16, 8, 0.22);
        }

        .cta-box::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at top, rgba(217, 173, 82, 0.26), transparent 34%),
                linear-gradient(135deg, rgba(23,16,8,0.78), rgba(54,37,18,0.88));
        }

        .cta-box-inner {
            position: relative;
            z-index: 2;
        }

        .cta-label {
            display: inline-block;
            margin-bottom: 16px;
            color: var(--gold-light);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2.2px;
            text-transform: uppercase;
        }

        .cta-box h2 {
            font-family: 'Playfair Display', serif;
            color: #fff;
            font-size: clamp(2.2rem, 4vw, 3.3rem);
            font-weight: 800;
            line-height: 1.12;
            letter-spacing: -1.2px;
            margin-bottom: 16px;
        }

        .cta-box h2 em {
            color: var(--gold-light);
            font-style: italic;
        }

        .cta-box p {
            max-width: 540px;
            margin: 0 auto 34px;
            color: rgba(255, 255, 255, 0.72);
            font-size: 1rem;
            font-weight: 600;
            line-height: 1.75;
        }

        .btn-gold-cta {
            min-height: 52px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 14px 30px;
            border-radius: 12px;
            color: #fff;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            font-size: 0.92rem;
            font-weight: 900;
            box-shadow: 0 16px 38px rgba(191, 140, 36, 0.34);
            transition: 0.24s ease;
        }

        .btn-gold-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 22px 48px rgba(191, 140, 36, 0.42);
        }

        /* FOOTER */

        .footer {
            background: var(--espresso);
            color: rgba(255, 255, 255, 0.72);
        }

        .footer-container {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr 1fr;
            gap: 48px;
            padding: 70px 0 56px;
        }

        .footer-logo {
            margin-bottom: 18px;
            color: #fff;
            font-size: 1.28rem;
            font-weight: 900;
            letter-spacing: 2px;
        }

        .footer-logo span {
            color: var(--gold-light);
        }

        .footer-text {
            max-width: 310px;
            color: rgba(255, 255, 255, 0.52);
            font-size: 0.88rem;
            font-weight: 500;
            line-height: 1.8;
        }

        .footer-col h4 {
            margin-bottom: 20px;
            color: var(--gold-light);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .footer-col ul {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 11px;
        }

        .footer-col ul li a {
            color: rgba(255, 255, 255, 0.54);
            font-size: 0.88rem;
            font-weight: 600;
            transition: 0.2s ease;
        }

        .footer-col ul li a:hover {
            color: var(--gold-light);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.08);
        }

        .footer-bottom-inner {
            min-height: 62px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            color: rgba(255, 255, 255, 0.34);
            font-size: 0.82rem;
            font-weight: 600;
        }

        /* RESPONSIVE */

        @media (max-width: 1100px) {
            .hero-inner {
                grid-template-columns: 1fr;
                padding-top: 62px;
            }

            .hero-panel {
                max-width: 760px;
            }

            .hero-side-card {
                display: none;
            }

            .features-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .footer-container {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 768px) {
            .eh-navbar-inner {
                flex-direction: column;
                justify-content: center;
                padding: 14px 0;
            }

            .eh-nav-links {
                justify-content: center;
            }

            .hero {
                min-height: auto;
            }

            .hero-inner {
                padding: 46px 0 116px;
            }

            .hero-panel {
                padding: 32px 24px;
                border-radius: 22px;
            }

            .hero-title {
                font-size: clamp(3rem, 13vw, 4.5rem) !important;
                letter-spacing: -1.6px !important;
            }

            .hero-subtitle {
                font-size: 1rem !important;
            }

            .hero-stats {
                grid-template-columns: 1fr;
                margin-top: -54px;
            }

            .hero-stat {
                border-right: none;
                border-bottom: 1px solid rgba(191, 140, 36, 0.18);
            }

            .hero-stat:last-child {
                border-bottom: none;
            }

            .features-section {
                padding-top: 100px;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }

            .footer-container {
                grid-template-columns: 1fr;
                gap: 32px;
            }

            .footer-bottom-inner {
                flex-direction: column;
                justify-content: center;
                text-align: center;
                padding: 18px 0;
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

    <div class="hero-inner">
        <div class="hero-panel">
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

        <div class="hero-side-card">
            <div class="hero-side-image"></div>
            <div class="hero-side-body">
                <div class="hero-side-tag">
                    <i class="fa-solid fa-shield-halved"></i>
                    Secure Booking
                </div>
                <h3>Book events with confidence</h3>
                <p>
                    Manage bookings, view tickets, and access event details through a clean,
                    secure and reliable platform.
                </p>
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