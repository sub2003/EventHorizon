<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhorizon.service.IssueService" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue Messages - EventHorizon</title>
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
    <style>
        :root {
            --bg: #050816;
            --surface: #0b1431;
            --card: #09112a;
            --border: rgba(126,93,255,0.18);
            --muted: #9ba8d8;
            --text: #eef2ff;
            --accent: #7c5cff;
            --accent2: #2bc0ff;
            --success: #00b894;
            --danger: #ff7b54;
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--text);
            font-family: Arial, sans-serif;
        }

        .page-wrap {
            width: min(92%, 1200px);
            margin: 34px auto 60px;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--muted);
            text-decoration: none;
            margin-bottom: 18px;
            font-weight: 700;
        }

        .back-link:hover { color: #fff; }

        .page-title {
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 18px;
        }

        .top-tags {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .tag, .status-tag {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 12px;
            border-radius: 999px;
            font-size: 0.8rem;
            font-weight: 800;
        }

        .tag {
            background: rgba(124,92,255,0.14);
            color: #c4b5fd;
            border: 1px solid rgba(124,92,255,0.22);
        }

        .status-tag.open { background: rgba(255,123,84,0.14); color: #ffb199; }
        .status-tag.progress { background: rgba(255,193,7,0.14); color: #ffd66b; }
        .status-tag.resolved { background: rgba(0,184,148,0.14); color: #7ef0c8; }
        .status-tag.rejected { background: rgba(160,160,160,0.16); color: #d0d0d0; }

        .layout {
            display: grid;
            grid-template-columns: 1.3fr 0.7fr;
            gap: 24px;
        }

        @media (max-width: 950px) {
            .layout { grid-template-columns: 1fr; }
        }

        .card {
            background: linear-gradient(180deg, var(--surface), var(--card));
            border: 1px solid var(--border);
            border-radius: 22px;
            padding: 24px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.22);
            margin-bottom: 22px;
        }

        .card h3 {
            margin: 0 0 16px 0;
            font-size: 1.08rem;
            font-weight: 800;
        }

        .meta-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 18px;
        }

        @media (max-width: 640px) {
            .meta-grid { grid-template-columns: 1fr; }
        }

        .meta-item small {
            display: block;
            color: var(--muted);
            margin-bottom: 5px;
            font-size: 0.76rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .meta-item div {
            font-weight: 700;
            line-height: 1.5;
        }

        .desc-box {
            background: rgba(0,0,0,0.18);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 14px;
            padding: 16px;
            white-space: pre-wrap;
            line-height: 1.7;
        }

        .reply-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .reply-item {
            background: rgba(0,0,0,0.18);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 16px;
            padding: 16px;
        }

        .reply-head {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }

        .reply-author {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 800;
        }

        .reply-avatar {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 0.84rem;
            font-weight: 800;
        }

        .reply-time {
            font-size: 0.78rem;
            color: var(--muted);
        }

        .reply-body {
            line-height: 1.7;
            white-space: pre-wrap;
        }

        .empty-replies {
            color: var(--muted);
            text-align: center;
            padding: 24px;
            border: 1px dashed rgba(255,255,255,0.08);
            border-radius: 14px;
        }

        .side-note {
            color: var(--muted);
            line-height: 1.7;
            font-size: 0.94rem;
        }
    </style>
</head>
<body>
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
<nav class="eh-navbar">
    <div class="eh-navbar-inner">
        <a href="${pageContext.request.contextPath}/index.jsp" class="eh-brand">
            <i class="fa-regular fa-hexagon"></i>
            <span>EVENTHORIZON</span>
        </a>

        <ul class="eh-nav-links">
            <li><a href="${pageContext.request.contextPath}/index.jsp" class="eh-nav-link "><i class="fa-solid fa-house"></i><span>Home</span></a></li>
            <li><a href="${pageContext.request.contextPath}/event?action=list" class="eh-nav-link "><i class="fa-solid fa-calendar-days"></i><span>Events</span></a></li>
            <li><a href="${pageContext.request.contextPath}/booking?action=myBookings" class="eh-nav-link "><i class="fa-solid fa-ticket"></i><span>My Bookings</span></a></li>
            <li>
                <a href="${pageContext.request.contextPath}/IssueServlet?action=myIssues" class="eh-nav-bell active" title="Issue notifications">
                    <i class="fa-regular fa-bell"></i>
                    <% if (navIssueCount > 0) { %><span class="eh-bell-badge"><%= navIssueCount %></span><% } %>
                </a>
            </li>
            <li><a href="${pageContext.request.contextPath}/profile.jsp" class="eh-nav-link "><i class="fa-regular fa-user"></i><span>Profile</span></a></li>
            <li><a href="${pageContext.request.contextPath}/user?action=logout" class="eh-nav-btn"><i class="fa-solid fa-right-from-bracket"></i><span>Logout</span></a></li>
        </ul>
    </div>
</nav>
<div class="page-wrap">
    <a href="${pageContext.request.contextPath}/IssueServlet?action=myIssues" class="back-link">
        <i class="fa-solid fa-arrow-left"></i> Back to support
    </a>

    <div class="page-title">Issue Messages #${issue.issueId}</div>

    <div class="top-tags">
        <span class="tag">${issue.category}</span>
        <c:choose>
            <c:when test="${issue.status == 'OPEN'}"><span class="status-tag open">Open</span></c:when>
            <c:when test="${issue.status == 'IN_PROGRESS'}"><span class="status-tag progress">In Progress</span></c:when>
            <c:when test="${issue.status == 'RESOLVED'}"><span class="status-tag resolved">Resolved</span></c:when>
            <c:otherwise><span class="status-tag rejected">Rejected</span></c:otherwise>
        </c:choose>
    </div>

    <div class="layout">
        <div>
            <div class="card">
                <h3>${issue.subject}</h3>
                <div class="meta-grid">
                    <div class="meta-item">
                        <small>Submitted On</small>
                        <div><fmt:formatDate value="${issue.createdAt}" pattern="dd MMM yyyy, hh:mm a" /></div>
                    </div>
                    <div class="meta-item">
                        <small>Status</small>
                        <div>${issue.status}</div>
                    </div>
                    <c:if test="${issue.bookingId != null}">
                        <div class="meta-item">
                            <small>Booking ID</small>
                            <div>#${issue.bookingId}</div>
                        </div>
                    </c:if>
                    <c:if test="${issue.ticketId != null}">
                        <div class="meta-item">
                            <small>Ticket ID</small>
                            <div>#${issue.ticketId}</div>
                        </div>
                    </c:if>
                </div>

                <div class="desc-box">${issue.description}</div>
            </div>

            <div class="card">
                <h3><i class="fa-regular fa-comments"></i> Admin Replies</h3>
                <c:choose>
                    <c:when test="${not empty issue.replies}">
                        <div class="reply-list">
                            <c:forEach var="reply" items="${issue.replies}">
                                <div class="reply-item">
                                    <div class="reply-head">
                                        <div class="reply-author">
                                            <span class="reply-avatar">${reply.adminName.substring(0,1).toUpperCase()}</span>
                                            <span>${reply.adminName}</span>
                                        </div>
                                        <div class="reply-time">
                                            <fmt:formatDate value="${reply.repliedAt}" pattern="dd MMM yyyy, hh:mm a" />
                                        </div>
                                    </div>
                                    <div class="reply-body">${reply.replyMessage}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-replies">
                            No admin replies yet. When support answers, the message will appear here and in your navbar bell.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div>
            <div class="card">
                <h3><i class="fa-regular fa-circle-question"></i> Support Summary</h3>
                <div class="meta-grid" style="grid-template-columns:1fr;">
                    <div class="meta-item">
                        <small>Customer Email</small>
                        <div>${issue.customerEmail}</div>
                    </div>
                    <c:if test="${not empty issue.customerPhone}">
                        <div class="meta-item">
                            <small>Phone</small>
                            <div>${issue.customerPhone}</div>
                        </div>
                    </c:if>
                    <div class="meta-item">
                        <small>Assigned Team</small>
                        <div>${issue.assignedAdminType.replace('_', ' ')}</div>
                    </div>
                </div>
            </div>

            <div class="card">
                <h3><i class="fa-solid fa-bell"></i> Notifications</h3>
                <p class="side-note">
                    The bell in your navbar shows how many support requests already have admin replies.
                    Click the bell anytime to come back to your issue list and open the latest messages.
                </p>
            </div>
        </div>
    </div>
</div>
</body>
</html>
