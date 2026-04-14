<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHorizon – Book Your Experience</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar">
    <a href="index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>

    <div class="hamburger">
        <span></span><span></span><span></span>
    </div>

    <ul class="navbar-links">
        <li><a href="index.jsp" class="active">Home</a></li>
        <li><a href="event?action=list">Events</a></li>

        <c:choose>
            <c:when test="${not empty sessionScope.userId}">
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <li><a href="admin/dashboard.jsp">Admin Panel</a></li>
                </c:if>
                <li><a href="booking?action=myBookings">My Bookings</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="user?action=logout" class="btn-nav">Logout</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="login.jsp">Login</a></li>
                <li><a href="register.jsp" class="btn-nav">Sign Up</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>

<!-- ===== HERO ===== -->
<section class="hero">
    <div class="hero-content">
        <span class="hero-badge">Premium Event Booking Platform</span>

        <h1 class="hero-title">Experience the<br>Extraordinary</h1>

        <p class="hero-subtitle">
            Discover concerts, sports events, tech summits and cultural shows.
            Book your tickets in seconds with a seamless and secure experience.
        </p>

        <div class="hero-actions">
            <a href="event?action=list" class="btn btn-primary">🎟 Browse Events</a>
            <c:if test="${empty sessionScope.userId}">
                <a href="register.jsp" class="btn btn-outline">Create Account</a>
            </c:if>
        </div>
    </div>
</section>

<!-- ===== FEATURES ===== -->
<section class="features-section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">Why <span>EventHorizon?</span></h2>
            <p class="section-subtitle">
                Built for speed, security, and unforgettable experiences.
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
                <h3>Secure & Safe</h3>
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

<!-- ===== CTA ===== -->
<section class="home-cta">
    <div class="container">
        <div class="cta-box">
            <h2>Ready to book your next experience?</h2>
            <p>Explore trending events and reserve your seat before they sell out.</p>
            <a href="event?action=list" class="btn btn-primary">Explore Events</a>
        </div>
    </div>
</section>

<!-- ===== PREMIUM FOOTER ===== -->
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
                <li><a href="index.jsp">Home</a></li>
                <li><a href="event?action=list">Events</a></li>
                <li><a href="booking?action=myBookings">My Bookings</a></li>
                <li><a href="profile.jsp">Profile</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4>Company</h4>
            <ul>
                <li><a href="#">About Us</a></li>
                <li><a href="#">Contact</a></li>
                <li><a href="#">Privacy Policy</a></li>
                <li><a href="#">Terms & Conditions</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4>Support</h4>
            <ul>
                <li><a href="#">Help Center</a></li>
                <li><a href="#">FAQs</a></li>
                <li><a href="#">Ticket Policy</a></li>
                <li><a href="#">Report an Issue</a></li>
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

<script src="js/main.js"></script>
</body>
</html>