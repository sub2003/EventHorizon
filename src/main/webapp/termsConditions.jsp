<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terms & Conditions | EventHorizon</title>
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
            max-width: 1100px;
            margin: 45px auto;
            padding: 0 20px 40px;
        }

        .hero-card {
            background: linear-gradient(135deg, rgba(20, 27, 61, 0.95), rgba(8, 18, 42, 0.95));
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 24px;
            padding: 34px;
            box-shadow: 0 18px 50px rgba(0,0,0,0.35);
            margin-bottom: 28px;
        }

        .hero-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 12px;
            color: #ffffff;
        }

        .hero-sub {
            color: #b8c4e3;
            font-size: 1rem;
            line-height: 1.7;
        }

        .last-updated {
            display: inline-block;
            margin-top: 18px;
            padding: 10px 16px;
            border-radius: 999px;
            background: rgba(83, 216, 251, 0.12);
            color: #7fe6ff;
            border: 1px solid rgba(83, 216, 251, 0.25);
            font-size: 0.92rem;
            font-weight: 700;
        }

        .section-card {
            background: linear-gradient(135deg, rgba(17, 25, 58, 0.95), rgba(8, 16, 38, 0.95));
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 22px;
            padding: 28px;
            margin-bottom: 22px;
            box-shadow: 0 14px 36px rgba(0,0,0,0.28);
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

        .footer {
            margin-top: 35px;
            text-align: center;
            color: #9fb0d9;
            font-size: 0.93rem;
            padding: 24px 10px 40px;
        }

        .footer a {
            color: #7fe6ff;
            font-weight: 600;
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
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="brand">EVENTHORIZON</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/event?action=list">Events</a>
        <a href="${pageContext.request.contextPath}/booking?action=myBookings">My Bookings</a>
        <a href="${pageContext.request.contextPath}/profile.jsp">Profile</a>
        <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
    </div>
</div>

<div class="page-wrap">

    <div class="hero-card">
        <div class="hero-title">Terms &amp; Conditions</div>
        <div class="hero-sub">
            These Terms &amp; Conditions govern the use of <span class="highlight">EventHorizon</span>.
            By accessing the platform, creating an account, booking tickets, or using administrator features,
            you agree to follow the rules and responsibilities described on this page.
        </div>
        <div class="last-updated">Last Updated: April 2026</div>
    </div>

    <div class="section-card">
        <h2>1. Acceptance of Terms</h2>
        <p>
            By using EventHorizon, you agree to these Terms &amp; Conditions. If you do not agree with any part of these terms,
            you should not use the platform.
        </p>
    </div>

    <div class="section-card">
        <h2>2. Platform Purpose</h2>
        <p>
            EventHorizon is an event booking and ticket management system designed to allow users to browse events,
            create accounts, book tickets, submit payment references, and access approved tickets and QR verification features.
        </p>
    </div>

    <div class="section-card">
        <h2>3. User Accounts</h2>
        <ul>
            <li>Users are responsible for providing correct registration information.</li>
            <li>Users are responsible for maintaining the confidentiality of their login credentials.</li>
            <li>Users must not impersonate another person or create misleading accounts.</li>
            <li>Administrators may suspend or remove accounts that violate system rules or misuse the platform.</li>
        </ul>
    </div>

    <div class="section-card">
        <h2>4. Bookings and Payments</h2>
        <p>
            Event bookings made through EventHorizon are subject to event availability, administrator review,
            and payment verification where applicable.
        </p>
        <ul>
            <li>Submitting a booking request does not automatically guarantee final approval.</li>
            <li>Manual payment reference details must be accurate and valid.</li>
            <li>False, misleading, or duplicate payment submissions may result in booking rejection.</li>
            <li>Approved bookings may generate ticket records and QR-based verification access.</li>
        </ul>
    </div>

    <div class="section-card">
        <h2>5. Ticket Usage</h2>
        <ul>
            <li>Tickets are intended only for the approved booking and registered user.</li>
            <li>Generated QR codes must not be altered, duplicated, or used fraudulently.</li>
            <li>External or fake QR codes may be rejected during verification.</li>
            <li>Used, invalid, cancelled, or rejected tickets may not be accepted for entry.</li>
        </ul>
    </div>

    <div class="section-card">
        <h2>6. Event Management</h2>
        <p>
            Administrators may add, update, cancel, or manage events and ticket categories according to system permissions.
            Event details such as venue, time, category, ticket types, pricing, and available seats may change when necessary.
        </p>
    </div>

    <div class="section-card">
        <h2>7. Cancellations and Refunds</h2>
        <p>
            Booking cancellations, payment rejections, or event cancellations may affect ticket validity.
            Refund handling, if provided, depends on administrator decisions, event rules, and payment verification outcomes.
        </p>
        <p>
            EventHorizon may mark cancelled or rejected bookings accordingly and restrict access to related tickets.
        </p>
    </div>

    <div class="section-card">
        <h2>8. Prohibited Activities</h2>
        <ul>
            <li>Attempting unauthorized access to admin-only pages or protected records.</li>
            <li>Submitting false payment proofs or fake booking information.</li>
            <li>Trying to manipulate ticket verification or QR-based entry.</li>
            <li>Uploading harmful, illegal, or misleading content to the platform.</li>
            <li>Interfering with system operation, security, or data integrity.</li>
        </ul>
    </div>

    <div class="section-card">
        <h2>9. Data and Privacy</h2>
        <p>
            Use of EventHorizon is also subject to the platform’s Privacy Policy. By using the system,
            you understand that account details, booking data, ticket information, payment references,
            and issue reports may be stored and processed for operational purposes.
        </p>
    </div>

    <div class="section-card">
        <h2>10. Availability and Changes</h2>
        <p>
            EventHorizon may be updated, modified, or temporarily unavailable due to maintenance,
            feature changes, security requirements, or technical issues.
        </p>
        <p>
            We reserve the right to change, improve, restrict, or remove parts of the platform at any time when necessary.
        </p>
    </div>

    <div class="section-card">
        <h2>11. Limitation of Responsibility</h2>
        <p>
            EventHorizon aims to provide a reliable booking experience, but we do not guarantee uninterrupted access at all times.
            We are not responsible for losses caused by incorrect user submissions, internet issues, third-party service failures,
            or misuse of accounts and tickets.
        </p>
    </div>

    <div class="section-card">
        <h2>12. Termination</h2>
        <p>
            Accounts, bookings, or access permissions may be limited, suspended, or terminated if a user or administrator
            violates these terms, abuses system functionality, or compromises platform security.
        </p>
    </div>

    <div class="section-card">
        <h2>13. Contact</h2>
        <p>
            If you have questions regarding these Terms &amp; Conditions, please contact the system administrator
            or support contact available within the EventHorizon platform.
        </p>
    </div>

    <div class="footer">
        © 2026 <strong>EventHorizon</strong> · Terms &amp; Conditions Page
    </div>
</div>

</body>
</html>