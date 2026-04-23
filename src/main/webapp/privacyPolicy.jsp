<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy | EventHorizon</title>
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
                flex-wrap: wrap;
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
        <a href="index.jsp">Home</a>
        <a href="event?action=list">Events</a>
        <a href="myBookings.jsp">My Bookings</a>
        <a href="profile.jsp">Profile</a>
        <a href="login.jsp">Login</a>
    </div>
</div>

<div class="page-wrap">

    <div class="hero-card">
        <div class="hero-title">Privacy Policy</div>
        <div class="hero-sub">
            This Privacy Policy explains how <span class="highlight">EventHorizon</span> collects, uses,
            stores, and protects user information when you browse events, create an account, make bookings,
            submit payment references, and use ticket verification features in our system.
        </div>
        <div class="last-updated">Last Updated: April 2026</div>
    </div>

    <div class="section-card">
        <h2>1. Information We Collect</h2>
        <p>When you use EventHorizon, we may collect the following types of information:</p>
        <ul>
            <li><strong>Account Information:</strong> name, email address, password, phone number, and user role.</li>
            <li><strong>Booking Information:</strong> booking ID, selected event, ticket type, number of tickets, total amount, booking date, and booking status.</li>
            <li><strong>Payment Details:</strong> payment reference or slip reference submitted for manual payment verification.</li>
            <li><strong>Ticket Information:</strong> ticket ID, QR token, ticket type, event ID, and ticket usage status.</li>
            <li><strong>Event Data:</strong> event title, category, venue, date, time, description, and event images uploaded by administrators.</li>
            <li><strong>Issue Reports:</strong> messages or requests submitted by users for support or issue handling.</li>
        </ul>
    </div>

    <div class="section-card">
        <h2>2. How We Use Your Information</h2>
        <p>Your information is used to operate the EventHorizon platform properly and securely. This includes:</p>
        <ul>
            <li>creating and managing user accounts,</li>
            <li>processing ticket bookings,</li>
            <li>verifying submitted payment references,</li>
            <li>generating and validating digital tickets and QR codes,</li>
            <li>managing events and seat availability,</li>
            <li>responding to support issues and platform-related requests,</li>
            <li>maintaining security, preventing misuse, and improving the system.</li>
        </ul>
    </div>

    <div class="section-card">
        <h2>3. Payment Information</h2>
        <p>
            EventHorizon currently supports <span class="highlight">manual payment verification</span>.
            Users may provide a payment reference or proof details for administrator review.
        </p>
        <p>
            EventHorizon does <strong>not</strong> store bank card numbers, CVV codes, or full online payment credentials
            unless a future secure payment gateway is officially integrated into the platform.
        </p>
    </div>

    <div class="section-card">
        <h2>4. Ticket and QR Code Data</h2>
        <p>
            When a booking is approved, the system may generate ticket records and QR tokens linked to the booking.
            These QR codes are used only for ticket viewing, validation, and entry verification.
        </p>
        <p>
            QR data is handled only for internal event verification purposes and should not be shared publicly by users.
        </p>
    </div>

    <div class="section-card">
        <h2>5. How We Protect Your Data</h2>
        <p>We take reasonable steps to protect your information from unauthorized access, alteration, or misuse. These protections may include:</p>
        <ul>
            <li>restricted access for administrative functions,</li>
            <li>session-based authentication for logged-in users,</li>
            <li>role-based access controls for admins and customers,</li>
            <li>database storage controls and server-side validation.</li>
        </ul>
        <p>
            While we work to protect user data, no online platform can guarantee absolute security at all times.
        </p>
    </div>

    <div class="section-card">
        <h2>6. Data Sharing</h2>
        <p>
            EventHorizon does not sell user personal data to third parties.
            Information may only be accessed by authorized administrators when required for event management,
            payment verification, booking management, customer support, or legal compliance.
        </p>
    </div>

    <div class="section-card">
        <h2>7. Data Retention</h2>
        <p>
            We may retain account records, booking history, payment references, issue reports, and ticket information
            for operational, reporting, and security purposes for as long as reasonably necessary.
        </p>
        <p>
            Cancelled or rejected records may still remain in the system until they are manually removed by authorized administrators.
        </p>
    </div>

    <div class="section-card">
        <h2>8. User Rights</h2>
        <p>Users may have the right to:</p>
        <ul>
            <li>view and update their profile information,</li>
            <li>review their bookings and ticket details,</li>
            <li>request account-related support,</li>
            <li>request deletion or correction of data where platform rules allow.</li>
        </ul>
    </div>

    <div class="section-card">
        <h2>9. Cookies and Session Usage</h2>
        <p>
            EventHorizon may use session data to keep users logged in, manage navigation, and protect restricted pages.
            These sessions help the application function correctly for both customers and administrators.
        </p>
    </div>

    <div class="section-card">
        <h2>10. Changes to This Policy</h2>
        <p>
            This Privacy Policy may be updated when system features, legal requirements, or platform behavior changes.
            Updated versions will be published on this page with a revised update date.
        </p>
    </div>

    <div class="section-card">
        <h2>11. Contact</h2>
        <p>
            If you have questions about this Privacy Policy or your data in EventHorizon, please contact the system administrator
            or support contact provided within the platform.
        </p>
    </div>

    <div class="footer">
        © 2026 <strong>EventHorizon</strong> · Privacy & Data Protection Page
    </div>
</div>

</body>
</html>