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
            --ehl-bg: #fbf7ef;
            --ehl-bg-soft: #fffaf2;
            --ehl-white: #ffffff;
            --ehl-cream: #f5ead8;
            --ehl-cream-2: #fff2d8;

            --ehl-ink: #142033;
            --ehl-text: #233047;
            --ehl-muted: #6d7890;

            --ehl-blue: #2454d8;
            --ehl-blue-2: #4f7df3;
            --ehl-blue-soft: #eef4ff;

            --ehl-gold: #c89537;
            --ehl-gold-2: #e0b762;
            --ehl-gold-soft: #fff0cb;

            --ehl-border: rgba(20, 32, 51, 0.10);
            --ehl-blue-border: rgba(36, 84, 216, 0.16);
            --ehl-gold-border: rgba(200, 149, 55, 0.28);

            --ehl-shadow: 0 28px 80px rgba(20, 32, 51, 0.13);
            --ehl-shadow-soft: 0 16px 46px rgba(20, 32, 51, 0.08);
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Inter', sans-serif;
            background:
                radial-gradient(circle at top left, rgba(36, 84, 216, 0.09), transparent 32%),
                radial-gradient(circle at top right, rgba(200, 149, 55, 0.13), transparent 30%),
                linear-gradient(180deg, #ffffff 0%, var(--ehl-bg) 48%, var(--ehl-bg-soft) 100%);
            color: var(--ehl-text);
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        a {
            text-decoration: none;
        }

        .ehl-container {
            width: min(92%, 1240px);
            margin: 0 auto;
        }

        /* ================= NAVBAR ================= */

        .ehl-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: rgba(255, 255, 255, 0.92);
            border-bottom: 1px solid var(--ehl-border);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            box-shadow: 0 10px 30px rgba(20, 32, 51, 0.06);
        }

        .ehl-navbar-inner {
            width: min(92%, 1240px);
            min-height: 74px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .ehl-brand {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            color: var(--ehl-ink);
            font-weight: 900;
            letter-spacing: 1.6px;
            text-transform: uppercase;
        }

        .ehl-brand-mark {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            background: linear-gradient(135deg, var(--ehl-blue), var(--ehl-blue-2));
            box-shadow: 0 14px 34px rgba(36, 84, 216, 0.24);
        }

        .ehl-brand-text {
            font-size: 1.08rem;
        }

        .ehl-nav-links {
            list-style: none;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
            flex-wrap: wrap;
        }

        .ehl-nav-link,
        .ehl-nav-bell,
        .ehl-nav-btn,
        .ehl-nav-btn-outline {
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
            color: var(--ehl-text);
            transition: 0.22s ease;
            white-space: nowrap;
        }

        .ehl-nav-link:hover,
        .ehl-nav-link.active {
            color: var(--ehl-blue);
            background: var(--ehl-blue-soft);
            border-color: var(--ehl-blue-border);
        }

        .ehl-nav-bell {
            position: relative;
            width: 44px;
            padding: 0;
            background: var(--ehl-white);
            border-color: var(--ehl-border);
            box-shadow: 0 8px 20px rgba(20, 32, 51, 0.05);
        }

        .ehl-nav-bell:hover {
            color: var(--ehl-blue);
            background: var(--ehl-blue-soft);
            border-color: var(--ehl-blue-border);
        }

        .ehl-bell-badge {
            position: absolute;
            top: -7px;
            right: -7px;
            min-width: 19px;
            height: 19px;
            padding: 0 6px;
            border-radius: 999px;
            background: linear-gradient(135deg, #e23b2f, #ff7a45);
            color: #ffffff;
            font-size: 0.64rem;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 18px rgba(226, 59, 47, 0.30);
        }

        .ehl-nav-btn {
            color: #ffffff;
            background: linear-gradient(135deg, var(--ehl-blue), var(--ehl-blue-2));
            box-shadow: 0 14px 30px rgba(36, 84, 216, 0.24);
        }

        .ehl-nav-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 18px 42px rgba(36, 84, 216, 0.30);
        }

        .ehl-nav-btn-outline {
            color: var(--ehl-blue);
            background: var(--ehl-white);
            border-color: rgba(36, 84, 216, 0.24);
        }

        .ehl-nav-btn-outline:hover {
            background: var(--ehl-blue-soft);
            border-color: rgba(36, 84, 216, 0.38);
        }

        /* ================= HERO ================= */

        .ehl-hero {
            position: relative;
            min-height: calc(100vh - 74px);
            display: flex;
            align-items: center;
            overflow: hidden;
            isolation: isolate;
            background: var(--ehl-bg);
        }

        .ehl-hero-bg {
            position: absolute;
            inset: 0;
            z-index: -4;
            background-image: url("https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?auto=format&fit=crop&w=1920&q=95");
            background-size: cover;
            background-position: center 36%;
            filter: brightness(0.92) contrast(1.08) saturate(1.05);
            transform: scale(1.01);
        }

        .ehl-hero-overlay {
            position: absolute;
            inset: 0;
            z-index: -3;
            background:
                linear-gradient(
                    90deg,
                    rgba(255, 255, 255, 0.99) 0%,
                    rgba(255, 250, 242, 0.96) 34%,
                    rgba(255, 250, 242, 0.72) 55%,
                    rgba(255, 250, 242, 0.22) 78%,
                    rgba(20, 32, 51, 0.18) 100%
                ),
                linear-gradient(
                    180deg,
                    rgba(255, 255, 255, 0.02) 0%,
                    rgba(251, 247, 239, 0.68) 100%
                );
        }

        .ehl-hero::after {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
            height: 160px;
            z-index: -2;
            background: linear-gradient(180deg, transparent, var(--ehl-bg));
        }

        .ehl-hero-inner {
            width: min(92%, 1240px);
            margin: 0 auto;
            padding: 74px 0 132px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(340px, 0.68fr);
            align-items: center;
            gap: 48px;
        }

        .ehl-hero-panel {
            max-width: 720px;
            padding: 46px 48px 50px;
            border-radius: 32px;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.98), rgba(255, 250, 242, 0.94));
            border: 1px solid rgba(20, 32, 51, 0.10);
            box-shadow:
                0 34px 92px rgba(20, 32, 51, 0.16),
                inset 0 1px 0 rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
        }

        .ehl-eyebrow {
            width: fit-content;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 28px;
            padding: 9px 17px 9px 10px;
            border-radius: 999px;
            background: var(--ehl-blue-soft);
            border: 1px solid var(--ehl-blue-border);
            color: var(--ehl-blue);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        .ehl-eyebrow-dot {
            width: 9px;
            height: 9px;
            border-radius: 999px;
            background: var(--ehl-blue);
            box-shadow: 0 0 0 4px rgba(36, 84, 216, 0.14);
        }

        .ehl-hero-title {
            font-family: 'Playfair Display', serif !important;
            font-size: clamp(3.4rem, 6.4vw, 6.5rem) !important;
            line-height: 0.98 !important;
            letter-spacing: -2.5px !important;
            font-weight: 800 !important;
            color: var(--ehl-ink) !important;
            margin: 0 0 24px !important;
            text-shadow: none !important;
        }

        .ehl-hero-title em {
            display: inline-block;
            font-style: italic !important;
            color: var(--ehl-blue) !important;
            text-shadow: none !important;
        }

        .ehl-hero-subtitle {
            max-width: 590px;
            margin: 0 0 38px !important;
            color: #38445b !important;
            font-size: 1.08rem !important;
            font-weight: 700 !important;
            line-height: 1.78 !important;
        }

        .ehl-hero-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
        }

        .ehl-btn {
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

        .ehl-btn-primary {
            color: #ffffff;
            background: linear-gradient(135deg, var(--ehl-blue), var(--ehl-blue-2));
            box-shadow: 0 18px 42px rgba(36, 84, 216, 0.28);
        }

        .ehl-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 24px 54px rgba(36, 84, 216, 0.36);
        }

        .ehl-btn-secondary {
            color: var(--ehl-blue);
            background: var(--ehl-white);
            border-color: rgba(36, 84, 216, 0.24);
            box-shadow: 0 12px 30px rgba(20, 32, 51, 0.08);
        }

        .ehl-btn-secondary:hover {
            background: var(--ehl-blue-soft);
            transform: translateY(-2px);
        }

        .ehl-hero-card {
            justify-self: end;
            width: min(100%, 420px);
            border-radius: 30px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.96);
            border: 1px solid rgba(255, 255, 255, 0.78);
            box-shadow: 0 34px 90px rgba(20, 32, 51, 0.22);
            backdrop-filter: blur(14px);
        }

        .ehl-hero-card-image {
            height: 260px;
            background-image:
                linear-gradient(180deg, rgba(20,32,51,0.02), rgba(20,32,51,0.42)),
                url("https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=900&q=90");
            background-size: cover;
            background-position: center;
        }

        .ehl-hero-card-body {
            padding: 24px;
        }

        .ehl-hero-card-badge {
            width: fit-content;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            margin-bottom: 15px;
            padding: 8px 12px;
            border-radius: 999px;
            color: var(--ehl-blue);
            background: var(--ehl-blue-soft);
            font-size: 0.72rem;
            font-weight: 900;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .ehl-hero-card-body h3 {
            margin: 0 0 10px;
            color: var(--ehl-ink);
            font-size: 1.16rem;
            font-weight: 900;
            letter-spacing: -0.4px;
        }

        .ehl-hero-card-body p {
            color: var(--ehl-muted);
            font-size: 0.92rem;
            font-weight: 650;
            line-height: 1.65;
        }

        /* ================= STATS ================= */

        .ehl-stats {
            position: relative;
            z-index: 5;
            width: min(92%, 1240px);
            margin: -78px auto 0;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            overflow: hidden;
            border-radius: 24px;
            background: rgba(36, 84, 216, 0.14);
            border: 1px solid var(--ehl-blue-border);
            box-shadow: var(--ehl-shadow);
        }

        .ehl-stat {
            padding: 32px 28px;
            text-align: center;
            background: rgba(255, 255, 255, 0.98);
            border-right: 1px solid rgba(36, 84, 216, 0.12);
        }

        .ehl-stat:last-child {
            border-right: none;
        }

        .ehl-stat-number {
            font-family: 'Playfair Display', serif;
            color: var(--ehl-blue);
            font-size: 2.6rem;
            line-height: 1;
            font-weight: 800;
            margin-bottom: 9px;
        }

        .ehl-stat-label {
            color: var(--ehl-muted);
            font-size: 0.76rem;
            font-weight: 900;
            letter-spacing: 1.4px;
            text-transform: uppercase;
        }

        /* ================= FEATURES ================= */

        .ehl-features {
            padding: 126px 0 90px;
            background:
                radial-gradient(circle at top left, rgba(36, 84, 216, 0.07), transparent 30%),
                radial-gradient(circle at bottom right, rgba(200, 149, 55, 0.11), transparent 32%),
                linear-gradient(180deg, var(--ehl-bg), var(--ehl-bg-soft));
        }

        .ehl-section-header {
            max-width: 740px;
            margin: 0 auto 60px;
            text-align: center;
        }

        .ehl-section-label {
            display: inline-block;
            margin-bottom: 14px;
            color: var(--ehl-blue);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2.2px;
            text-transform: uppercase;
        }

        .ehl-section-title {
            font-family: 'Playfair Display', serif;
            color: var(--ehl-ink);
            font-size: clamp(2.3rem, 4vw, 3.6rem);
            font-weight: 800;
            line-height: 1.08;
            letter-spacing: -1.4px;
            margin-bottom: 16px;
        }

        .ehl-section-title em {
            color: var(--ehl-blue);
            font-style: italic;
        }

        .ehl-section-subtitle {
            color: var(--ehl-muted);
            font-size: 1rem;
            font-weight: 650;
            line-height: 1.75;
        }

        .ehl-feature-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 22px;
        }

        .ehl-feature-card {
            position: relative;
            min-height: 235px;
            padding: 34px 28px;
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.98);
            border: 1px solid var(--ehl-border);
            box-shadow: var(--ehl-shadow-soft);
            transition: 0.28s ease;
            overflow: hidden;
        }

        .ehl-feature-card::before {
            content: "";
            position: absolute;
            inset: 0 0 auto 0;
            height: 4px;
            background: linear-gradient(90deg, var(--ehl-blue), var(--ehl-gold));
            transform: scaleX(0);
            transform-origin: left;
            transition: 0.28s ease;
        }

        .ehl-feature-card:hover {
            transform: translateY(-7px);
            border-color: rgba(36, 84, 216, 0.22);
            box-shadow: 0 24px 70px rgba(20, 32, 51, 0.13);
        }

        .ehl-feature-card:hover::before {
            transform: scaleX(1);
        }

        .ehl-feature-icon {
            width: 58px;
            height: 58px;
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 18px;
            background: linear-gradient(135deg, var(--ehl-blue-soft), #ffffff);
            border: 1px solid var(--ehl-blue-border);
            color: var(--ehl-blue);
            font-size: 1.35rem;
        }

        .ehl-feature-card h3 {
            margin-bottom: 10px;
            color: var(--ehl-ink);
            font-size: 1.16rem;
            font-weight: 900;
            letter-spacing: -0.4px;
        }

        .ehl-feature-card p {
            color: var(--ehl-muted);
            font-size: 0.92rem;
            font-weight: 650;
            line-height: 1.72;
        }

        /* ================= CTA ================= */

        .ehl-cta-section {
            padding: 0 0 112px;
            background: var(--ehl-bg-soft);
        }

        .ehl-cta-box {
            position: relative;
            overflow: hidden;
            padding: 78px 46px;
            border-radius: 32px;
            text-align: center;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.96), rgba(238, 244, 255, 0.94)),
                url("https://images.unsplash.com/photo-1505373877841-8d25f7d46678?auto=format&fit=crop&w=1300&q=90");
            background-size: cover;
            background-position: center;
            border: 1px solid var(--ehl-blue-border);
            box-shadow: var(--ehl-shadow);
        }

        .ehl-cta-box::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                linear-gradient(135deg, rgba(255,255,255,0.94), rgba(238,244,255,0.88)),
                radial-gradient(circle at top, rgba(36, 84, 216, 0.14), transparent 34%);
        }

        .ehl-cta-content {
            position: relative;
            z-index: 2;
        }

        .ehl-cta-label {
            display: inline-block;
            margin-bottom: 16px;
            color: var(--ehl-blue);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2.2px;
            text-transform: uppercase;
        }

        .ehl-cta-box h2 {
            font-family: 'Playfair Display', serif;
            color: var(--ehl-ink);
            font-size: clamp(2.2rem, 4vw, 3.4rem);
            font-weight: 800;
            line-height: 1.12;
            letter-spacing: -1.2px;
            margin-bottom: 16px;
        }

        .ehl-cta-box h2 em {
            color: var(--ehl-blue);
            font-style: italic;
        }

        .ehl-cta-box p {
            max-width: 560px;
            margin: 0 auto 34px;
            color: var(--ehl-muted);
            font-size: 1rem;
            font-weight: 650;
            line-height: 1.75;
        }

        /* ================= FOOTER ================= */

        .ehl-footer {
            background: #ffffff;
            color: var(--ehl-muted);
            border-top: 1px solid var(--ehl-border);
        }

        .ehl-footer-grid {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr 1fr;
            gap: 48px;
            padding: 70px 0 56px;
        }

        .ehl-footer-logo {
            margin-bottom: 18px;
            color: var(--ehl-ink);
            font-size: 1.3rem;
            font-weight: 900;
            letter-spacing: 2px;
        }

        .ehl-footer-logo span {
            color: var(--ehl-blue);
        }

        .ehl-footer-text {
            max-width: 320px;
            color: var(--ehl-muted);
            font-size: 0.9rem;
            font-weight: 550;
            line-height: 1.8;
        }

        .ehl-footer-col h4 {
            margin-bottom: 20px;
            color: var(--ehl-ink);
            font-size: 0.74rem;
            font-weight: 900;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .ehl-footer-col ul {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 11px;
        }

        .ehl-footer-col ul li a {
            color: var(--ehl-muted);
            font-size: 0.9rem;
            font-weight: 650;
            transition: 0.2s ease;
        }

        .ehl-footer-col ul li a:hover {
            color: var(--ehl-blue);
        }

        .ehl-footer-bottom {
            border-top: 1px solid var(--ehl-border);
            background: var(--ehl-bg-soft);
        }

        .ehl-footer-bottom-inner {
            min-height: 62px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            color: var(--ehl-muted);
            font-size: 0.82rem;
            font-weight: 650;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 1100px) {
            .ehl-hero-inner {
                grid-template-columns: 1fr;
                padding-top: 62px;
            }

            .ehl-hero-panel {
                max-width: 760px;
            }

            .ehl-hero-card {
                display: none;
            }

            .ehl-feature-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .ehl-footer-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 768px) {
            .ehl-navbar-inner {
                min-height: auto;
                padding: 14px 0;
                flex-direction: column;
                justify-content: center;
            }

            .ehl-brand {
                justify-content: center;
            }

            .ehl-nav-links {
                justify-content: center;
            }

            .ehl-hero {
                min-height: auto;
            }

            .ehl-hero-inner {
                padding: 46px 0 116px;
            }

            .ehl-hero-panel {
                padding: 32px 24px;
                border-radius: 24px;
            }

            .ehl-hero-title {
                font-size: clamp(3rem, 13vw, 4.5rem) !important;
                letter-spacing: -1.6px !important;
            }

            .ehl-hero-subtitle {
                font-size: 1rem !important;
            }

            .ehl-stats {
                grid-template-columns: 1fr;
                margin-top: -54px;
            }

            .ehl-stat {
                border-right: none;
                border-bottom: 1px solid rgba(36, 84, 216, 0.12);
            }

            .ehl-stat:last-child {
                border-bottom: none;
            }

            .ehl-features {
                padding-top: 100px;
            }

            .ehl-feature-grid {
                grid-template-columns: 1fr;
            }

            .ehl-footer-grid {
                grid-template-columns: 1fr;
                gap: 32px;
            }

            .ehl-footer-bottom-inner {
                flex-direction: column;
                justify-content: center;
                text-align: center;
                padding: 18px 0;
            }
        }

        @media (max-width: 520px) {
            .ehl-nav-link span,
            .ehl-nav-btn span,
            .ehl-nav-btn-outline span {
                display: none;
            }

            .ehl-nav-link,
            .ehl-nav-btn,
            .ehl-nav-btn-outline {
                width: 42px;
                padding: 0;
            }

            .ehl-hero-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .ehl-btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<nav class="ehl-navbar">
    <div class="ehl-navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="ehl-brand">
            <span class="ehl-brand-mark">
                <i class="fa-solid fa-gem"></i>
            </span>
            <span class="ehl-brand-text">EVENTHORIZON</span>
        </a>

        <ul class="ehl-nav-links">
            <li>
                <a href="${pageContext.request.contextPath}/index.jsp" class="ehl-nav-link active">
                    <i class="fa-solid fa-house"></i><span>Home</span>
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/event?action=list" class="ehl-nav-link">
                    <i class="fa-solid fa-calendar-days"></i><span>Events</span>
                </a>
            </li>

            <c:choose>
                <c:when test="${not empty sessionScope.userId and sessionScope.role == 'CUSTOMER'}">
                    <li>
                        <a href="${pageContext.request.contextPath}/booking?action=myBookings" class="ehl-nav-link">
                            <i class="fa-solid fa-ticket"></i><span>My Bookings</span>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/IssueServlet?action=myIssues" class="ehl-nav-bell" title="Issue notifications">
                            <i class="fa-regular fa-bell"></i>
                            <% if (navIssueCount > 0) { %>
                                <span class="ehl-bell-badge"><%= navIssueCount %></span>
                            <% } %>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/profile.jsp" class="ehl-nav-link">
                            <i class="fa-regular fa-user"></i><span>Profile</span>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/user?action=logout" class="ehl-nav-btn">
                            <i class="fa-solid fa-right-from-bracket"></i><span>Logout</span>
                        </a>
                    </li>
                </c:when>

                <c:when test="${not empty sessionScope.userId and sessionScope.role == 'ADMIN'}">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="ehl-nav-link">
                            <i class="fa-solid fa-gauge-high"></i><span>Dashboard</span>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/profile.jsp" class="ehl-nav-link">
                            <i class="fa-regular fa-user"></i><span>Profile</span>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/user?action=logout" class="ehl-nav-btn">
                            <i class="fa-solid fa-right-from-bracket"></i><span>Logout</span>
                        </a>
                    </li>
                </c:when>

                <c:otherwise>
                    <li>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="ehl-nav-link">
                            <i class="fa-solid fa-right-to-bracket"></i><span>Login</span>
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="ehl-nav-btn-outline">
                            <i class="fa-solid fa-user-plus"></i><span>Register</span>
                        </a>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>

<section class="ehl-hero">
    <div class="ehl-hero-bg"></div>
    <div class="ehl-hero-overlay"></div>

    <div class="ehl-hero-inner">
        <div class="ehl-hero-panel">
            <div class="ehl-eyebrow">
                <span class="ehl-eyebrow-dot"></span>
                <span>Premium Event Booking Platform</span>
            </div>

            <h1 class="ehl-hero-title">
                Experience<br>the <em>Extraordinary</em>
            </h1>

            <p class="ehl-hero-subtitle">
                Discover concerts, sports events, tech summits and cultural shows.
                Book your tickets in seconds with a seamless and secure experience.
            </p>

            <div class="ehl-hero-actions">
                <a href="${pageContext.request.contextPath}/event?action=list" class="ehl-btn ehl-btn-primary">
                    <i class="fa-solid fa-ticket"></i> Browse Events
                </a>

                <c:if test="${empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="ehl-btn ehl-btn-secondary">
                        <i class="fa-solid fa-user-plus"></i> Create Account
                    </a>
                </c:if>

                <c:if test="${not empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/IssueServlet?action=report" class="ehl-btn ehl-btn-secondary">
                        <i class="fa-regular fa-flag"></i> Report an Issue
                    </a>
                </c:if>
            </div>
        </div>

        <div class="ehl-hero-card">
            <div class="ehl-hero-card-image"></div>
            <div class="ehl-hero-card-body">
                <div class="ehl-hero-card-badge">
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

<section class="ehl-stats">
    <div class="ehl-stat">
        <div class="ehl-stat-number">500+</div>
        <div class="ehl-stat-label">Live Events</div>
    </div>

    <div class="ehl-stat">
        <div class="ehl-stat-number">80K+</div>
        <div class="ehl-stat-label">Tickets Sold</div>
    </div>

    <div class="ehl-stat">
        <div class="ehl-stat-number">4.9★</div>
        <div class="ehl-stat-label">User Rating</div>
    </div>
</section>

<section class="ehl-features">
    <div class="ehl-container">
        <div class="ehl-section-header">
            <span class="ehl-section-label">Why choose us</span>
            <h2 class="ehl-section-title">Why <em>EventHorizon?</em></h2>
            <p class="ehl-section-subtitle">
                Built for speed, security, and unforgettable experiences.
            </p>
        </div>

        <div class="ehl-feature-grid">
            <div class="ehl-feature-card">
                <div class="ehl-feature-icon">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <h3>Instant Booking</h3>
                <p>Reserve your seat in real-time with no waiting and no confusion.</p>
            </div>

            <div class="ehl-feature-card">
                <div class="ehl-feature-icon">
                    <i class="fa-solid fa-lock"></i>
                </div>
                <h3>Secure &amp; Safe</h3>
                <p>Your account, payments, and bookings stay protected and reliable.</p>
            </div>

            <div class="ehl-feature-card">
                <div class="ehl-feature-icon">
                    <i class="fa-solid fa-masks-theater"></i>
                </div>
                <h3>All Categories</h3>
                <p>Concerts, sports, tech, and cultural events — all in one place.</p>
            </div>

            <div class="ehl-feature-card">
                <div class="ehl-feature-icon">
                    <i class="fa-solid fa-mobile-screen-button"></i>
                </div>
                <h3>Easy to Use</h3>
                <p>A clean modern interface that works beautifully on desktop and mobile.</p>
            </div>
        </div>
    </div>
</section>

<section class="ehl-cta-section">
    <div class="ehl-container">
        <div class="ehl-cta-box">
            <div class="ehl-cta-content">
                <span class="ehl-cta-label">Don't miss out</span>

                <h2>Ready to book your<br><em>next experience?</em></h2>

                <p>
                    Explore trending events and reserve your seat before they sell out.
                </p>

                <a href="${pageContext.request.contextPath}/event?action=list" class="ehl-btn ehl-btn-primary">
                    <i class="fa-solid fa-arrow-right"></i> Explore Events
                </a>
            </div>
        </div>
    </div>
</section>

<footer class="ehl-footer">
    <div class="ehl-container ehl-footer-grid">
        <div class="ehl-footer-col">
            <h2 class="ehl-footer-logo">⬡ EVENT<span>HORIZON</span></h2>
            <p class="ehl-footer-text">
                EventHorizon helps you discover, explore, and book unforgettable
                experiences with a fast, secure, and modern platform.
            </p>
        </div>

        <div class="ehl-footer-col">
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

        <div class="ehl-footer-col">
            <h4>Company</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/aboutUs.jsp">About Us</a></li>
                <li><a href="${pageContext.request.contextPath}/contacts.jsp">Contact</a></li>
                <li><a href="${pageContext.request.contextPath}/privacyPolicy.jsp">Privacy Policy</a></li>
                <li><a href="${pageContext.request.contextPath}/termsConditions.jsp">Terms &amp; Conditions</a></li>
            </ul>
        </div>

        <div class="ehl-footer-col">
            <h4>Support</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/faqs.jsp">Help Center</a></li>
                <li><a href="${pageContext.request.contextPath}/faqs.jsp">FAQs</a></li>
                <li><a href="${pageContext.request.contextPath}/ticketPolicy.jsp">Ticket Policy</a></li>
                <li><a href="${pageContext.request.contextPath}/IssueServlet?action=report">Report an Issue</a></li>
            </ul>
        </div>
    </div>

    <div class="ehl-footer-bottom">
        <div class="ehl-container ehl-footer-bottom-inner">
            <p>© 2026 EventHorizon. All rights reserved.</p>
            <p>Designed for modern event experiences.</p>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>