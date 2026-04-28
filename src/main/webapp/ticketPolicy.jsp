<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ticket, Cancellation & Refund Policy | EventHorizon</title>
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
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
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

        .nav-links a:hover,
        .nav-links a.active {
            color: #53d8fb;
        }

        .page-wrap {
            max-width: 1100px;
            margin: 45px auto;
            padding: 0 20px 40px;
        }

        .hero-card,
        .policy-card {
            background: linear-gradient(135deg, rgba(20, 27, 61, 0.95), rgba(8, 18, 42, 0.95));
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 24px;
            box-shadow: 0 18px 50px rgba(0, 0, 0, 0.35);
            margin-bottom: 22px;
        }

        .hero-card {
            padding: 34px 32px;
        }

        .policy-card {
            padding: 28px 30px;
        }

        .policy-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            border-radius: 999px;
            background: rgba(124, 92, 255, 0.16);
            border: 1px solid rgba(124, 92, 255, 0.35);
            color: #c9c2ff;
            font-size: 0.88rem;
            font-weight: 700;
            margin-bottom: 16px;
        }

        .hero-title {
            font-size: 2.45rem;
            font-weight: 800;
            margin-bottom: 12px;
            line-height: 1.15;
        }

        .hero-sub {
            max-width: 860px;
            color: #d5ddf4;
            line-height: 1.9;
            font-size: 1rem;
        }

        .last-updated {
            margin-top: 16px;
            color: #9fb0d9;
            font-size: 0.92rem;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-top: 24px;
        }

        .summary-item {
            padding: 18px;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.045);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }

        .summary-item i {
            color: #7fe6ff;
            margin-bottom: 10px;
            font-size: 1.25rem;
        }

        .summary-item h3 {
            font-size: 0.98rem;
            margin-bottom: 8px;
        }

        .summary-item p {
            color: #b9c6e8;
            line-height: 1.7;
            font-size: 0.92rem;
        }

        .policy-card h2 {
            font-size: 1.25rem;
            margin-bottom: 12px;
            color: #7fe6ff;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .policy-card h2 i {
            font-size: 1rem;
            color: #7c5cff;
        }

        .policy-card p,
        .policy-card li {
            color: #d5ddf4;
            line-height: 1.9;
        }

        .policy-card ul {
            margin-left: 22px;
        }

        .notice-card {
            border-color: rgba(127, 230, 255, 0.26);
            background: linear-gradient(135deg, rgba(11, 39, 70, 0.95), rgba(10, 20, 48, 0.95));
        }

        .footer {
            margin-top: 30px;
            text-align: center;
            color: #9fb0d9;
            font-size: 0.93rem;
            padding: 24px 10px 40px;
        }

        .footer strong {
            color: #ffffff;
        }

        @media (max-width: 900px) {
            .summary-grid {
                grid-template-columns: 1fr;
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
            .policy-card {
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
        <div class="policy-badge">
            <i class="fa-solid fa-shield-halved"></i>
            EventHorizon Policy Center
        </div>

        <div class="hero-title">Ticket, Cancellation & Refund Policy</div>

        <div class="hero-sub">
            Please read the EventHorizon ticket, cancellation, and refund rules carefully before booking,
            submitting payment details, or attending an event. This policy explains how digital tickets,
            QR verification, booking approval, cancellation, rejection, and refund requests are handled
            through the EventHorizon platform.
        </div>

        <div class="last-updated">
            <i class="fa-regular fa-calendar-check"></i>
            Last Updated: April 2026
        </div>

        <div class="summary-grid">
            <div class="summary-item">
                <i class="fa-solid fa-ticket"></i>
                <h3>Digital Tickets</h3>
                <p>Tickets are issued only for approved bookings and are linked to specific events and ticket types.</p>
            </div>

            <div class="summary-item">
                <i class="fa-solid fa-qrcode"></i>
                <h3>QR Verification</h3>
                <p>Only QR codes generated by EventHorizon and verified through the system are accepted.</p>
            </div>

            <div class="summary-item">
                <i class="fa-solid fa-rotate-left"></i>
                <h3>Refund Review</h3>
                <p>Refund requests, where applicable, are reviewed based on booking, payment, and event status.</p>
            </div>
        </div>
    </div>

    <div class="policy-card">
        <h2><i class="fa-solid fa-circle-check"></i>1. Ticket Validity</h2>
        <p>
            Tickets are valid only for the specific event, ticket type, booking, and customer account for which
            they were generated. A ticket cannot be used for a different event, different ticket category,
            different date, or different customer booking.
        </p>
    </div>

    <div class="policy-card">
        <h2><i class="fa-solid fa-user-check"></i>2. Approval Requirement</h2>
        <p>
            Tickets may become visible only after the user submits the required payment reference or payment proof
            and the booking is reviewed and approved by an authorized administrator. Pending bookings do not guarantee
            ticket confirmation or event entry.
        </p>
    </div>

    <div class="policy-card">
        <h2><i class="fa-solid fa-qrcode"></i>3. QR Code Usage</h2>
        <p>
            Each approved ticket may be linked to a QR code for entry verification. Only valid QR codes generated
            by EventHorizon are accepted. External, copied, altered, or unknown QR codes may be rejected by the system
            and treated as invalid.
        </p>
    </div>

    <div class="policy-card">
        <h2><i class="fa-solid fa-user-lock"></i>4. Non-Transferable Use</h2>
        <p>
            Tickets are intended for the original approved booking and should not be misused, forged, duplicated,
            resold, or transferred without authorization. EventHorizon may reject suspicious or duplicated ticket usage.
        </p>
    </div>

    <div class="policy-card">
        <h2><i class="fa-solid fa-circle-exclamation"></i>5. Lost Access or Display Issues</h2>
        <p>
            If an approved ticket does not appear in the customer account, or if a QR code cannot be displayed,
            the customer should contact support immediately or use the issue reporting function within the platform.
            EventHorizon will review the booking and ticket status before taking corrective action.
        </p>
    </div>

    <div class="policy-card">
        <h2><i class="fa-solid fa-ban"></i>6. Cancellation and Rejection</h2>
        <ul>
            <li>Rejected payments may result in booking cancellation.</li>
            <li>Cancelled bookings may invalidate related tickets and QR codes.</li>
            <li>Fraudulent, incorrect, duplicate, or unverifiable payment submissions may lead to booking rejection.</li>
            <li>EventHorizon may cancel bookings that violate platform rules, event rules, or payment verification requirements.</li>
        </ul>
    </div>

    <div class="policy-card">
        <h2><i class="fa-solid fa-door-open"></i>7. Event Entry</h2>
        <p>
            Event entry is subject to valid ticket approval, successful QR verification, event organizer rules,
            venue rules, and any additional security checks required at the event location. A booking record alone
            may not be sufficient for entry unless the ticket is approved and valid.
        </p>
    </div>

    <div class="policy-card">
        <h2><i class="fa-solid fa-chair"></i>8. Seat Availability</h2>
        <p>
            Tickets are subject to seat availability within each event and ticket type category. Once seats are sold out
            or unavailable for a selected ticket type, further booking may not be allowed for that category.
        </p>
    </div>

    <div class="policy-card notice-card">
        <h2><i class="fa-solid fa-money-bill-transfer"></i>9. Refund and Return Policy</h2>
        <p>
            EventHorizon sells digital event tickets. Once a booking is approved and a digital ticket is generated,
            tickets are generally non-returnable and non-refundable unless the event is cancelled by the organizer,
            the payment was made incorrectly or duplicated, or a refund is specifically approved by an authorized administrator.
        </p>
        <br>
        <p>
            If a payment is rejected, incorrect, duplicated, or not verified, the booking may be cancelled and no ticket
            will be issued. Refund requests, where applicable, must be submitted through the platform support channel
            or issue reporting function. Each request will be reviewed based on the event status, booking status,
            payment verification result, ticket generation status, and event organizer rules.
        </p>
    </div>

    <div class="policy-card">
        <h2><i class="fa-solid fa-clock"></i>10. Refund Processing Time</h2>
        <p>
            Approved refund requests may require a reasonable processing period depending on the payment method,
            verification process, and banking or payment gateway timelines. EventHorizon may request additional
            information from the customer before completing a refund review.
        </p>
    </div>

    <div class="policy-card">
        <h2><i class="fa-solid fa-envelope-open-text"></i>11. Customer Responsibility</h2>
        <p>
            Customers are responsible for checking event details, ticket type, quantity, payment details, booking status,
            and ticket status before attending an event. Incorrect information submitted by the customer may delay approval
            or result in booking rejection.
        </p>
    </div>

    <div class="policy-card">
        <h2><i class="fa-solid fa-pen-to-square"></i>12. Policy Changes</h2>
        <p>
            EventHorizon may update this policy when system rules, booking processes, payment verification methods,
            refund handling procedures, or legal requirements change. Updated versions will be published on this page.
        </p>
    </div>

    <div class="footer">
        © 2026 <strong>EventHorizon</strong> · Ticket, Cancellation & Refund Policy Page
    </div>
</div>

</body>
</html>

