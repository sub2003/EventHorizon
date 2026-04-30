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
    <title>EventHorizon – Premium Event Booking</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Playfair+Display:ital,wght@0,700;0,800;1,700;1,800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        :root {
            --eh-bg: #fbf6ec;
            --eh-bg-soft: #fffaf2;
            --eh-white: #ffffff;
            --eh-cream: #f4ead8;
            --eh-cream-2: #fff2d6;

            --eh-espresso: #1f160c;
            --eh-charcoal: #2b2a27;
            --eh-brown: #4f3a1f;
            --eh-muted: #75664f;

            --eh-gold: #b8842b;
            --eh-gold-dark: #9b6a1d;
            --eh-gold-light: #d5ad5a;
            --eh-gold-soft: #fff0cc;

            --eh-navy: #24324a;
            --eh-navy-soft: #eef2f7;

            --eh-border: rgba(31, 22, 12, 0.10);
            --eh-gold-border: rgba(184, 132, 43, 0.26);

            --eh-shadow: 0 28px 80px rgba(31, 22, 12, 0.13);
            --eh-shadow-soft: 0 16px 42px rgba(31, 22, 12, 0.08);
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Inter', sans-serif;
            background:
                radial-gradient(circle at top left, rgba(184, 132, 43, 0.10), transparent 30%),
                radial-gradient(circle at top right, rgba(36, 50, 74, 0.07), transparent 30%),
                linear-gradient(180deg, #ffffff 0%, var(--eh-bg) 46%, var(--eh-bg-soft) 100%);
            color: var(--eh-charcoal);
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        a {
            text-decoration: none;
        }

        .eh-container {
            width: min(92%, 1240px);
            margin: 0 auto;
        }

        /* ================= NAVBAR ================= */

        .eh-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: rgba(255, 250, 242, 0.94);
            border-bottom: 1px solid var(--eh-border);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            box-shadow: 0 10px 30px rgba(31, 22, 12, 0.06);
        }

        .eh-navbar-inner {
            width: min(92%, 1240px);
            min-height: 74px;
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
            color: var(--eh-espresso);
            font-weight: 900;
            letter-spacing: 1.6px;
            text-transform: uppercase;
        }

        .eh-brand-mark {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            background: linear-gradient(135deg, var(--eh-gold-dark), var(--eh-gold-light));
            box-shadow: 0 14px 32px rgba(184, 132, 43, 0.24);
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
            font-size: 0.86rem;
            font-weight: 800;
            color: var(--eh-brown);
            transition: 0.22s ease;
            white-space: nowrap;
        }

        .eh-nav-link:hover,
        .eh-nav-link.active {
            color: var(--eh-gold-dark);
            background: var(--eh-gold-soft);
            border-color: var(--eh-gold-border);
        }

        .eh-nav-bell {
            position: relative;
            width: 44px;
            padding: 0;
            background: rgba(255, 255, 255, 0.84);
            border-color: var(--eh-border);
            box-shadow: 0 8px 20px rgba(31, 22, 12, 0.05);
        }

        .eh-nav-bell:hover {
            color: var(--eh-gold-dark);
            background: var(--eh-gold-soft);
            border-color: var(--eh-gold-border);
        }

        .eh-bell-badge {
            position: absolute;
            top: -7px;
            right: -7px;
            min-width: 19px;
            height: 19px;
            padding: 0 6px;
            border-radius: 999px;
            background: linear-gradient(135deg, #d94b32, #f08a4c);
            color: #ffffff;
            font-size: 0.64rem;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 18px rgba(217, 75, 50, 0.28);
        }

        .eh-nav-btn {
            color: #ffffff;
            background: linear-gradient(135deg, var(--eh-gold-dark), var(--eh-gold-light));
            box-shadow: 0 14px 30px rgba(184, 132, 43, 0.24);
        }

        .eh-nav-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 18px 42px rgba(184, 132, 43, 0.30);
        }

        .eh-nav-btn-outline {
            color: var(--eh-gold-dark);
            background: rgba(255, 255, 255, 0.84);
            border-color: var(--eh-gold-border);
        }

        .eh-nav-btn-outline:hover {
            background: var(--eh-gold-soft);
            border-color: rgba(184, 132, 43, 0.42);
        }

        /* ================= HERO ================= */

        .eh-hero {
            position: relative;
            min-height: calc(100vh - 74px);
            display: flex;
            align-items: center;
            overflow: hidden;
            isolation: isolate;
            background: var(--eh-bg);
        }

        .eh-hero-bg {
            position: absolute;
            inset: 0;
            z-index: -4;
            background-image: url("https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?auto=format&fit=crop&w=1920&q=95");
            background-size: cover;
            background-position: center 36%;
            filter: brightness(0.88) contrast(1.06) saturate(1.04);
            transform: scale(1.01);
        }

        .eh-hero-overlay {
            position: absolute;
            inset: 0;
            z-index: -3;
            background:
                linear-gradient(
                    90deg,
                    rgba(255, 250, 242, 0.99) 0%,
                    rgba(255, 250, 242, 0.96) 34%,
                    rgba(255, 250, 242, 0.74) 56%,
                    rgba(255, 250, 242, 0.28) 78%,
                    rgba(31, 22, 12, 0.12) 100%
                ),
                linear-gradient(
                    180deg,
                    rgba(255, 255, 255, 0.02) 0%,
                    rgba(251, 246, 236, 0.72) 100%
                );
        }

        .eh-hero::after {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
            height: 160px;
            z-index: -2;
            background: linear-gradient(180deg, transparent, var(--eh-bg));
        }

        .eh-hero-inner {
            width: min(92%, 1240px);
            margin: 0 auto;
            padding: 74px 0 132px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(340px, 0.68fr);
            align-items: center;
            gap: 48px;
        }

        .eh-hero-panel {
            max-width: 720px;
            padding: 46px 48px 50px;
            border-radius: 32px;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.97), rgba(255, 250, 242, 0.94));
            border: 1px solid rgba(31, 22, 12, 0.10);
            box-shadow:
                0 34px 92px rgba(31, 22, 12, 0.16),
                inset 0 1px 0 rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
        }

        .eh-eyebrow {
            width: fit-content;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 28px;
            padding: 9px 17px 9px 10px;
            border-radius: 999px;
            background: var(--eh-gold-soft);
            border: 1px solid var(--eh-gold-border);
            color: var(--eh-gold-dark);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        .eh-eyebrow-dot {
            width: 9px;
            height: 9px;
            border-radius: 999px;
            background: var(--eh-gold-dark);
            box-shadow: 0 0 0 4px rgba(184, 132, 43, 0.16);
        }

        .eh-hero-title {
            font-family: 'Playfair Display', serif !important;
            font-size: clamp(3.4rem, 6.4vw, 6.5rem) !important;
            line-height: 0.98 !important;
            letter-spacing: -2.5px !important;
            font-weight: 800 !important;
            color: var(--eh-espresso) !important;
            margin: 0 0 24px !important;
            text-shadow: none !important;
        }

        .eh-hero-title em {
            display: inline-block;
            font-style: italic !important;
            color: var(--eh-gold-dark) !important;
            text-shadow: none !important;
        }

        .eh-hero-subtitle {
            max-width: 590px;
            margin: 0 0 38px !important;
            color: var(--eh-brown) !important;
            font-size: 1.08rem !important;
            font-weight: 700 !important;
            line-height: 1.78 !important;
        }

        .eh-hero-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
        }

        .eh-btn {
            min-height: 54px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 15px 28px;
            border-radius: 15px;
            font-size: 0.94rem;
            font-weight: 900;
            transition: 0.24s ease;
            border: 1px solid transparent;
        }

        .eh-btn-primary {
            color: #ffffff;
            background: linear-gradient(135deg, var(--eh-gold-dark), var(--eh-gold-light));
            box-shadow: 0 18px 42px rgba(184, 132, 43, 0.28);
        }

        .eh-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 24px 54px rgba(184, 132, 43, 0.36);
        }

        .eh-btn-secondary {
            color: var(--eh-gold-dark);
            background: #ffffff;
            border-color: var(--eh-gold-border);
            box-shadow: 0 12px 30px rgba(31, 22, 12, 0.08);
        }

        .eh-btn-secondary:hover {
            background: var(--eh-gold-soft);
            transform: translateY(-2px);
        }

        .eh-hero-card {
            justify-self: end;
            width: min(100%, 420px);
            border-radius: 30px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.96);
            border: 1px solid rgba(255, 255, 255, 0.78);
            box-shadow: 0 34px 90px rgba(31, 22, 12, 0.20);
            backdrop-filter: blur(14px);
        }

        .eh-hero-card-image {
            height: 260px;
            background-image:
                linear-gradient(180deg, rgba(31,22,12,0.02), rgba(31,22,12,0.38)),
                url("https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=900&q=90");
            background-size: cover;
            background-position: center;
        }

        .eh-hero-card-body {
            padding: 24px;
        }

        .eh-hero-card-badge {
            width: fit-content;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            margin-bottom: 15px;
            padding: 8px 12px;
            border-radius: 999px;
            color: var(--eh-gold-dark);
            background: var(--eh-gold-soft);
            font-size: 0.72rem;
            font-weight: 900;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .eh-hero-card-body h3 {
            margin: 0 0 10px;
            color: var(--eh-espresso);
            font-size: 1.16rem;
            font-weight: 900;
            letter-spacing: -0.4px;
        }

        .eh-hero-card-body p {
            color: var(--eh-muted);
            font-size: 0.92rem;
            font-weight: 650;
            line-height: 1.65;
        }

        /* ================= STATS ================= */

        .eh-stats {
            position: relative;
            z-index: 5;
            width: min(92%, 1240px);
            margin: -78px auto 0;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            overflow: hidden;
            border-radius: 24px;
            background: rgba(184, 132, 43, 0.14);
            border: 1px solid var(--eh-gold-border);
            box-shadow: var(--eh-shadow);
        }

        .eh-stat {
            padding: 32px 28px;
            text-align: center;
            background: rgba(255, 255, 255, 0.98);
            border-right: 1px solid rgba(184, 132, 43, 0.16);
        }

        .eh-stat:last-child {
            border-right: none;
        }

        .eh-stat-number {
            font-family: 'Playfair Display', serif;
            color: var(--eh-gold-dark);
            font-size: 2.6rem;
            line-height: 1;
            font-weight: 800;
            margin-bottom: 9px;
        }

        .eh-stat-label {
            color: var(--eh-muted);
            font-size: 0.76rem;
            font-weight: 900;
            letter-spacing: 1.4px;
            text-transform: uppercase;
        }

        /* ================= FEATURES ================= */

        .eh-features {
            padding: 126px 0 90px;
            background:
                radial-gradient(circle at top left, rgba(184, 132, 43, 0.07), transparent 30%),
                radial-gradient(circle at bottom right, rgba(36, 50, 74, 0.06), transparent 32%),
                linear-gradient(180deg, var(--eh-bg), var(--eh-bg-soft));
        }

        .eh-section-header {
            max-width: 740px;
            margin: 0 auto 60px;
            text-align: center;
        }

        .eh-section-label {
            display: inline-block;
            margin-bottom: 14px;
            color: var(--eh-gold-dark);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2.2px;
            text-transform: uppercase;
        }

        .eh-section-title {
            font-family: 'Playfair Display', serif;
            color: var(--eh-espresso);
            font-size: clamp(2.3rem, 4vw, 3.6rem);
            font-weight: 800;
            line-height: 1.08;
            letter-spacing: -1.4px;
            margin-bottom: 16px;
        }

        .eh-section-title em {
            color: var(--eh-gold-dark);
            font-style: italic;
        }

        .eh-section-subtitle {
            color: var(--eh-muted);
            font-size: 1rem;
            font-weight: 650;
            line-height: 1.75;
        }

        .eh-feature-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 22px;
        }

        .eh-feature-card {
            position: relative;
            min-height: 235px;
            padding: 34px 28px;
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.98);
            border: 1px solid var(--eh-border);
            box-shadow: var(--eh-shadow-soft);
            transition: 0.28s ease;
            overflow: hidden;
        }

        .eh-feature-card::before {
            content: "";
            position: absolute;
            inset: 0 0 auto 0;
            height: 4px;
            background: linear-gradient(90deg, var(--eh-gold-dark), var(--eh-gold-light));
            transform: scaleX(0);
            transform-origin: left;
            transition: 0.28s ease;
        }

        .eh-feature-card:hover {
            transform: translateY(-7px);
            border-color: rgba(184, 132, 43, 0.26);
            box-shadow: 0 24px 70px rgba(31, 22, 12, 0.13);
        }

        .eh-feature-card:hover::before {
            transform: scaleX(1);
        }

        .eh-feature-icon {
            width: 58px;
            height: 58px;
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 18px;
            background: linear-gradient(135deg, var(--eh-gold-soft), #ffffff);
            border: 1px solid var(--eh-gold-border);
            color: var(--eh-gold-dark);
            font-size: 1.35rem;
        }

        .eh-feature-card h3 {
            margin-bottom: 10px;
            color: var(--eh-espresso);
            font-size: 1.16rem;
            font-weight: 900;
            letter-spacing: -0.4px;
        }

        .eh-feature-card p {
            color: var(--eh-muted);
            font-size: 0.92rem;
            font-weight: 650;
            line-height: 1.72;
        }

        /* ================= CTA ================= */

        .eh-cta-section {
            padding: 0 0 112px;
            background: var(--eh-bg-soft);
        }

        .eh-cta-box {
            position: relative;
            overflow: hidden;
            padding: 78px 46px;
            border-radius: 32px;
            text-align: center;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.96), rgba(255, 250, 242, 0.94)),
                url("https://images.unsplash.com/photo-1505373877841-8d25f7d46678?auto=format&fit=crop&w=1300&q=90");
            background-size: cover;
            background-position: center;
            border: 1px solid var(--eh-gold-border);
            box-shadow: var(--eh-shadow);
        }

        .eh-cta-box::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                linear-gradient(135deg, rgba(255,255,255,0.94), rgba(255,250,242,0.90)),
                radial-gradient(circle at top, rgba(184, 132, 43, 0.14), transparent 34%);
        }

        .eh-cta-content {
            position: relative;
            z-index: 2;
        }

        .eh-cta-label {
            display: inline-block;
            margin-bottom: 16px;
            color: var(--eh-gold-dark);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2.2px;
            text-transform: uppercase;
        }

        .eh-cta-box h2 {
            font-family: 'Playfair Display', serif;
            color: var(--eh-espresso);
            font-size: clamp(2.2rem, 4vw, 3.4rem);
            font-weight: 800;
            line-height: 1.12;
            letter-spacing: -1.2px;
            margin-bottom: 16px;
        }

        .eh-cta-box h2 em {
            color: var(--eh-gold-dark);
            font-style: italic;
        }

        .eh-cta-box p {
            max-width: 560px;
            margin: 0 auto 34px;
            color: var(--eh-muted);
            font-size: 1rem;
            font-weight: 650;
            line-height: 1.75;
        }

        /* ================= FOOTER ================= */

        .eh-footer {
            background: #fffaf2;
            color: var(--eh-muted);
            border-top: 1px solid var(--eh-border);
        }

        .eh-footer-grid {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr 1fr;
            gap: 48px;
            padding: 70px 0 56px;
        }

        .eh-footer-logo {
            margin-bottom: 18px;
            color: var(--eh-espresso);
            font-size: 1.3rem;
            font-weight: 900;
            letter-spacing: 2px;
        }

        .eh-footer-logo span {
            color: var(--eh-gold-dark);
        }

        .eh-footer-text {
            max-width: 320px;
            color: var(--eh-muted);
            font-size: 0.9rem;
            font-weight: 550;
            line-height: 1.8;
        }

        .eh-footer-col h4 {
            margin-bottom: 20px;
            color: var(--eh-espresso);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .eh-footer-col ul {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 11px;
        }

        .eh-footer-col ul li a {
            color: var(--eh-muted);
            font-size: 0.9rem;
            font-weight: 650;
            transition: 0.2s ease;
        }

        .eh-footer-col ul li a:hover {
            color: var(--eh-gold-dark);
        }

        .eh-footer-bottom {
            border-top: 1px solid var(--eh-border);
            background: #ffffff;
        }

        .eh-footer-bottom-inner {
            min-height: 62px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            color: var(--eh-muted);
            font-size: 0.82rem;
            font-weight: 650;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 1100px) {
            .eh-hero-inner {
                grid-template-columns: 1fr;
                padding-top: 62px;
            }

            .eh-hero-panel {
                max-width: 760px;
            }

            .eh-hero-card {
                display: none;
            }

            .eh-feature-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .eh-footer-grid {
                grid-template-columns: 1fr 1fr;
            }
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

            .eh-hero {
                min-height: auto;
            }

            .eh-hero-inner {
                padding: 46px 0 116px;
            }

            .eh-hero-panel {
                padding: 32px 24px;
                border-radius: 24px;
            }

            .eh-hero-title {
                font-size: clamp(3rem, 13vw, 4.5rem) !important;
                letter-spacing: -1.6px !important;
            }

            .eh-hero-subtitle {
                font-size: 1rem !important;
            }

            .eh-stats {
                grid-template-columns: 1fr;
                margin-top: -54px;
            }

            .eh-stat {
                border-right: none;
                border-bottom: 1px solid rgba(184, 132, 43, 0.16);
            }

            .eh-stat:last-child {
                border-bottom: none;
            }

            .eh-features {
                padding-top: 100px;
            }

            .eh-feature-grid {
                grid-template-columns: 1fr;
            }

            .eh-footer-grid {
                grid-template-columns: 1fr;
                gap: 32px;
            }

            .eh-footer-bottom-inner {
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
                width: 42px;
                padding: 0;
            }

            .eh-hero-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .eh-btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<nav class="eh-navbar">
    <div class="eh-navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="eh-brand">
            <span class="eh-brand-mark">
                <i class="fa-solid fa-diamond"></i>
            </span>
            <span class="eh-brand-text">EVENTHORIZON</span>
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

<section class="eh-hero">
    <div class="eh-hero-bg"></div>
    <div class="eh-hero-overlay"></div>

    <div class="eh-hero-inner">
        <div class="eh-hero-panel">
            <div class="eh-eyebrow">
                <span class="eh-eyebrow-dot"></span>
                <span>Premium Event Booking Platform</span>
            </div>

            <h1 class="eh-hero-title">
                Experience<br>the <em>Extraordinary</em>
            </h1>

            <p class="eh-hero-subtitle">
                Discover concerts, sports events, tech summits and cultural shows.
                Book your tickets in seconds with a seamless and secure experience.
            </p>

            <div class="eh-hero-actions">
                <a href="${pageContext.request.contextPath}/event?action=list" class="eh-btn eh-btn-primary">
                    <i class="fa-solid fa-ticket"></i> Browse Events
                </a>

                <c:if test="${empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="eh-btn eh-btn-secondary">
                        <i class="fa-solid fa-user-plus"></i> Create Account
                    </a>
                </c:if>

                <c:if test="${not empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/IssueServlet?action=report" class="eh-btn eh-btn-secondary">
                        <i class="fa-regular fa-flag"></i> Report an Issue
                    </a>
                </c:if>
            </div>
        </div>

        <div class="eh-hero-card">
            <div class="eh-hero-card-image"></div>
            <div class="eh-hero-card-body">
                <div class="eh-hero-card-badge">
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

<section class="eh-stats">
    <div class="eh-stat">
        <div class="eh-stat-number">500+</div>
        <div class="eh-stat-label">Live Events</div>
    </div>

    <div class="eh-stat">
        <div class="eh-stat-number">80K+</div>
        <div class="eh-stat-label">Tickets Sold</div>
    </div>

    <div class="eh-stat">
        <div class="eh-stat-number">4.9★</div>
        <div class="eh-stat-label">User Rating</div>
    </div>
</section>

<section class="eh-features">
    <div class="eh-container">
        <div class="eh-section-header">
            <span class="eh-section-label">Why choose us</span>
            <h2 class="eh-section-title">Why <em>EventHorizon?</em></h2>
            <p class="eh-section-subtitle">
                Built for speed, security, and unforgettable experiences.
            </p>
        </div>

        <div class="eh-feature-grid">
            <div class="eh-feature-card">
                <div class="eh-feature-icon">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <h3>Instant Booking</h3>
                <p>Reserve your seat in real-time with no waiting and no confusion.</p>
            </div>

            <div class="eh-feature-card">
                <div class="eh-feature-icon">
                    <i class="fa-solid fa-lock"></i>
                </div>
                <h3>Secure &amp; Safe</h3>
                <p>Your account, payments, and bookings stay protected and reliable.</p>
            </div>

            <div class="eh-feature-card">
                <div class="eh-feature-icon">
                    <i class="fa-solid fa-masks-theater"></i>
                </div>
                <h3>All Categories</h3>
                <p>Concerts, sports, tech, and cultural events — all in one place.</p>
            </div>

            <div class="eh-feature-card">
                <div class="eh-feature-icon">
                    <i class="fa-solid fa-mobile-screen-button"></i>
                </div>
                <h3>Easy to Use</h3>
                <p>A clean modern interface that works beautifully on desktop and mobile.</p>
            </div>
        </div>
    </div>
</section>

<section class="eh-cta-section">
    <div class="eh-container">
        <div class="eh-cta-box">
            <div class="eh-cta-content">
                <span class="eh-cta-label">Don't miss out</span>

                <h2>Ready to book your<br><em>next experience?</em></h2>

                <p>
                    Explore trending events and reserve your seat before they sell out.
                </p>

                <a href="${pageContext.request.contextPath}/event?action=list" class="eh-btn eh-btn-primary">
                    <i class="fa-solid fa-arrow-right"></i> Explore Events
                </a>
            </div>
        </div>
    </div>
</section>

<footer class="eh-footer">
    <div class="eh-container eh-footer-grid">
        <div class="eh-footer-col">
            <h2 class="eh-footer-logo">⬡ EVENT<span>HORIZON</span></h2>
            <p class="eh-footer-text">
                EventHorizon helps you discover, explore, and book unforgettable
                experiences with a fast, secure, and modern platform.
            </p>
        </div>

        <div class="eh-footer-col">
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

        <div class="eh-footer-col">
            <h4>Company</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/aboutUs.jsp">About Us</a></li>
                <li><a href="${pageContext.request.contextPath}/contacts.jsp">Contact</a></li>
                <li><a href="${pageContext.request.contextPath}/privacyPolicy.jsp">Privacy Policy</a></li>
                <li><a href="${pageContext.request.contextPath}/termsConditions.jsp">Terms &amp; Conditions</a></li>
            </ul>
        </div>

        <div class="eh-footer-col">
            <h4>Support</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/faqs.jsp">Help Center</a></li>
                <li><a href="${pageContext.request.contextPath}/faqs.jsp">FAQs</a></li>
                <li><a href="${pageContext.request.contextPath}/ticketPolicy.jsp">Ticket Policy</a></li>
                <li><a href="${pageContext.request.contextPath}/IssueServlet?action=report">Report an Issue</a></li>
            </ul>
        </div>
    </div>

    <div class="eh-footer-bottom">
        <div class="eh-container eh-footer-bottom-inner">
            <p>© 2026 EventHorizon. All rights reserved.</p>
            <p>Designed for modern event experiences.</p>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>