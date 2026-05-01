<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.eventhorizon.service.IssueService" %>

<%
    int ehNavIssueCount = 0;
    String ehNavRole = (String) session.getAttribute("role");
    Object ehNavUserIdObj = session.getAttribute("userId");

    if ("CUSTOMER".equals(ehNavRole) && ehNavUserIdObj != null) {
        try {
            String numericPart = String.valueOf(ehNavUserIdObj).replaceAll("\\D+", "");
            if (!numericPart.isEmpty()) {
                ehNavIssueCount = new IssueService()
                        .countIssuesWithRepliesByUser(Integer.parseInt(numericPart));
            }
        } catch (Exception ignored) {
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | EventHorizon</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,SOFT,WONK@9..144,600..900,40,0..1&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        body {
            background: radial-gradient(circle at top left, #12002f 0%, #050816 42%, #03152a 100%);
            color: #ffffff;
            min-height: 100vh;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .navbar {
            width: 100%;
            padding: 18px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(6, 10, 30, 0.88);
            border-bottom: 1px solid rgba(255,255,255,0.08);
            position: sticky;
            top: 0;
            z-index: 1000;
            backdrop-filter: blur(10px);
        }

        .brand {
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: 1px;
            color: #7c5cff;
        }

        .nav-links {
            display: flex;
            gap: 28px;
            align-items: center;
            flex-wrap: wrap;
        }

        .nav-links a {
            color: #ffffff;
            font-size: 0.95rem;
            font-weight: 600;
            transition: 0.3s;
        }

        .nav-links a:hover {
            color: #53d8fb;
        }

        .page-wrap {
            max-width: 1150px;
            margin: 45px auto;
            padding: 0 20px 40px;
        }

        .hero-card {
            background: linear-gradient(135deg, rgba(20, 27, 61, 0.95), rgba(8, 18, 42, 0.95));
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 24px;
            padding: 38px;
            box-shadow: 0 18px 50px rgba(0,0,0,0.35);
            margin-bottom: 28px;
        }

        .hero-badge {
            display: inline-block;
            padding: 10px 16px;
            border-radius: 999px;
            background: rgba(124, 92, 255, 0.16);
            color: #cfc3ff;
            border: 1px solid rgba(124,92,255,0.28);
            font-size: 0.9rem;
            font-weight: 700;
            margin-bottom: 18px;
        }

        .hero-title {
            font-size: 2.7rem;
            font-weight: 800;
            margin-bottom: 14px;
            color: #ffffff;
            line-height: 1.2;
        }

        .hero-sub {
            color: #b8c4e3;
            font-size: 1rem;
            line-height: 1.8;
            max-width: 900px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
            margin-bottom: 22px;
        }

        .section-card {
            background: linear-gradient(135deg, rgba(17, 25, 58, 0.95), rgba(8, 16, 38, 0.95));
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 22px;
            padding: 28px;
            box-shadow: 0 14px 36px rgba(0,0,0,0.28);
        }

        .section-card.full {
            grid-column: 1 / -1;
        }

        .section-card h2 {
            font-size: 1.45rem;
            margin-bottom: 14px;
            color: #ffffff;
        }

        .section-card p {
            color: #cfd8f2;
            line-height: 1.9;
            font-size: 0.98rem;
            margin-bottom: 12px;
        }

        .section-card ul {
            margin-left: 22px;
            color: #cfd8f2;
            line-height: 1.9;
        }

        .section-card li {
            margin-bottom: 8px;
        }

        .highlight {
            color: #53d8fb;
            font-weight: 700;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-top: 20px;
        }

        .stat-box {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 18px;
            padding: 22px 16px;
            text-align: center;
        }

        .stat-icon {
            font-size: 1.4rem;
            color: #7fe6ff;
            margin-bottom: 10px;
        }

        .stat-number {
            font-size: 1.6rem;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 6px;
        }

        .stat-label {
            font-size: 0.92rem;
            color: #b8c4e3;
        }

        .team-note {
            background: rgba(83, 216, 251, 0.08);
            border: 1px solid rgba(83, 216, 251, 0.18);
            border-radius: 18px;
            padding: 18px;
            margin-top: 14px;
            color: #d8efff;
            line-height: 1.8;
        }

        .footer {
            margin-top: 35px;
            text-align: center;
            color: #9fb0d9;
            font-size: 0.93rem;
            padding: 24px 10px 40px;
        }

        @media (max-width: 992px) {
            .grid {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 14px;
                padding: 18px 20px;
            }

            .nav-links {
                justify-content: center;
                gap: 16px;
            }

            .hero-title {
                font-size: 2rem;
            }

            .hero-card,
            .section-card {
                padding: 22px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }

        /* ================= EVENTHORIZON PREMIUM LIGHT THEME ================= */
        :root {
            --linen: #FAF8F4;
            --paper: #FFFFFF;
            --forest: #1E4A3A;
            --forest-dark: #123528;
            --forest-soft: #E8F1EC;
            --text: #18251F;
            --text-soft: #52635A;
            --muted: #7C8A82;
            --border: rgba(30, 74, 58, 0.14);
            --border-strong: rgba(30, 74, 58, 0.24);
            --shadow-soft: 0 18px 50px rgba(24, 37, 31, 0.09);
        }

        body {
            font-family: 'Inter', sans-serif !important;
            background:
                radial-gradient(circle at top left, rgba(30, 74, 58, 0.08), transparent 32%),
                radial-gradient(circle at top right, rgba(176, 141, 101, 0.10), transparent 30%),
                linear-gradient(180deg, #ffffff 0%, var(--linen) 48%, #F7F3EA 100%) !important;
            color: var(--text) !important;
            overflow-x: hidden;
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
            z-index: -10;
            pointer-events: none;
            background-image:
                radial-gradient(circle at 1px 1px, rgba(30, 74, 58, 0.10) 1.2px, transparent 1.4px),
                linear-gradient(135deg, rgba(30, 74, 58, 0.035) 25%, transparent 25%),
                linear-gradient(45deg, rgba(176, 141, 101, 0.035) 25%, transparent 25%);
            background-size: 34px 34px, 88px 88px, 88px 88px;
            background-position: 0 0, 0 0, 44px 44px;
            opacity: 0.70;
        }

        .eh-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: rgba(250, 248, 244, 0.94) !important;
            border-bottom: 1px solid var(--border) !important;
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            box-shadow: 0 10px 28px rgba(24, 37, 31, 0.05);
        }

        .eh-navbar-inner {
            width: min(92%, 1240px);
            min-height: 76px;
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
            color: var(--forest-dark) !important;
            font-weight: 900;
            letter-spacing: 1.8px;
            text-transform: uppercase;
            text-decoration: none;
        }

        .eh-brand-mark {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            background: linear-gradient(135deg, var(--forest), var(--forest-dark));
            box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24);
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
            margin: 0;
            padding: 0;
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
            font-size: 0.88rem;
            font-weight: 800;
            color: var(--text-soft) !important;
            transition: 0.22s ease;
            white-space: nowrap;
            text-decoration: none;
        }

        .eh-nav-link:hover,
        .eh-nav-link.active {
            color: var(--forest) !important;
            background: var(--forest-soft) !important;
            border-color: var(--border) !important;
        }

        .eh-nav-bell {
            position: relative;
            width: 44px;
            padding: 0;
            background: rgba(255, 255, 255, 0.82) !important;
            border-color: var(--border) !important;
            box-shadow: 0 8px 18px rgba(24, 37, 31, 0.05);
        }

        .eh-nav-bell:hover,
        .eh-nav-bell.active {
            color: var(--forest) !important;
            background: var(--forest-soft) !important;
            border-color: var(--border-strong) !important;
        }

        .eh-bell-badge {
            position: absolute;
            top: -7px;
            right: -7px;
            min-width: 19px;
            height: 19px;
            padding: 0 6px;
            border-radius: 999px;
            background: linear-gradient(135deg, #D94B32, #F08A4C);
            color: #ffffff;
            font-size: 0.64rem;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 18px rgba(217, 75, 50, 0.30);
        }

        .eh-nav-btn {
            color: #ffffff !important;
            background: linear-gradient(135deg, var(--forest), var(--forest-dark)) !important;
            box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24);
        }

        .eh-nav-btn-outline {
            color: var(--forest) !important;
            background: rgba(255, 255, 255, 0.86) !important;
            border-color: var(--border-strong) !important;
        }

        .hero-card,
        .contact-card,
        .policy-card,
        .card,
        .auth-card,
        .ticket-card,
        .notice-box,
        .booking-card,
        .profile-card,
        .checkout-card,
        .summary-card,
        .payment-card,
        .event-card,
        .detail-card,
        .table-card,
        .faq-card,
        .info-card {
            background: rgba(255, 255, 255, 0.96) !important;
            border: 1px solid var(--border) !important;
            box-shadow: var(--shadow-soft) !important;
            color: var(--text) !important;
        }

        h1,
        h2,
        h3,
        .title,
        .page-title,
        .section-title,
        .auth-logo,
        .hero-card h1,
        .hero-card h2 {
            color: var(--forest-dark) !important;
        }

        h1,
        .title,
        .page-title,
        .hero-card h1,
        .hero-card h2 {
            font-family: 'Fraunces', serif !important;
            font-weight: 900 !important;
        }

        p,
        li,
        label,
        td,
        th,
        .muted,
        .breadcrumb,
        .hero-card p,
        .policy-card p,
        .contact-card p {
            color: var(--text-soft) !important;
        }

        input,
        select,
        textarea {
            background: rgba(255, 255, 255, 0.96) !important;
            color: var(--text) !important;
            border: 1px solid var(--border-strong) !important;
        }

        .btn,
        .primary-btn,
        .submit-btn,
        button[type="submit"] {
            background: linear-gradient(135deg, var(--forest), var(--forest-dark)) !important;
            color: #ffffff !important;
            border: 1px solid rgba(30, 74, 58, 0.20) !important;
            box-shadow: 0 14px 30px rgba(30, 74, 58, 0.22) !important;
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
        }
</style>
</head>
<body>


<nav class="eh-navbar">
    <div class="eh-navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="eh-brand">
            <span class="eh-brand-mark"><i class="fa-solid fa-leaf"></i></span>
            <span class="eh-brand-text">EVENTHORIZON</span>
        </a>

        <ul class="eh-nav-links">
            <li>
                <a href="${pageContext.request.contextPath}/index.jsp" class="eh-nav-link">
                    <i class="fa-solid fa-house"></i><span>Home</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/event?action=list" class="eh-nav-link">
                    <i class="fa-solid fa-calendar-days"></i><span>Events</span>
                </a>
            </li>

            <% if (ehNavUserIdObj != null && "CUSTOMER".equals(ehNavRole)) { %>
                <li>
                    <a href="${pageContext.request.contextPath}/booking?action=myBookings" class="eh-nav-link">
                        <i class="fa-solid fa-ticket"></i><span>My Bookings</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/IssueServlet?action=myIssues" class="eh-nav-bell" title="Issue notifications">
                        <i class="fa-regular fa-bell"></i>
                        <% if (ehNavIssueCount > 0) { %>
                            <span class="eh-bell-badge"><%= ehNavIssueCount %></span>
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
            <% } else if (ehNavUserIdObj != null && "ADMIN".equals(ehNavRole)) { %>
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
            <% } else { %>
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
            <% } %>
        </ul>
    </div>
</nav>


<div class="page-wrap">

    <div class="hero-card">
        <div class="hero-badge">Who We Are</div>
        <div class="hero-title">About EventHorizon</div>
        <div class="hero-sub">
            <span class="highlight">EventHorizon</span> is a modern event booking and ticket management platform
            created to make discovering, booking, and managing events simple, secure, and efficient.
            Our system is designed for both customers and administrators, offering a smooth experience for
            browsing events, managing bookings, verifying payments, and handling ticket access through QR-based features.
        </div>

        <div class="stats-grid">
            <div class="stat-box">
                <div class="stat-icon"><i class="fa-solid fa-calendar-days"></i></div>
                <div class="stat-number">Smart</div>
                <div class="stat-label">Event Management</div>
            </div>
            <div class="stat-box">
                <div class="stat-icon"><i class="fa-solid fa-ticket"></i></div>
                <div class="stat-number">Fast</div>
                <div class="stat-label">Ticket Booking</div>
            </div>
            <div class="stat-box">
                <div class="stat-icon"><i class="fa-solid fa-shield-halved"></i></div>
                <div class="stat-number">Secure</div>
                <div class="stat-label">User Experience</div>
            </div>
            <div class="stat-box">
                <div class="stat-icon"><i class="fa-solid fa-qrcode"></i></div>
                <div class="stat-number">Digital</div>
                <div class="stat-label">QR Verification</div>
            </div>
        </div>
    </div>

    <div class="grid">
        <div class="section-card">
            <h2>Our Mission</h2>
            <p>
                Our mission is to provide a reliable and user-friendly platform where people can
                discover exciting events and book tickets with confidence.
            </p>
            <p>
                We focus on combining <span class="highlight">simplicity, speed, and security</span>
                so users can enjoy a better booking experience while administrators can manage events efficiently.
            </p>
        </div>

        <div class="section-card">
            <h2>Our Vision</h2>
            <p>
                We aim to build EventHorizon into a professional and scalable platform that can support
                real-world event organizers, attendees, and administrators.
            </p>
            <p>
                Our vision is to create a system that is not only useful for academic projects,
                but also strong enough to grow into a practical event management solution.
            </p>
        </div>

        <div class="section-card full">
            <h2>What EventHorizon Offers</h2>
            <ul>
                <li>Easy event browsing across multiple categories.</li>
                <li>Customer account creation and profile management.</li>
                <li>Simple booking flow with ticket type selection.</li>
                <li>Manual payment reference submission and approval workflow.</li>
                <li>Admin controls for events, bookings, users, and requests.</li>
                <li>QR-based ticket generation and verification support.</li>
                <li>Issue reporting and customer support features.</li>
            </ul>
        </div>

        <div class="section-card">
            <h2>Why Choose Us</h2>
            <p>
                EventHorizon is built with a clean interface and practical workflow in mind.
                We believe a booking system should feel easy for customers and powerful for administrators.
            </p>
            <p>
                That is why our platform emphasizes organized event control, accurate booking data,
                and a modern digital experience.
            </p>
        </div>

        <div class="section-card">
            <h2>Our Core Values</h2>
            <ul>
                <li><strong>Reliability</strong> – keep event and booking information accurate.</li>
                <li><strong>Security</strong> – protect users, tickets, and system access.</li>
                <li><strong>Usability</strong> – make the platform easy to understand and use.</li>
                <li><strong>Innovation</strong> – improve the experience with modern digital features.</li>
            </ul>
        </div>

        <div class="section-card full">
            <h2>Our Story</h2>
            <p>
                EventHorizon was developed as an event booking web application with the goal of creating
                a polished and meaningful platform for real users. It brings together event browsing,
                ticket handling, payment verification, and admin management into one connected system.
            </p>
            <p>
                The project represents effort, creativity, and continuous improvement toward building
                a professional-quality software solution.
            </p>

            <div class="team-note">
                <strong>EventHorizon</strong> is more than just a booking page — it is a complete
                event experience platform designed to connect users with memorable events through
                a secure and modern system.
            </div>
        </div>

        <div class="section-card full">
            <h2>Contact & Support</h2>
            <p>
                If you have questions, suggestions, or need help using EventHorizon,
                you can contact the support or administrator team through the platform support features.
            </p>
            <p>
                We are committed to improving the platform and making every booking experience smoother and better.
            </p>
        </div>
    </div>

    <div class="footer">
        © 2026 <strong>EventHorizon</strong> · About Us Page
    </div>
</div>

</body>
</html>