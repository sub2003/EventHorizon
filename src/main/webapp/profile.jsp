<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.eventhorizon.service.IssueService" %>

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
                <a href="${pageContext.request.contextPath}/index.jsp" class="eh-nav-link">
                    <i class="fa-solid fa-house"></i><span>Home</span>
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/event?action=list" class="eh-nav-link">
                    <i class="fa-solid fa-calendar-days"></i><span>Events</span>
                </a>
            </li>

            <% if ("CUSTOMER".equals(role)) { %>
                <li>
                    <a href="${pageContext.request.contextPath}/booking?action=myBookings" class="eh-nav-link">
                        <i class="fa-solid fa-ticket"></i><span>My Bookings</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/IssueServlet?action=myIssues" class="eh-nav-bell" title="Issue notifications">
                        <i class="fa-regular fa-bell"></i>
                        <% if (navIssueCount > 0) { %><span class="eh-bell-badge"><%= navIssueCount %></span><% } %>
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
            <% } else if ("ADMIN".equals(role)) { %>
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