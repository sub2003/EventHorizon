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

    <!-- IMPORTANT:
         css/style.css is intentionally NOT linked here.
         This home page uses only the internal CSS below. -->

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Playfair+Display:ital,wght@0,700;0,800;1,700;1,800&display=swap" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        :root {
            --evh-bg: #fbf6ec;
            --evh-bg-soft: #fffaf2;
            --evh-white: #ffffff;

            --evh-espresso: #1f160c;
            --evh-charcoal: #2c2924;
            --evh-brown: #4e3920;
            --evh-muted: #776850;

            --evh-gold: #b8842b;
            --evh-gold-dark: #9b6a1d;
            --evh-gold-light: #d7af5d;
            --evh-gold-soft: #fff0cc;

            --evh-border: rgba(31, 22, 12, 0.10);
            --evh-gold-border: rgba(184, 132, 43, 0.26);

            --evh-shadow: 0 28px 80px rgba(31, 22, 12, 0.13);
            --evh-shadow-soft: 0 16px 42px rgba(31, 22, 12, 0.08);
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Inter', sans-serif;
            background:
                radial-gradient(circle at top left, rgba(184, 132, 43, 0.10), transparent 30%),
                radial-gradient(circle at top right, rgba(31, 22, 12, 0.06), transparent 30%),
                linear-gradient(180deg, #ffffff 0%, var(--evh-bg) 46%, var(--evh-bg-soft) 100%);
            color: var(--evh-charcoal);
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        a {
            text-decoration: none;
        }

        .evh-container {
            width: min(92%, 1240px);
            margin: 0 auto;
        }

        /* ================= NAVBAR ================= */

        .evh-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: rgba(255, 250, 242, 0.94);
            border-bottom: 1px solid var(--evh-border);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            box-shadow: 0 10px 30px rgba(31, 22, 12, 0.06);
        }

        .evh-navbar-inner {
            width: min(92%, 1240px);
            min-height: 74px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .evh-brand {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            color: var(--evh-espresso);
            font-weight: 900;
            letter-spacing: 1.6px;
            text-transform: uppercase;
        }

        .evh-brand-mark {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            background: linear-gradient(135deg, var(--evh-gold-dark), var(--evh-gold-light));
            box-shadow: 0 14px 32px rgba(184, 132, 43, 0.24);
        }

        .evh-brand-text {
            font-size: 1.08rem;
        }

        .evh-nav-links {
            list-style: none;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
            flex-wrap: wrap;
        }

        .evh-nav-links li {
            list-style: none;
        }

        .evh-nav-link,
        .evh-nav-bell,
        .evh-nav-btn,
        .evh-nav-btn-outline {
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
            color: var(--evh-brown);
            transition: 0.22s ease;
            white-space: nowrap;
        }

        .evh-nav-link:hover,
        .evh-nav-link.active {
            color: var(--evh-gold-dark);
            background: var(--evh-gold-soft);
            border-color: var(--evh-gold-border);
        }

        .evh-nav-bell {
            position: relative;
            width: 44px;
            padding: 0;
            background: rgba(255, 255, 255, 0.84);
            border-color: var(--evh-border);
            box-shadow: 0 8px 20px rgba(31, 22, 12, 0.05);
        }

        .evh-nav-bell:hover {
            color: var(--evh-gold-dark);
            background: var(--evh-gold-soft);
            border-color: var(--evh-gold-border);
        }

        .evh-bell-badge {
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

        .evh-nav-btn {
            color: #ffffff;
            background: linear-gradient(135deg, var(--evh-gold-dark), var(--evh-gold-light));
            box-shadow: 0 14px 30px rgba(184, 132, 43, 0.24);
        }

        .evh-nav-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 18px 42px rgba(184, 132, 43, 0.30);
        }

        .evh-nav-btn-outline {
            color: var(--evh-gold-dark);
            background: rgba(255, 255, 255, 0.84);
            border-color: var(--evh-gold-border);
        }

        .evh-nav-btn-outline:hover {
            background: var(--evh-gold-soft);
            border-color: rgba(184, 132, 43, 0.42);
        }

        /* ================= HERO ================= */

        .evh-hero {
            position: relative;
            min-height: calc(100vh - 74px);
            display: flex;
            align-items: center;
            overflow: hidden;
            isolation: isolate;
            background: var(--evh-bg);
        }

        .evh-hero-bg {
            position: absolute;
            inset: 0;
            z-index: -4;
            background-image: url("https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?auto=format&fit=crop&w=1920&q=95");
            background-size: cover;
            background-position: center 36%;
            filter: brightness(1.00) contrast(1.08) saturate(1.08);
            transform: scale(1.01);
        }

        .evh-hero-overlay {
            position: absolute;
            inset: 0;
            z-index: -3;
            background:
                linear-gradient(
                    90deg,
                    rgba(255, 250, 242, 0.94) 0%,
                    rgba(255, 250, 242, 0.84) 30%,
                    rgba(255, 250, 242, 0.44) 55%,
                    rgba(255, 250, 242, 0.10) 76%,
                    rgba(31, 22, 12, 0.06) 100%
                ),
                linear-gradient(
                    180deg,
                    rgba(255, 255, 255, 0.00) 0%,
                    rgba(251, 246, 236, 0.40) 100%
                );
        }

        .evh-hero::after {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
            height: 150px;
            z-index: -2;
            background: linear-gradient(180deg, transparent, var(--evh-bg));
        }

        .evh-hero-inner {
            width: min(92%, 1240px);
            margin: 0 auto;
            padding: 74px 0 132px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(340px, 0.68fr);
            align-items: center;
            gap: 48px;
        }

        .evh-hero-panel {
            max-width: 720px;
            padding: 46px 48px 50px;
            border-radius: 32px;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.91), rgba(255, 250, 242, 0.85));
            border: 1px solid rgba(31, 22, 12, 0.10);
            box-shadow:
                0 30px 76px rgba(31, 22, 12, 0.14),
                inset 0 1px 0 rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
        }

        .evh-eyebrow {
            width: fit-content;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 28px;
            padding: 9px 17px 9px 10px;
            border-radius: 999px;
            background: var(--evh-gold-soft);
            border: 1px solid var(--evh-gold-border);
            color: var(--evh-gold-dark);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        .evh-eyebrow-dot {
            width: 9px;
            height: 9px;
            border-radius: 999px;
            background: var(--evh-gold-dark);
            box-shadow: 0 0 0 4px rgba(184, 132, 43, 0.16);
        }

        .evh-hero-title {
            font-family: 'Playfair Display', serif !important;
            font-size: clamp(3.4rem, 6.4vw, 6.5rem) !important;
            line-height: 0.98 !important;
            letter-spacing: -2.5px !important;
            font-weight: 800 !important;
            color: var(--evh-espresso) !important;
            margin: 0 0 24px !important;
            text-shadow: none !important;
        }

        .evh-hero-title em {
            display: inline-block;
            font-style: italic !important;
            color: var(--evh-gold-dark) !important;
            text-shadow: none !important;
        }

        .evh-hero-subtitle {
            max-width: 590px;
            margin: 0 0 38px !important;
            color: var(--evh-brown) !important;
            font-size: 1.08rem !important;
            font-weight: 700 !important;
            line-height: 1.78 !important;
        }

        .evh-hero-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
        }

        .evh-btn {
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

        .evh-btn-primary {
            color: #ffffff;
            background: linear-gradient(135deg, var(--evh-gold-dark), var(--evh-gold-light));
            box-shadow: 0 18px 42px rgba(184, 132, 43, 0.28);
        }

        .evh-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 24px 54px rgba(184, 132, 43, 0.36);
        }

        .evh-btn-secondary {
            color: var(--evh-gold-dark);
            background: #ffffff;
            border-color: var(--evh-gold-border);
            box-shadow: 0 12px 30px rgba(31, 22, 12, 0.08);
        }

        .evh-btn-secondary:hover {
            background: var(--evh-gold-soft);
            transform: translateY(-2px);
        }

        .evh-hero-card {
            justify-self: end;
            width: min(100%, 420px);
            border-radius: 30px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.94);
            border: 1px solid rgba(255, 255, 255, 0.78);
            box-shadow: 0 30px 80px rgba(31, 22, 12, 0.18);
            backdrop-filter: blur(12px);
        }

        .evh-hero-card-image {
            height: 260px;
            background-image:
                linear-gradient(180deg, rgba(31,22,12,0.00), rgba(31,22,12,0.26)),
                url("https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=900&q=90");
            background-size: cover;
            background-position: center;
        }

        .evh-hero-card-body {
            padding: 24px;
        }

        .evh-hero-card-badge {
            width: fit-content;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            margin-bottom: 15px;
            padding: 8px 12px;
            border-radius: 999px;
            color: var(--evh-gold-dark);
            background: var(--evh-gold-soft);
            font-size: 0.72rem;
            font-weight: 900;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .evh-hero-card-body h3 {
            margin: 0 0 10px;
            color: var(--evh-espresso);
            font-size: 1.16rem;
            font-weight: 900;
            letter-spacing: -0.4px;
        }

        .evh-hero-card-body p {
            color: var(--evh-muted);
            font-size: 0.92rem;
            font-weight: 650;
            line-height: 1.65;
        }

        /* ================= STATS ================= */

        .evh-stats {
            position: relative;
            z-index: 5;
            width: min(92%, 1240px);
            margin: -78px auto 0;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            overflow: hidden;
            border-radius: 24px;
            background: rgba(184, 132, 43, 0.14);
            border: 1px solid var(--evh-gold-border);
            box-shadow: var(--evh-shadow);
        }

        .evh-stat {
            padding: 32px 28px;
            text-align: center;
            background: rgba(255, 255, 255, 0.98);
            border-right: 1px solid rgba(184, 132, 43, 0.16);
        }

        .evh-stat:last-child {
            border-right: none;
        }

        .evh-stat-number {
            font-family: 'Playfair Display', serif;
            color: var(--evh-gold-dark);
            font-size: 2.6rem;
            line-height: 1;
            font-weight: 800;
            margin-bottom: 9px;
        }

        .evh-stat-label {
            color: var(--evh-muted);
            font-size: 0.76rem;
            font-weight: 900;
            letter-spacing: 1.4px;
            text-transform: uppercase;
        }

        /* ================= FEATURES ================= */

        .evh-features {
            padding: 126px 0 90px;
            background:
                radial-gradient(circle at top left, rgba(184, 132, 43, 0.07), transparent 30%),
                radial-gradient(circle at bottom right, rgba(31, 22, 12, 0.05), transparent 32%),
                linear-gradient(180deg, var(--evh-bg), var(--evh-bg-soft));
        }

        .evh-section-header {
            max-width: 740px;
            margin: 0 auto 60px;
            text-align: center;
        }

        .evh-section-label {
            display: inline-block;
            margin-bottom: 14px;
            color: var(--evh-gold-dark);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2.2px;
            text-transform: uppercase;
        }

        .evh-section-title {
            font-family: 'Playfair Display', serif;
            color: var(--evh-espresso);
            font-size: clamp(2.3rem, 4vw, 3.6rem);
            font-weight: 800;
            line-height: 1.08;
            letter-spacing: -1.4px;
            margin-bottom: 16px;
        }

        .evh-section-title em {
            color: var(--evh-gold-dark);
            font-style: italic;
        }

        .evh-section-subtitle {
            color: var(--evh-muted);
            font-size: 1rem;
            font-weight: 650;
            line-height: 1.75;
        }

        .evh-feature-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 22px;
        }

        .evh-feature-card {
            position: relative;
            min-height: 235px;
            padding: 34px 28px;
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.98);
            border: 1px solid var(--evh-border);
            box-shadow: var(--evh-shadow-soft);
            transition: 0.28s ease;
            overflow: hidden;
        }

        .evh-feature-card::before {
            content: "";
            position: absolute;
            inset: 0 0 auto 0;
            height: 4px;
            background: linear-gradient(90deg, var(--evh-gold-dark), var(--evh-gold-light));
            transform: scaleX(0);
            transform-origin: left;
            transition: 0.28s ease;
        }

        .evh-feature-card:hover {
            transform: translateY(-7px);
            border-color: rgba(184, 132, 43, 0.26);
            box-shadow: 0 24px 70px rgba(31, 22, 12, 0.13);
        }

        .evh-feature-card:hover::before {
            transform: scaleX(1);
        }

        .evh-feature-icon {
            width: 58px;
            height: 58px;
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 18px;
            background: linear-gradient(135deg, var(--evh-gold-soft), #ffffff);
            border: 1px solid var(--evh-gold-border);
            color: var(--evh-gold-dark);
            font-size: 1.35rem;
        }

        .evh-feature-card h3 {
            margin-bottom: 10px;
            color: var(--evh-espresso);
            font-size: 1.16rem;
            font-weight: 900;
            letter-spacing: -0.4px;
        }

        .evh-feature-card p {
            color: var(--evh-muted);
            font-size: 0.92rem;
            font-weight: 650;
            line-height: 1.72;
        }

        /* ================= CTA ================= */

        .evh-cta-section {
            padding: 0 0 112px;
            background: var(--evh-bg-soft);
        }

        .evh-cta-box {
            position: relative;
            overflow: hidden;
            padding: 78px 46px;
            border-radius: 32px;
            text-align: center;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.90), rgba(255, 250, 242, 0.82)),
                url("https://images.unsplash.com/photo-1505373877841-8d25f7d46678?auto=format&fit=crop&w=1300&q=90");
            background-size: cover;
            background-position: center;
            border: 1px solid var(--evh-gold-border);
            box-shadow: var(--evh-shadow);
        }

        .evh-cta-box::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                linear-gradient(135deg, rgba(255,255,255,0.86), rgba(255,250,242,0.72)),
                radial-gradient(circle at top, rgba(184, 132, 43, 0.10), transparent 34%);
        }

        .evh-cta-content {
            position: relative;
            z-index: 2;
        }

        .evh-cta-label {
            display: inline-block;
            margin-bottom: 16px;
            color: var(--evh-gold-dark);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2.2px;
            text-transform: uppercase;
        }

        .evh-cta-box h2 {
            font-family: 'Playfair Display', serif;
            color: var(--evh-espresso);
            font-size: clamp(2.2rem, 4vw, 3.4rem);
            font-weight: 800;
            line-height: 1.12;
            letter-spacing: -1.2px;
            margin-bottom: 16px;
        }

        .evh-cta-box h2 em {
            color: var(--evh-gold-dark);
            font-style: italic;
        }

        .evh-cta-box p {
            max-width: 560px;
            margin: 0 auto 34px;
            color: var(--evh-brown);
            font-size: 1rem;
            font-weight: 700;
            line-height: 1.75;
        }

        /* ================= FOOTER ================= */

        .evh-footer {
            background: #fffaf2;
            color: var(--evh-muted);
            border-top: 1px solid var(--evh-border);
        }

        .evh-footer-grid {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr 1fr;
            gap: 48px;
            padding: 70px 0 56px;
        }

        .evh-footer-logo {
            margin-bottom: 18px;
            color: var(--evh-espresso);
            font-size: 1.3rem;
            font-weight: 900;
            letter-spacing: 2px;
        }

        .evh-footer-logo span {
            color: var(--evh-gold-dark);
        }

        .evh-footer-text {
            max-width: 320px;
            color: var(--evh-muted);
            font-size: 0.9rem;
            font-weight: 550;
            line-height: 1.8;
        }

        .evh-footer-col h4 {
            margin-bottom: 20px;
            color: var(--evh-espresso);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .evh-footer-col ul {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 11px;
        }

        .evh-footer-col ul li a {
            color: var(--evh-muted);
            font-size: 0.9rem;
            font-weight: 650;
            transition: 0.2s ease;
        }

        .evh-footer-col ul li a:hover {
            color: var(--evh-gold-dark);
        }

        .evh-footer-bottom {
            border-top: 1px solid var(--evh-border);
            background: #ffffff;
        }

        .evh-footer-bottom-inner {
            min-height: 62px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            color: var(--evh-muted);
            font-size: 0.82rem;
            font-weight: 650;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 1100px) {
            .evh-hero-inner {
                grid-template-columns: 1fr;
                padding-top: 62px;
            }

            .evh-hero-panel {
                max-width: 760px;
            }

            .evh-hero-card {
                display: none;
            }

            .evh-feature-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .evh-footer-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 768px) {
            .evh-navbar-inner {
                min-height: auto;
                padding: 14px 0;
                flex-direction: column;
                justify-content: center;
            }

            .evh-brand {
                justify-content: center;
            }

            .evh-nav-links {
                justify-content: center;
            }

            .evh-hero {
                min-height: auto;
            }

            .evh-hero-inner {
                padding: 46px 0 116px;
            }

            .evh-hero-panel {
                padding: 32px 24px;
                border-radius: 24px;
            }

            .evh-hero-title {
                font-size: clamp(3rem, 13vw, 4.5rem) !important;
                letter-spacing: -1.6px !important;
            }

            .evh-hero-subtitle {
                font-size: 1rem !important;
            }

            .evh-stats {
                grid-template-columns: 1fr;
                margin-top: -54px;
            }

            .evh-stat {
                border-right: none;
                border-bottom: 1px solid rgba(184, 132, 43, 0.16);
            }

            .evh-stat:last-child {
                border-bottom: none;
            }

            .evh-features {
                padding-top: 100px;
            }

            .evh-feature-grid {
                grid-template-columns: 1fr;
            }

            .evh-footer-grid {
                grid-template-columns: 1fr;
                gap: 32px;
            }

            .evh-footer-bottom-inner {
                flex-direction: column;
                justify-content: center;
                text-align: center;
                padding: 18px 0;
            }
        }

        @media (max-width: 520px) {
            .evh-nav-link span,
            .evh-nav-btn span,
            .evh-nav-btn-outline span {
                display: none;
            }

            .evh-nav-link,
            .evh-nav-btn,
            .evh-nav-btn-outline {
                width: 42px;
                padding: 0;
            }

            .evh-hero-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .evh-btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<nav class="evh-navbar">
    <div class="evh-navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="evh-brand">
            <span class="evh-brand-mark">
                <i class="fa-solid fa-diamond"></i>
            </span>
            <span class="evh-brand-text">EVENTHORIZON</span>
        </a>

        <ul class="evh-nav-links">
            <li>
                <a href="${pageContext.request.contextPath}/index.jsp" class="evh-nav-link active">
                    <i class="fa-solid fa-house"></i><span>Home</span>
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/event?action=list" class="evh-nav-link">
                    <i class="fa-solid fa-calendar-days"></i><span>Events</span>
                </a>
            </li>

            <c:choose>
                <c:when test="${not empty sessionScope.userId and sessionScope.role == 'CUSTOMER'}">
                    <li>
                        <a href="${pageContext.request.contextPath}/booking?action=myBookings" class="evh-nav-link">
                            <i class="fa-solid fa-ticket"></i><span>My Bookings</span>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/IssueServlet?action=myIssues" class="evh-nav-bell" title="Issue notifications">
                            <i class="fa-regular fa-bell"></i>
                            <% if (navIssueCount > 0) { %>
                                <span class="evh-bell-badge"><%= navIssueCount %></span>
                            <% } %>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/profile.jsp" class="evh-nav-link">
                            <i class="fa-regular fa-user"></i><span>Profile</span>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/user?action=logout" class="evh-nav-btn">
                            <i class="fa-solid fa-right-from-bracket"></i><span>Logout</span>
                        </a>
                    </li>
                </c:when>

                <c:when test="${not empty sessionScope.userId and sessionScope.role == 'ADMIN'}">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="evh-nav-link">
                            <i class="fa-solid fa-gauge-high"></i><span>Dashboard</span>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/profile.jsp" class="evh-nav-link">
                            <i class="fa-regular fa-user"></i><span>Profile</span>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/user?action=logout" class="evh-nav-btn">
                            <i class="fa-solid fa-right-from-bracket"></i><span>Logout</span>
                        </a>
                    </li>
                </c:when>

                <c:otherwise>
                    <li>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="evh-nav-link">
                            <i class="fa-solid fa-right-to-bracket"></i><span>Login</span>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="evh-nav-btn-outline">
                            <i class="fa-solid fa-user-plus"></i><span>Register</span>
                        </a>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>

<section class="evh-hero">
    <div class="evh-hero-bg"></div>
    <div class="evh-hero-overlay"></div>

    <div class="evh-hero-inner">
        <div class="evh-hero-panel">
            <div class="evh-eyebrow">
                <span class="evh-eyebrow-dot"></span>
                <span>Premium Event Booking Platform</span>
            </div>

            <h1 class="evh-hero-title">
                Experience<br>the <em>Extraordinary</em>
            </h1>

            <p class="evh-hero-subtitle">
                Discover concerts, sports events, tech summits and cultural shows.
                Book your tickets in seconds with a seamless and secure experience.
            </p>

            <div class="evh-hero-actions">
                <a href="${pageContext.request.contextPath}/event?action=list" class="evh-btn evh-btn-primary">
                    <i class="fa-solid fa-ticket"></i> Browse Events
                </a>

                <c:if test="${empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="evh-btn evh-btn-secondary">
                        <i class="fa-solid fa-user-plus"></i> Create Account
                    </a>
                </c:if>

                <c:if test="${not empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/IssueServlet?action=report" class="evh-btn evh-btn-secondary">
                        <i class="fa-regular fa-flag"></i> Report an Issue
                    </a>
                </c:if>
            </div>
        </div>

        <div class="evh-hero-card">
            <div class="evh-hero-card-image"></div>
            <div class="evh-hero-card-body">
                <div class="evh-hero-card-badge">
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

<section class="evh-stats">
    <div class="evh-stat">
        <div class="evh-stat-number">500+</div>
        <div class="evh-stat-label">Live Events</div>
    </div>

    <div class="evh-stat">
        <div class="evh-stat-number">80K+</div>
        <div class="evh-stat-label">Tickets Sold</div>
    </div>

    <div class="evh-stat">
        <div class="evh-stat-number">4.9★</div>
        <div class="evh-stat-label">User Rating</div>
    </div>
</section>

<section class="evh-features">
    <div class="evh-container">
        <div class="evh-section-header">
            <span class="evh-section-label">Why choose us</span>
            <h2 class="evh-section-title">Why <em>EventHorizon?</em></h2>
            <p class="evh-section-subtitle">
                Built for speed, security, and unforgettable experiences.
            </p>
        </div>

        <div class="evh-feature-grid">
            <div class="evh-feature-card">
                <div class="evh-feature-icon">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <h3>Instant Booking</h3>
                <p>Reserve your seat in real-time with no waiting and no confusion.</p>
            </div>

            <div class="evh-feature-card">
                <div class="evh-feature-icon">
                    <i class="fa-solid fa-lock"></i>
                </div>
                <h3>Secure &amp; Safe</h3>
                <p>Your account, payments, and bookings stay protected and reliable.</p>
            </div>

            <div class="evh-feature-card">
                <div class="evh-feature-icon">
                    <i class="fa-solid fa-masks-theater"></i>
                </div>
                <h3>All Categories</h3>
                <p>Concerts, sports, tech, and cultural events — all in one place.</p>
            </div>

            <div class="evh-feature-card">
                <div class="evh-feature-icon">
                    <i class="fa-solid fa-mobile-screen-button"></i>
                </div>
                <h3>Easy to Use</h3>
                <p>A clean modern interface that works beautifully on desktop and mobile.</p>
            </div>
        </div>
    </div>
</section>

<section class="evh-cta-section">
    <div class="evh-container">
        <div class="evh-cta-box">
            <div class="evh-cta-content">
                <span class="evh-cta-label">Don't miss out</span>

                <h2>Ready to book your<br><em>next experience?</em></h2>

                <p>
                    Explore trending events and reserve your seat before they sell out.
                </p>

                <a href="${pageContext.request.contextPath}/event?action=list" class="evh-btn evh-btn-primary">
                    <i class="fa-solid fa-arrow-right"></i> Explore Events
                </a>
            </div>
        </div>
    </div>
</section>

<footer class="evh-footer">
    <div class="evh-container evh-footer-grid">
        <div class="evh-footer-col">
            <h2 class="evh-footer-logo">⬡ EVENT<span>HORIZON</span></h2>
            <p class="evh-footer-text">
                EventHorizon helps you discover, explore, and book unforgettable
                experiences with a fast, secure, and modern platform.
            </p>
        </div>

        <div class="evh-footer-col">
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

        <div class="evh-footer-col">
            <h4>Company</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/aboutUs.jsp">About Us</a></li>
                <li><a href="${pageContext.request.contextPath}/contacts.jsp">Contact</a></li>
                <li><a href="${pageContext.request.contextPath}/privacyPolicy.jsp">Privacy Policy</a></li>
                <li><a href="${pageContext.request.contextPath}/termsConditions.jsp">Terms &amp; Conditions</a></li>
            </ul>
        </div>

        <div class="evh-footer-col">
            <h4>Support</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/faqs.jsp">Help Center</a></li>
                <li><a href="${pageContext.request.contextPath}/faqs.jsp">FAQs</a></li>
                <li><a href="${pageContext.request.contextPath}/ticketPolicy.jsp">Ticket Policy</a></li>
                <li><a href="${pageContext.request.contextPath}/IssueServlet?action=report">Report an Issue</a></li>
            </ul>
        </div>
    </div>

    <div class="evh-footer-bottom">
        <div class="evh-container evh-footer-bottom-inner">
            <p>© 2026 EventHorizon. All rights reserved.</p>
            <p>Designed for modern event experiences.</p>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>