<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String role = (String) session.getAttribute("role");

    int navIssueCount = 0;
    if ("CUSTOMER".equals(role) && session.getAttribute("userId") != null) {
        try {
            String numericPart = String.valueOf(session.getAttribute("userId")).replaceAll("\\D+", "");
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
    <title>My Profile – EventHorizon</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,SOFT,WONK@9..144,600..900,40,0..1&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
        .eh-nav-btn {
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
                    <a href="${pageContext.request.contextPath}/profile.jsp" class="eh-nav-link active">
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
                    <a href="${pageContext.request.contextPath}/profile.jsp" class="eh-nav-link active">
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


<div class="container" style="max-width:700px;padding-top:40px;padding-bottom:60px;">
    <h1 class="page-title" style="margin-bottom:32px;">👤 My Profile</h1>

    <c:if test="${param.msg == 'updated'}">
        <div class="alert alert-success" data-auto-dismiss>
            ✅ Profile updated successfully.
        </div>
    </c:if>

    <c:if test="${param.error == 'updateFailed'}">
        <div class="alert alert-danger" data-auto-dismiss>
            ❌ Update failed. Please try again.
        </div>
    </c:if>

    <c:if test="${param.error == 'deleteFailed'}">
        <div class="alert alert-danger" data-auto-dismiss>
            ❌ Account deletion failed. Please try again.
        </div>
    </c:if>

    <c:if test="${param.error == 'notAllowed'}">
        <div class="alert alert-danger" data-auto-dismiss>
            ❌ You are not allowed to perform that action.
        </div>
    </c:if>

    <div style="background:var(--bg-card);border:1px solid var(--border);border-radius:16px;padding:32px;">
        <div style="text-align:center;margin-bottom:28px;">
            <div style="width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,var(--accent-purple),var(--accent-teal));display:inline-flex;align-items:center;justify-content:center;font-size:2rem;margin-bottom:12px;">
                👤
            </div>

            <div style="font-size:1.1rem;font-weight:700;">
                ${sessionScope.userName}
            </div>

            <div style="color:var(--text-muted);font-size:0.85rem;">
                ${sessionScope.userEmail}
            </div>

            <span class="badge badge-purple" style="margin-top:6px;">
                ${sessionScope.role}
            </span>
        </div>

        <form action="${pageContext.request.contextPath}/user" method="post" class="needs-validation">
            <input type="hidden" name="action" value="update">

            <div class="form-group">
                <label class="form-label" for="name">Full Name</label>
                <input type="text"
                       id="name"
                       name="name"
                       class="form-control"
                       value="${sessionScope.userName}"
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="phone">Phone Number</label>
                <input type="tel"
                       id="phone"
                       name="phone"
                       class="form-control"
                       value="${sessionScope.userPhone}"
                       placeholder="07X XXX XXXX"
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">New Password</label>
                <input type="password"
                       id="password"
                       name="password"
                       class="form-control"
                       placeholder="Enter a new password">
            </div>

            <button type="submit" class="btn btn-primary btn-block">
                💾 Save Changes
            </button>
        </form>
    </div>

    <% if ("CUSTOMER".equals(role)) { %>
    <div style="margin-top:24px;background:rgba(220,53,69,0.08);border:1px solid rgba(220,53,69,0.25);border-radius:16px;padding:24px;">
        <h3 style="margin:0 0 10px 0;color:#dc3545;">⚠ Delete My Account</h3>
        <p style="margin:0 0 18px 0;color:var(--text-muted);line-height:1.6;">
            This action is permanent. Your account and related booking records may be removed and cannot be recovered.
        </p>

        <form action="${pageContext.request.contextPath}/user" method="post"
              onsubmit="return confirm('Are you sure you want to delete your account? This action cannot be undone.');">
            <input type="hidden" name="action" value="selfDelete">

            <button type="submit"
                    class="btn"
                    style="background:#dc3545;color:#ffffff;border:none;padding:12px 22px;border-radius:10px;font-weight:700;cursor:pointer;">
                🗑 Delete My Account
            </button>
        </form>
    </div>
    <% } %>

    <div style="text-align:center;margin-top:24px;">
        <% if ("CUSTOMER".equals(role)) { %>
            <a href="${pageContext.request.contextPath}/booking?action=myBookings" class="btn btn-outline">
                🎟️ View My Bookings
            </a>
        <% } else if ("ADMIN".equals(role)) { %>
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-outline">
                🛠 Go to Dashboard
            </a>
        <% } %>
    </div>
</div>

<footer class="footer">
    <div class="footer-brand">⬡ EVENTHORIZON</div>
    <p>SE1020 – Object Oriented Programming Project &copy; 2026</p>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>