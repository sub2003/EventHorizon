<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Register – EventHorizon</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,SOFT,WONK@9..144,600..900,40,0..1&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="css/style.css">
<style>

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
                    <a href="${pageContext.request.contextPath}/register.jsp" class="eh-nav-btn-outline active">
                        <i class="fa-solid fa-user-plus"></i><span>Register</span>
                    </a>
                </li>
            <% } %>
        </ul>
    </div>
</nav>


<div class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-logo">⬡ EVENTHORIZON</div>
        <p class="auth-subtitle">Create your customer account</p>

        <% if ("registerFailed".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" data-auto-dismiss>
                ❌ Registration failed. The email may already exist or some fields may be invalid.
            </div>
        <% } %>

        <% if ("registered".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success" data-auto-dismiss>
                ✅ Your customer account was created successfully. Please sign in.
            </div>
        <% } %>

        <% if ("notAllowed".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" data-auto-dismiss>
                ❌ Admin self-registration is not allowed.
            </div>
        <% } %>

        <form action="user" method="post" class="needs-validation" onsubmit="return validatePasswords();">
            <input type="hidden" name="action" value="register">

            <div class="form-group">
                <label class="form-label" for="name">Full Name</label>
                <input type="text"
                       id="name"
                       name="name"
                       class="form-control"
                       placeholder="John Silva"
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="email">Email Address</label>
                <input type="email"
                       id="email"
                       name="email"
                       class="form-control"
                       placeholder="you@example.com"
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="phone">Phone Number</label>
                <input type="tel"
                       id="phone"
                       name="phone"
                       class="form-control"
                       placeholder="07X XXX XXXX"
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input type="password"
                       id="password"
                       name="password"
                       class="form-control"
                       placeholder="Min 6 characters"
                       required
                       minlength="6">
            </div>

            <div class="form-group">
                <label class="form-label" for="confirmPassword">Confirm Password</label>
                <input type="password"
                       id="confirmPassword"
                       name="confirmPassword"
                       class="form-control"
                       placeholder="Repeat password"
                       required>
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="margin-top:8px;">
                ✨ Create Account
            </button>
        </form>

        <div style="margin-top:18px;padding:12px;border-radius:10px;background:rgba(255,255,255,0.04);color:var(--text-muted);font-size:0.9rem;line-height:1.5;">
            Create a customer account to browse events, book tickets, and manage your bookings securely.
        </div>

        <p style="text-align:center;margin-top:24px;color:var(--text-muted);font-size:0.9rem;">
            Already have an account?
            <a href="login.jsp" style="color:var(--accent-teal);font-weight:600;">Sign in</a>
        </p>

        <p style="text-align:center;margin-top:8px;">
            <a href="index.jsp" style="color:var(--text-muted);font-size:0.85rem;">← Back to Home</a>
        </p>
    </div>
</div>

<script>
    function validatePasswords() {
        const password = document.getElementById("password").value;
        const confirmPassword = document.getElementById("confirmPassword").value;

        if (password !== confirmPassword) {
            alert("Passwords do not match.");
            return false;
        }
        return true;
    }
</script>

<script src="js/main.js"></script>
</body>
</html>