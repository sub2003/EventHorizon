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
    <title>EventHorizon – Book Your Experience</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .eh-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: linear-gradient(90deg, #060b1f, #0b1434);
            border-bottom: 1px solid rgba(130, 90, 255, 0.22);
            backdrop-filter: blur(12px);
        }

        .eh-navbar-inner {
            width: min(94%, 1400px);
            margin: 0 auto;
            padding: 16px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        .eh-brand {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: #e8ecff;
            font-weight: 800;
            letter-spacing: 0.6px;
            font-size: 1.55rem;
        }

        .eh-brand i {
            color: #7c5cff;
            font-size: 1.1rem;
        }

        .eh-nav-links {
            list-style: none;
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            padding: 0;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .eh-nav-links li {
            list-style: none;
        }

        .eh-nav-link,
        .eh-nav-bell,
        .eh-nav-btn,
        .eh-nav-btn-outline {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 40px;
            padding: 10px 14px;
            border-radius: 12px;
            text-decoration: none;
            font-size: 0.92rem;
            font-weight: 700;
            transition: 0.22s ease;
            border: 1px solid transparent;
        }

        .eh-nav-link {
            color: #d9defa;
        }

        .eh-nav-link:hover {
            color: #ffffff;
            background: rgba(255,255,255,0.05);
        }

        .eh-nav-link.active {
            color: #ffffff;
            background: linear-gradient(135deg, rgba(124,92,255,0.24), rgba(43,192,255,0.18));
            border-color: rgba(124,92,255,0.28);
            box-shadow: 0 8px 20px rgba(124,92,255,0.12);
        }

        .eh-nav-bell {
            position: relative;
            color: #d9defa;
            width: 42px;
            padding: 0;
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.08);
        }

        .eh-nav-bell:hover,
        .eh-nav-bell.active {
            color: #ffffff;
            border-color: rgba(124,92,255,0.35);
            background: linear-gradient(135deg, rgba(124,92,255,0.24), rgba(43,192,255,0.18));
            box-shadow: 0 8px 18px rgba(124,92,255,0.14);
        }

        .eh-nav-bell i {
            font-size: 1rem;
        }

        .eh-bell-badge {
            position: absolute;
            top: -6px;
            right: -6px;
            min-width: 18px;
            height: 18px;
            padding: 0 5px;
            border-radius: 999px;
            background: linear-gradient(135deg, #ff5d73, #ff7b54);
            color: #fff;
            font-size: 0.68rem;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 6px 14px rgba(255,93,115,0.3);
        }

        .eh-nav-btn {
            color: #ffffff;
            background: linear-gradient(135deg, #7c5cff, #9b6bff);
            box-shadow: 0 10px 20px rgba(124,92,255,0.18);
        }

        .eh-nav-btn:hover {
            transform: translateY(-1px);
            opacity: 0.95;
        }

        .eh-nav-btn-outline {
            color: #8fdcff;
            border-color: rgba(67, 206, 255, 0.35);
            background: rgba(67, 206, 255, 0.08);
        }

        .eh-nav-btn-outline:hover {
            color: #ffffff;
            border-color: rgba(67, 206, 255, 0.55);
            background: rgba(67, 206, 255, 0.16);
        }

        .hero {
            background:
                linear-gradient(90deg, rgba(4, 8, 25, 0.92), rgba(8, 14, 42, 0.78), rgba(10, 18, 52, 0.60)),
                url("https://images.unsplash.com/photo-1492684223066-81342ee5ff30a?auto=format&fit=crop&w=1920&q=90");
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        @media (max-width: 900px) {
            .eh-navbar-inner {
                flex-direction: column;
                align-items: stretch;
            }

            .eh-nav-links {
                justify-content: center;
            }

            .eh-brand {
                justify-content: center;
            }
        }
    </style>
</head>
<body>

<nav class="eh-navbar">
    <div class="eh-navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="eh-brand">
            <i class="fa-regular fa-hexagon"></i>
            <span>EVENTHORIZON</span>
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

<section class="hero">
    <div class="hero-content">
        <span class="hero-badge">Premium Event Booking Platform</span>

        <h1 class="hero-title">Experience the<br>Extraordinary</h1>

        <p class="hero-subtitle">
            Discover concerts, sports events, tech summits and cultural shows.
            Book your tickets in seconds with a seamless and secure experience.
        </p>

        <div class="hero-actions">
            <a href="${pageContext.request.contextPath}/event?action=list" class="btn btn-primary">🎟 Browse Events</a>
            <c:if test="${empty sessionScope.userId}">
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline">Create Account</a>
            </c:if>
            <c:if test="${not empty sessionScope.userId}">
                <a href="${pageContext.request.contextPath}/IssueServlet?action=report" class="btn btn-outline">Report an Issue</a>
            </c:if>
        </div>
    </div>
</section>

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
                <h3>Secure &amp; Safe</h3>
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

<section class="home-cta">
    <div class="container">
        <div class="cta-box">
            <h2>Ready to book your next experience?</h2>
            <p>Explore trending events and reserve your seat before they sell out.</p>
            <a href="${pageContext.request.contextPath}/event?action=list" class="btn btn-primary">Explore Events</a>
        </div>
    </div>
</section>

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

        <div class="footer-col">
            <h4>Company</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/aboutUs.jsp">About Us</a></li>
                <li><a href="${pageContext.request.contextPath}/contacts.jsp">Contact</a></li>
                <li><a href="${pageContext.request.contextPath}/privacyPolicy.jsp">Privacy Policy</a></li>
                <li><a href="${pageContext.request.contextPath}/termsConditions.jsp">Terms &amp; Conditions</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4>Support</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/faqs.jsp">Help Center</a></li>
                <li><a href="${pageContext.request.contextPath}/faqs.jsp">FAQs</a></li>
                <li><a href="${pageContext.request.contextPath}/ticketPolicy.jsp">Ticket Policy</a></li>
                <li><a href="${pageContext.request.contextPath}/IssueServlet?action=report">Report an Issue</a></li>
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

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>