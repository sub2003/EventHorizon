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
            --eh-bg: #f7f9ff;
            --eh-surface: rgba(255, 255, 255, 0.88);
            --eh-surface-solid: #ffffff;
            --eh-text: #111827;
            --eh-muted: #64748b;
            --eh-soft: #eef2ff;
            --eh-primary: #4f46e5;
            --eh-primary-dark: #3730a3;
            --eh-secondary: #06b6d4;
            --eh-gold: #f59e0b;
            --eh-border: rgba(15, 23, 42, 0.10);
            --eh-shadow: 0 24px 70px rgba(15, 23, 42, 0.10);
            --eh-shadow-soft: 0 16px 45px rgba(15, 23, 42, 0.08);
            --eh-radius-xl: 30px;
            --eh-radius-lg: 22px;
            --eh-radius-md: 16px;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            color: var(--eh-text);
            font-family: Inter, Poppins, Arial, sans-serif;
            background:
                radial-gradient(circle at top left, rgba(79, 70, 229, 0.10), transparent 34%),
                radial-gradient(circle at top right, rgba(6, 182, 212, 0.12), transparent 34%),
                linear-gradient(180deg, #ffffff 0%, #f7f9ff 45%, #eef4ff 100%);
            overflow-x: hidden;
        }

        a {
            text-decoration: none;
        }

        .container {
            width: min(92%, 1220px);
            margin: 0 auto;
        }

        .eh-page-shell {
            position: relative;
            min-height: 100vh;
        }

        .eh-page-shell::before {
            content: "";
            position: fixed;
            inset: 0;
            z-index: -2;
            background-image:
                linear-gradient(rgba(255,255,255,0.78), rgba(255,255,255,0.92)),
                url("https://images.unsplash.com/photo-1505373877841-8d25f7d46678?auto=format&fit=crop&w=1920&q=90");
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
        }

        .eh-page-shell::after {
            content: "";
            position: fixed;
            inset: 0;
            z-index: -1;
            background:
                linear-gradient(120deg, rgba(255,255,255,0.98), rgba(255,255,255,0.78), rgba(239,246,255,0.88)),
                radial-gradient(circle at 80% 10%, rgba(79,70,229,0.12), transparent 28%);
            pointer-events: none;
        }

        /* ================= NAVBAR ================= */

        .eh-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: rgba(255, 255, 255, 0.84);
            backdrop-filter: blur(22px);
            -webkit-backdrop-filter: blur(22px);
            border-bottom: 1px solid rgba(15, 23, 42, 0.08);
            box-shadow: 0 10px 32px rgba(15, 23, 42, 0.05);
        }

        .eh-navbar-inner {
            width: min(94%, 1400px);
            margin: 0 auto;
            padding: 14px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .eh-brand {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            color: #0f172a;
            font-weight: 900;
            letter-spacing: 0.6px;
            font-size: 1.45rem;
        }

        .eh-brand-mark {
            width: 42px;
            height: 42px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 15px;
            color: #ffffff;
            background:
                linear-gradient(135deg, var(--eh-primary), var(--eh-secondary));
            box-shadow: 0 14px 34px rgba(79, 70, 229, 0.26);
        }

        .eh-brand small {
            display: block;
            margin-top: 2px;
            color: var(--eh-muted);
            font-size: 0.68rem;
            font-weight: 700;
            letter-spacing: 1.8px;
            text-transform: uppercase;
        }

        .eh-nav-links {
            list-style: none;
            display: flex;
            align-items: center;
            gap: 9px;
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
            min-height: 42px;
            padding: 10px 15px;
            border-radius: 999px;
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
            color: var(--eh-primary);
            background: rgba(79, 70, 229, 0.08);
        }

        .eh-nav-link.active {
            color: var(--eh-primary-dark);
            background: linear-gradient(135deg, rgba(79,70,229,0.12), rgba(6,182,212,0.10));
            border-color: rgba(79, 70, 229, 0.16);
            box-shadow: 0 10px 26px rgba(79, 70, 229, 0.10);
        }

        .eh-nav-bell {
            position: relative;
            color: #334155;
            width: 44px;
            padding: 0;
            background: #ffffff;
            border-color: rgba(15, 23, 42, 0.10);
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.06);
        }

        .eh-nav-bell:hover,
        .eh-nav-bell.active {
            color: var(--eh-primary);
            border-color: rgba(79, 70, 229, 0.22);
            background: rgba(79, 70, 229, 0.08);
            transform: translateY(-1px);
        }

        .eh-bell-badge {
            position: absolute;
            top: -7px;
            right: -5px;
            min-width: 19px;
            height: 19px;
            padding: 0 6px;
            border-radius: 999px;
            background: linear-gradient(135deg, #ef4444, #f97316);
            color: #ffffff;
            font-size: 0.68rem;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 18px rgba(239, 68, 68, 0.28);
        }

        .eh-nav-btn {
            color: #ffffff;
            background: linear-gradient(135deg, var(--eh-primary), #7c3aed);
            box-shadow: 0 14px 30px rgba(79, 70, 229, 0.24);
        }

        .eh-nav-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 18px 38px rgba(79, 70, 229, 0.30);
        }

        .eh-nav-btn-outline {
            color: var(--eh-primary-dark);
            border-color: rgba(79, 70, 229, 0.22);
            background: rgba(79, 70, 229, 0.08);
        }

        .eh-nav-btn-outline:hover {
            color: #ffffff;
            background: linear-gradient(135deg, var(--eh-primary), var(--eh-secondary));
            box-shadow: 0 14px 30px rgba(79, 70, 229, 0.18);
            transform: translateY(-1px);
        }

        /* ================= HERO ================= */

        .hero {
            position: relative;
            min-height: calc(100vh - 76px);
            display: flex;
            align-items: center;
            padding: 84px 0 74px;
            background: transparent;
        }

        .hero-layout {
            width: min(92%, 1220px);
            margin: 0 auto;
            display: grid;
            grid-template-columns: minmax(0, 1.02fr) minmax(360px, 0.78fr);
            gap: 46px;
            align-items: center;
        }

        .hero-content {
            max-width: 700px;
            padding: 0;
            color: var(--eh-text);
        }

        .hero-badge {
            width: fit-content;
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 10px 16px;
            border-radius: 999px;
            color: var(--eh-primary-dark);
            background: rgba(255, 255, 255, 0.82);
            border: 1px solid rgba(79, 70, 229, 0.14);
            box-shadow: 0 14px 36px rgba(15, 23, 42, 0.08);
            font-size: 0.86rem;
            font-weight: 900;
            letter-spacing: 0.4px;
            text-transform: uppercase;
        }

        .hero-badge i {
            color: var(--eh-gold);
        }

        .hero-title {
            margin: 24px 0 18px;
            font-size: clamp(3.1rem, 7vw, 6.4rem);
            line-height: 0.94;
            letter-spacing: -4px;
            font-weight: 950;
            color: #0f172a;
        }

        .hero-title span {
            display: inline-block;
            background: linear-gradient(135deg, var(--eh-primary), var(--eh-secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .hero-subtitle {
            max-width: 650px;
            margin: 0 0 30px;
            color: #475569;
            font-size: 1.12rem;
            line-height: 1.8;
            font-weight: 600;
        }

        .hero-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-height: 52px;
            padding: 14px 22px;
            border-radius: 999px;
            font-weight: 900;
            font-size: 0.98rem;
            border: 1px solid transparent;
            transition: 0.24s ease;
            cursor: pointer;
        }

        .btn-primary {
            color: #ffffff;
            background: linear-gradient(135deg, var(--eh-primary), #7c3aed);
            box-shadow: 0 20px 42px rgba(79, 70, 229, 0.26);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 24px 52px rgba(79, 70, 229, 0.34);
        }

        .btn-outline {
            color: #0f172a;
            background: rgba(255, 255, 255, 0.78);
            border-color: rgba(15, 23, 42, 0.12);
            box-shadow: 0 14px 34px rgba(15, 23, 42, 0.08);
        }

        .btn-outline:hover {
            color: var(--eh-primary-dark);
            border-color: rgba(79, 70, 229, 0.22);
            transform: translateY(-2px);
        }

        .hero-trust-row {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .hero-trust-item {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 13px;
            border-radius: 999px;
            color: #334155;
            background: rgba(255, 255, 255, 0.70);
            border: 1px solid rgba(15, 23, 42, 0.08);
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05);
            font-size: 0.85rem;
            font-weight: 800;
        }

        .hero-trust-item i {
            color: var(--eh-primary);
        }

        .hero-visual {
            position: relative;
            min-height: 520px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .hero-card-main {
            position: relative;
            width: min(100%, 440px);
            border-radius: 34px;
            overflow: hidden;
            background: #ffffff;
            box-shadow: 0 34px 90px rgba(15, 23, 42, 0.20);
            border: 1px solid rgba(255, 255, 255, 0.8);
        }

        .hero-card-image {
            height: 292px;
            background:
                linear-gradient(180deg, rgba(15,23,42,0.05), rgba(15,23,42,0.60)),
                url("https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=1000&q=90");
            background-size: cover;
            background-position: center;
        }

        .hero-card-body {
            padding: 24px;
        }

        .hero-card-meta {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            margin-bottom: 12px;
        }

        .hero-pill {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 11px;
            border-radius: 999px;
            color: var(--eh-primary-dark);
            background: rgba(79, 70, 229, 0.10);
            font-size: 0.78rem;
            font-weight: 900;
        }

        .hero-rating {
            color: #92400e;
            font-size: 0.82rem;
            font-weight: 900;
        }

        .hero-card-body h3 {
            margin: 0 0 9px;
            color: #0f172a;
            font-size: 1.35rem;
            letter-spacing: -0.6px;
        }

        .hero-card-body p {
            margin: 0;
            color: var(--eh-muted);
            line-height: 1.6;
            font-weight: 600;
        }

        .floating-stat {
            position: absolute;
            z-index: 4;
            width: 190px;
            padding: 18px;
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.88);
            border: 1px solid rgba(15, 23, 42, 0.08);
            box-shadow: 0 22px 60px rgba(15, 23, 42, 0.14);
            backdrop-filter: blur(16px);
        }

        .floating-stat.one {
            left: -8px;
            top: 52px;
        }

        .floating-stat.two {
            right: -2px;
            bottom: 52px;
        }

        .floating-stat-icon {
            width: 42px;
            height: 42px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 15px;
            color: #ffffff;
            background: linear-gradient(135deg, var(--eh-primary), var(--eh-secondary));
            margin-bottom: 12px;
        }

        .floating-stat strong {
            display: block;
            color: #0f172a;
            font-size: 1.45rem;
            font-weight: 950;
            letter-spacing: -0.8px;
        }

        .floating-stat span {
            display: block;
            color: var(--eh-muted);
            margin-top: 3px;
            font-size: 0.82rem;
            font-weight: 800;
        }

        /* ================= FEATURES ================= */

        .features-section {
            position: relative;
            padding: 86px 0;
            background: rgba(255, 255, 255, 0.62);
            backdrop-filter: blur(10px);
        }

        .section-header {
            max-width: 760px;
            margin: 0 auto 42px;
            text-align: center;
        }

        .section-kicker {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 13px;
            color: var(--eh-primary-dark);
            font-weight: 950;
            font-size: 0.82rem;
            letter-spacing: 1.4px;
            text-transform: uppercase;
        }

        .section-title {
            margin: 0;
            color: #0f172a;
            font-size: clamp(2.1rem, 4vw, 3.5rem);
            line-height: 1.05;
            letter-spacing: -2px;
            font-weight: 950;
        }

        .section-title span {
            background: linear-gradient(135deg, var(--eh-primary), var(--eh-secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .section-subtitle {
            max-width: 650px;
            margin: 16px auto 0;
            color: var(--eh-muted);
            font-size: 1.02rem;
            line-height: 1.7;
            font-weight: 600;
        }

        .section-divider {
            width: 86px;
            height: 5px;
            margin: 24px auto 0;
            border-radius: 999px;
            background: linear-gradient(135deg, var(--eh-primary), var(--eh-secondary));
            box-shadow: 0 8px 18px rgba(79, 70, 229, 0.20);
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 20px;
        }

        .card,
        .feature-card {
            position: relative;
            overflow: hidden;
            padding: 28px;
            border-radius: var(--eh-radius-lg);
            background: rgba(255, 255, 255, 0.90);
            border: 1px solid rgba(15, 23, 42, 0.08);
            box-shadow: var(--eh-shadow-soft);
            transition: 0.26s ease;
        }

        .feature-card::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at top right, rgba(79,70,229,0.10), transparent 35%),
                radial-gradient(circle at bottom left, rgba(6,182,212,0.10), transparent 32%);
            opacity: 0;
            transition: 0.26s ease;
        }

        .feature-card:hover {
            transform: translateY(-7px);
            box-shadow: 0 28px 70px rgba(15, 23, 42, 0.14);
            border-color: rgba(79, 70, 229, 0.18);
        }

        .feature-card:hover::before {
            opacity: 1;
        }

        .feature-icon {
            position: relative;
            width: 58px;
            height: 58px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            border-radius: 20px;
            font-size: 1.55rem;
            background: linear-gradient(135deg, rgba(79,70,229,0.12), rgba(6,182,212,0.12));
            border: 1px solid rgba(79, 70, 229, 0.12);
        }

        .feature-card h3 {
            position: relative;
            margin: 0 0 10px;
            color: #0f172a;
            font-size: 1.18rem;
            letter-spacing: -0.4px;
            font-weight: 950;
        }

        .feature-card p {
            position: relative;
            margin: 0;
            color: var(--eh-muted);
            line-height: 1.65;
            font-weight: 600;
        }

        /* ================= CTA ================= */

        .home-cta {
            padding: 24px 0 92px;
            background: rgba(255, 255, 255, 0.60);
        }

        .cta-box {
            position: relative;
            overflow: hidden;
            display: grid;
            grid-template-columns: 1fr auto;
            align-items: center;
            gap: 28px;
            padding: 44px;
            border-radius: 34px;
            background:
                linear-gradient(135deg, rgba(255,255,255,0.94), rgba(239,246,255,0.94)),
                linear-gradient(135deg, rgba(79,70,229,0.10), rgba(6,182,212,0.08));
            border: 1px solid rgba(79, 70, 229, 0.12);
            box-shadow: var(--eh-shadow);
        }

        .cta-box::before {
            content: "";
            position: absolute;
            width: 280px;
            height: 280px;
            right: -100px;
            top: -110px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(79,70,229,0.20), transparent 62%);
        }

        .cta-box h2 {
            position: relative;
            margin: 0 0 10px;
            color: #0f172a;
            font-size: clamp(1.8rem, 3vw, 2.6rem);
            letter-spacing: -1.3px;
            font-weight: 950;
        }

        .cta-box p {
            position: relative;
            margin: 0;
            color: var(--eh-muted);
            font-size: 1rem;
            line-height: 1.7;
            font-weight: 650;
        }

        .cta-box .btn {
            position: relative;
        }

        /* ================= FOOTER ================= */

        .footer {
            background: rgba(255, 255, 255, 0.92);
            border-top: 1px solid rgba(15, 23, 42, 0.08);
            color: #334155;
            backdrop-filter: blur(16px);
        }

        .footer-container {
            display: grid;
            grid-template-columns: 1.4fr 0.8fr 0.8fr 0.8fr;
            gap: 32px;
            padding: 58px 0 40px;
        }

        .footer-logo {
            margin: 0 0 14px;
            color: #0f172a;
            font-size: 1.5rem;
            font-weight: 950;
            letter-spacing: -0.5px;
        }

        .footer-text {
            max-width: 420px;
            margin: 0;
            color: var(--eh-muted);
            line-height: 1.8;
            font-weight: 600;
        }

        .footer-col h4 {
            margin: 0 0 16px;
            color: #0f172a;
            font-size: 1rem;
            font-weight: 950;
        }

        .footer-col ul {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .footer-col li {
            margin-bottom: 10px;
        }

        .footer-col a {
            color: #475569;
            font-weight: 700;
            transition: 0.2s ease;
        }

        .footer-col a:hover {
            color: var(--eh-primary);
            padding-left: 4px;
        }

        .footer-bottom {
            border-top: 1px solid rgba(15, 23, 42, 0.08);
            background: rgba(248, 250, 252, 0.90);
        }

        .footer-bottom-inner {
            min-height: 58px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .footer-bottom p {
            margin: 0;
            color: #64748b;
            font-size: 0.9rem;
            font-weight: 700;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 1100px) {
            .hero-layout {
                grid-template-columns: 1fr;
                gap: 34px;
            }

            .hero-content {
                max-width: 860px;
                text-align: center;
                margin: 0 auto;
            }

            .hero-badge,
            .hero-actions,
            .hero-trust-row {
                justify-content: center;
                margin-left: auto;
                margin-right: auto;
            }

            .hero-visual {
                min-height: auto;
            }

            .features-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .footer-container {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 900px) {
            .eh-navbar-inner {
                flex-direction: column;
                align-items: stretch;
            }

            .eh-brand {
                justify-content: center;
            }

            .eh-nav-links {
                justify-content: center;
            }

            .hero {
                min-height: auto;
                padding-top: 60px;
            }

            .hero-title {
                letter-spacing: -2.5px;
            }

            .floating-stat {
                display: none;
            }

            .cta-box {
                grid-template-columns: 1fr;
                text-align: center;
                justify-items: center;
                padding: 34px 24px;
            }
        }

        @media (max-width: 640px) {
            .eh-nav-link span,
            .eh-nav-btn span,
            .eh-nav-btn-outline span {
                display: none;
            }

            .eh-nav-link,
            .eh-nav-btn,
            .eh-nav-btn-outline {
                width: 44px;
                padding: 0;
            }

            .hero-title {
                font-size: 3rem;
            }

            .hero-subtitle {
                font-size: 1rem;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }

            .footer-container {
                grid-template-columns: 1fr;
            }

            .footer-bottom-inner {
                justify-content: center;
                text-align: center;
            }

            .hero-card-main {
                border-radius: 26px;
            }

            .hero-card-image {
                height: 230px;
            }
        }
    </style>
</head>

<body>
<div class="eh-page-shell">

    <nav class="eh-navbar">
        <div class="eh-navbar-inner">
            <a href="${pageContext.request.contextPath}/index.jsp" class="eh-brand">
                <span class="eh-brand-mark">
                    <i class="fa-solid fa-cube"></i>
                </span>
                <span>
                    EVENTHORIZON
                    <small>Premium Booking</small>
                </span>
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
        <div class="hero-layout">
            <div class="hero-content">
                <span class="hero-badge">
                    <i class="fa-solid fa-star"></i>
                    Premium Event Booking Platform
                </span>

                <h1 class="hero-title">
                    Experience the<br>
                    <span>Extraordinary</span>
                </h1>

                <p class="hero-subtitle">
                    Discover concerts, sports events, tech summits and cultural shows.
                    Book your tickets in seconds with a seamless, secure and beautifully modern experience.
                </p>

                <div class="hero-actions">
                    <a href="${pageContext.request.contextPath}/event?action=list" class="btn btn-primary">
                        <i class="fa-solid fa-ticket"></i>
                        Browse Events
                    </a>

                    <c:if test="${empty sessionScope.userId}">
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline">
                            <i class="fa-solid fa-user-plus"></i>
                            Create Account
                        </a>
                    </c:if>

                    <c:if test="${not empty sessionScope.userId}">
                        <a href="${pageContext.request.contextPath}/IssueServlet?action=report" class="btn btn-outline">
                            <i class="fa-regular fa-message"></i>
                            Report an Issue
                        </a>
                    </c:if>
                </div>

                <div class="hero-trust-row">
                    <span class="hero-trust-item">
                        <i class="fa-solid fa-bolt"></i>
                        Instant Booking
                    </span>

                    <span class="hero-trust-item">
                        <i class="fa-solid fa-shield-halved"></i>
                        Secure Access
                    </span>

                    <span class="hero-trust-item">
                        <i class="fa-solid fa-qrcode"></i>
                        QR Ticket Ready
                    </span>
                </div>
            </div>

            <div class="hero-visual">
                <div class="floating-stat one">
                    <div class="floating-stat-icon">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <strong>Live</strong>
                    <span>Event discovery and booking</span>
                </div>

                <div class="hero-card-main">
                    <div class="hero-card-image"></div>

                    <div class="hero-card-body">
                        <div class="hero-card-meta">
                            <span class="hero-pill">
                                <i class="fa-solid fa-wand-magic-sparkles"></i>
                                Featured Experience
                            </span>

                            <span class="hero-rating">
                                <i class="fa-solid fa-star"></i>
                                Premium
                            </span>
                        </div>

                        <h3>Book unforgettable moments</h3>
                        <p>
                            Explore top events, reserve your seats, manage bookings,
                            and receive verified ticket access through one clean platform.
                        </p>
                    </div>
                </div>

                <div class="floating-stat two">
                    <div class="floating-stat-icon">
                        <i class="fa-solid fa-lock"></i>
                    </div>
                    <strong>Safe</strong>
                    <span>Protected booking workflow</span>
                </div>
            </div>
        </div>
    </section>

    <section class="features-section">
        <div class="container">
            <div class="section-header">
                <div class="section-kicker">
                    <i class="fa-solid fa-gem"></i>
                    Why Choose Us
                </div>

                <h2 class="section-title">
                    Why <span>EventHorizon?</span>
                </h2>

                <p class="section-subtitle">
                    Built for speed, security and unforgettable experiences with a clean enterprise-level interface.
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
                <div>
                    <h2>Ready to book your next experience?</h2>
                    <p>Explore trending events and reserve your seat before they sell out.</p>
                </div>

                <a href="${pageContext.request.contextPath}/event?action=list" class="btn btn-primary">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    Explore Events
                </a>
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

</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>