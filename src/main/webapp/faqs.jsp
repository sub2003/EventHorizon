<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQs | EventHorizon</title>
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

        .hero-card,
        .faq-card {
            background: linear-gradient(135deg, rgba(20, 27, 61, 0.95), rgba(8, 18, 42, 0.95));
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 24px;
            padding: 30px;
            box-shadow: 0 18px 50px rgba(0,0,0,0.35);
            margin-bottom: 22px;
        }

        .hero-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 12px;
        }

        .hero-sub {
            color: #b8c4e3;
            line-height: 1.8;
        }

        .faq-card h2 {
            font-size: 1.2rem;
            margin-bottom: 12px;
            color: #7fe6ff;
        }

        .faq-card p {
            color: #d5ddf4;
            line-height: 1.9;
        }

        .footer {
            margin-top: 30px;
            text-align: center;
            color: #9fb0d9;
            font-size: 0.93rem;
            padding: 24px 10px 40px;
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
            .faq-card {
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
        <div class="hero-title">Frequently Asked Questions</div>
        <div class="hero-sub">
            Find quick answers about bookings, payments, tickets, QR codes, and using EventHorizon.
        </div>
    </div>

    <div class="faq-card">
        <h2>1. How do I book an event?</h2>
        <p>Open the Events page, select an event, choose your ticket type and quantity, then continue to the booking and payment confirmation process.</p>
    </div>

    <div class="faq-card">
        <h2>2. Is my booking confirmed immediately?</h2>
        <p>No. Bookings may remain pending until the administrator verifies your submitted payment reference or payment proof.</p>
    </div>

    <div class="faq-card">
        <h2>3. How do I know whether my payment is approved?</h2>
        <p>You can check the status from your booking history. Once approved, your booking status and ticket availability will update accordingly.</p>
    </div>

    <div class="faq-card">
        <h2>4. When will I receive my ticket?</h2>
        <p>Tickets become available after payment approval. If your booking is approved, you can open your booking and view the generated ticket details.</p>
    </div>

    <div class="faq-card">
        <h2>5. What is the QR code used for?</h2>
        <p>The QR code is used for ticket verification and event entry checking. Only valid QR codes generated by EventHorizon should be accepted.</p>
    </div>

    <div class="faq-card">
        <h2>6. Can I cancel a booking?</h2>
        <p>Cancellation depends on the current booking status and the platform’s ticket policy. Some bookings may already be processed or approved and may not be reversible.</p>
    </div>

    <div class="faq-card">
        <h2>7. What should I do if I uploaded a wrong payment reference?</h2>
        <p>You should contact support or report the issue through the system as soon as possible so the administrator can review it.</p>
    </div>

    <div class="faq-card">
        <h2>8. Can I edit my profile information?</h2>
        <p>Yes. You can update your profile details from the profile page after logging in.</p>
    </div>

    <div class="faq-card">
        <h2>9. What if tickets are sold out?</h2>
        <p>If the selected ticket type has no available seats left, the system will prevent further booking for that ticket category.</p>
    </div>

    <div class="faq-card">
        <h2>10. How do I report a system problem?</h2>
        <p>You can use the “Report an Issue” option available in the platform to submit a support request.</p>
    </div>

    <div class="footer">
        © 2026 <strong>EventHorizon</strong> · FAQs Page
    </div>
</div>

</body>
</html>