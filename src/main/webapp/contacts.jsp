<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | EventHorizon</title>
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
        .contact-card {
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

        .hero-sub,
        .contact-card p,
        .contact-card li {
            color: #d5ddf4;
            line-height: 1.9;
        }

        .contact-card h2 {
            font-size: 1.25rem;
            margin-bottom: 12px;
            color: #7fe6ff;
        }

        .contact-list {
            list-style: none;
            padding: 0;
        }

        .contact-list li {
            margin-bottom: 10px;
        }

        .highlight {
            color: #53d8fb;
            font-weight: 700;
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
            .contact-card {
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
        <div class="hero-title">Contact Us</div>
        <div class="hero-sub">
            Need help with EventHorizon? Reach out for booking support, ticket help, payment clarification, or general assistance.
        </div>
    </div>

    <div class="contact-card">
        <h2>Support Information</h2>
        <ul class="contact-list">
            <li><strong>Email:</strong> support@eventhorizon.com</li>
            <li><strong>Phone:</strong> +94 77 123 4567</li>
            <li><strong>Office Hours:</strong> Monday to Friday, 9:00 AM – 5:00 PM</li>
            <li><strong>Location:</strong> Colombo, Sri Lanka</li>
        </ul>
    </div>

    <div class="contact-card">
        <h2>How to Get Help</h2>
        <p>If you are facing issues with bookings, payment approval, ticket display, QR verification, or your account, please contact the support team or use the system’s issue reporting feature.</p>
    </div>

    <div class="contact-card">
        <h2>For Customers</h2>
        <p>Customers can contact support for booking issues, pending approvals, ticket visibility problems, incorrect payment references, and account-related help.</p>
    </div>

    <div class="contact-card">
        <h2>For Administrators</h2>
        <p>Administrators can contact support for event management concerns, payment review problems, QR verification issues, or system administration support.</p>
    </div>

    <div class="contact-card">
        <h2>Report Through the Platform</h2>
        <p>
            You can also use the platform’s <span class="highlight">Report an Issue</span> feature for direct support requests.
        </p>
    </div>

    <div class="footer">
        © 2026 <strong>EventHorizon</strong> · Contact Page
    </div>
</div>

</body>
</html>