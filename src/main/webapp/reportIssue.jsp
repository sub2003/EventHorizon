<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.eventhorizon.service.IssueService" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Report an Issue — EventHorizon Support</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
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
            --bg:        #0b0d12;
            --surface:   #12151d;
            --card:      #181c26;
            --border:    #262c3e;
            --accent:    #6c5ce7;
            --accent2:   #00cec9;
            --danger:    #e17055;
            --success:   #00b894;
            --text:      #e8ecf4;
            --muted:     #7b859e;
            --radius:    14px;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }

        body {
            font-family: 'Sora', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* ── NAV ─────────────────────────────────────────────── */
        nav {
            display: flex; align-items: center; justify-content: space-between;
            padding: 18px 48px;
            background: rgba(11,13,18,0.85);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            position: sticky; top: 0; z-index: 100;
        }
        .nav-logo { font-size: 1.4rem; font-weight: 700; color: var(--accent); letter-spacing: -0.5px; }
        .nav-logo span { color: var(--accent2); }
        .nav-links a {
            color: var(--muted); text-decoration: none; margin-left: 28px;
            font-size: 0.9rem; transition: color .2s;
        }
        .nav-links a:hover { color: var(--text); }
        .nav-links a.active { color: var(--accent2); }

        /* ── HERO ─────────────────────────────────────────────── */
        .hero {
            text-align: center;
            padding: 72px 24px 48px;
            position: relative;
        }
        .hero::before {
            content: '';
            position: absolute; top: 0; left: 50%; transform: translateX(-50%);
            width: 600px; height: 300px;
            background: radial-gradient(ellipse, rgba(108,92,231,.18) 0%, transparent 70%);
            pointer-events: none;
        }
        .hero-badge {
            display: inline-flex; align-items: center; gap: 8px;
            background: rgba(108,92,231,.12); border: 1px solid rgba(108,92,231,.3);
            color: #a29bfe; padding: 6px 16px; border-radius: 100px;
            font-size: .78rem; font-weight: 600; letter-spacing: .5px;
            margin-bottom: 20px;
        }
        .hero h1 { font-size: clamp(2rem,5vw,3.2rem); font-weight: 700; line-height: 1.15; margin-bottom: 14px; }
        .hero h1 span { color: var(--accent2); }
        .hero p { color: var(--muted); max-width: 520px; margin: 0 auto; line-height: 1.7; }

        /* ── LAYOUT ───────────────────────────────────────────── */
        .page-wrap {
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 28px;
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 24px 80px;
        }
        @media (max-width: 860px) { .page-wrap { grid-template-columns: 1fr; } }

        /* ── CARD ─────────────────────────────────────────────── */
        .card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 32px;
        }
        .card-title {
            font-size: 1.05rem; font-weight: 600; margin-bottom: 24px;
            display: flex; align-items: center; gap: 10px; color: var(--text);
        }
        .card-title i { color: var(--accent); font-size: .95rem; }

        /* ── FORM ─────────────────────────────────────────────── */
        .form-group { margin-bottom: 20px; }
        label { display: block; font-size: .82rem; font-weight: 500; color: var(--muted); margin-bottom: 8px; letter-spacing: .3px; }
        label span.req { color: var(--danger); margin-left: 3px; }

        input[type="text"], input[type="email"], input[type="tel"],
        input[type="number"], select, textarea {
            width: 100%; background: var(--surface);
            border: 1px solid var(--border); border-radius: 10px;
            color: var(--text); padding: 12px 14px;
            font-family: 'Sora', sans-serif; font-size: .9rem;
            transition: border-color .2s, box-shadow .2s;
        }
        input:focus, select:focus, textarea:focus {
            outline: none; border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(108,92,231,.15);
        }
        select option { background: var(--surface); }
        textarea { resize: vertical; min-height: 120px; }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        @media (max-width: 540px) { .form-row { grid-template-columns: 1fr; } }

        /* priority pills */
        .priority-group { display: flex; gap: 10px; flex-wrap: wrap; }
        .priority-btn {
            flex: 1; padding: 10px; border-radius: 10px; cursor: pointer;
            border: 1.5px solid var(--border); background: var(--surface);
            color: var(--muted); font-family: 'Sora', sans-serif; font-size: .84rem;
            font-weight: 500; text-align: center; transition: all .2s;
        }
        .priority-btn:hover { border-color: var(--accent); color: var(--text); }
        .priority-btn.selected-low    { border-color: var(--accent2); color: var(--accent2); background: rgba(0,206,201,.08); }
        .priority-btn.selected-medium { border-color: #fdcb6e; color: #fdcb6e; background: rgba(253,203,110,.08); }
        .priority-btn.selected-high   { border-color: var(--danger); color: var(--danger); background: rgba(225,112,85,.08); }
        input[name="priority"] { display: none; }

        /* submit btn */
        .btn-submit {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, var(--accent), #8e7cf5);
            border: none; border-radius: 12px; color: #fff;
            font-family: 'Sora', sans-serif; font-size: 1rem; font-weight: 600;
            cursor: pointer; margin-top: 8px;
            display: flex; align-items: center; justify-content: center; gap: 10px;
            transition: opacity .2s, transform .15s;
        }
        .btn-submit:hover { opacity: .9; transform: translateY(-1px); }
        .btn-submit:active { transform: translateY(0); }

        /* ── CATEGORY TAG ─────────────────────────────────────── */
        .routing-hint {
            font-size: .75rem; color: var(--muted);
            margin-top: 6px; display: flex; align-items: center; gap: 5px;
        }
        .routing-hint .chip {
            background: rgba(108,92,231,.15); color: #a29bfe;
            border-radius: 100px; padding: 2px 10px; font-size: .72rem; font-weight: 600;
        }

        /* ── ALERTS ───────────────────────────────────────────── */
        .alert {
            padding: 14px 18px; border-radius: 10px; margin-bottom: 22px;
            font-size: .88rem; display: flex; align-items: flex-start; gap: 12px;
        }
        .alert-success { background: rgba(0,184,148,.1); border: 1px solid rgba(0,184,148,.3); color: #55efc4; }
        .alert-error   { background: rgba(225,112,85,.1);  border: 1px solid rgba(225,112,85,.3);  color: #fab1a0; }
        .alert i { margin-top: 1px; }

        /* ── SIDEBAR ──────────────────────────────────────────── */
        .contact-section { display: flex; flex-direction: column; gap: 20px; }

        .contact-card {
            background: var(--card); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 22px;
        }
        .contact-card h3 {
            font-size: .88rem; font-weight: 600; margin-bottom: 16px;
            color: var(--muted); text-transform: uppercase; letter-spacing: .8px;
        }
        .contact-item {
            display: flex; align-items: flex-start; gap: 12px;
            padding: 12px 0; border-bottom: 1px solid var(--border);
        }
        .contact-item:last-child { border-bottom: none; padding-bottom: 0; }
        .contact-icon {
            width: 36px; height: 36px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: .85rem; flex-shrink: 0;
        }
        .icon-purple { background: rgba(108,92,231,.18); color: #a29bfe; }
        .icon-teal   { background: rgba(0,206,201,.15);  color: var(--accent2); }
        .icon-green  { background: rgba(0,184,148,.15);  color: var(--success); }
        .icon-orange { background: rgba(225,112,85,.15); color: var(--danger); }

        .contact-info small { display: block; font-size: .73rem; color: var(--muted); margin-bottom: 2px; }
        .contact-info a, .contact-info span { font-size: .85rem; color: var(--text); text-decoration: none; font-weight: 500; }
        .contact-info a:hover { color: var(--accent2); }

        /* emergency */
        .emergency-card {
            background: linear-gradient(135deg, rgba(225,112,85,.12), rgba(108,92,231,.1));
            border: 1px solid rgba(225,112,85,.25); border-radius: var(--radius); padding: 22px;
        }
        .emergency-card h3 { color: var(--danger); font-size: .88rem; margin-bottom: 14px;
            display: flex; align-items: center; gap: 8px; }

        /* categories guide */
        .cat-guide { display: flex; flex-direction: column; gap: 8px; }
        .cat-row {
            display: flex; align-items: center; gap: 10px;
            font-size: .8rem; color: var(--muted); padding: 8px 10px;
            background: var(--surface); border-radius: 8px;
        }
        .cat-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
        .cat-row strong { color: var(--text); font-weight: 500; }

        /* ── FOOTER ───────────────────────────────────────────── */
        footer {
            text-align: center; padding: 28px; border-top: 1px solid var(--border);
            color: var(--muted); font-size: .8rem;
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

<!-- NAV -->
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

    <div class="nav-logo">Event<span>Horizon</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/events.jsp">Events</a>
        <a href="${pageContext.request.contextPath}/myBookings.jsp">My Bookings</a>
        <a href="${pageContext.request.contextPath}/IssueServlet?action=report" class="active">Support</a>
    </div>
</nav>

<!-- HERO -->
<div class="hero">
    <div class="hero-badge"><i class="fas fa-headset"></i> EventHorizon Support Center</div>
    <h1>Report an <span>Issue</span></h1>
    <p>Having trouble with a booking, payment, or event? Fill in the form below and we'll route your issue directly to the right team.</p>
</div>

<!-- MAIN -->
<div class="page-wrap">

    <!-- LEFT: FORM -->
    <div>
        <!-- Alerts -->
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${sessionScope.successMsg}</span>
            </div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span>${sessionScope.errorMsg}</span>
            </div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="card">
            <div class="card-title"><i class="fas fa-file-alt"></i> Submit Your Issue</div>

            <form action="${pageContext.request.contextPath}/IssueServlet" method="post" id="issueForm">
                <input type="hidden" name="action" value="submit" />

                <!-- Category -->
                <div class="form-group">
                    <label>Issue Category <span class="req">*</span></label>
                    <select name="category" id="categorySelect" required onchange="updateRouting()">
                        <option value="" disabled selected>— Select a category —</option>
                        <optgroup label="📦 Booking &amp; Payments">
                            <option value="Booking Problem">Booking Problem</option>
                            <option value="Payment Verification Issue">Payment Verification Issue</option>
                            <option value="Ticket Not Received">Ticket Not Received</option>
                            <option value="QR Code Not Working">QR Code Not Working</option>
                            <option value="Refund Request">Refund Request</option>
                            <option value="Seat Availability Problem">Seat Availability Problem</option>
                        </optgroup>
                        <optgroup label="🎪 Events">
                            <option value="Event Information Error">Event Information Error</option>
                            <option value="Event Cancellation Complaint">Event Cancellation Complaint</option>
                        </optgroup>
                        <optgroup label="👤 Account &amp; Technical">
                            <option value="Account Login Problem">Account Login Problem</option>
                            <option value="Profile / Registration Problem">Profile / Registration Problem</option>
                            <option value="Website Technical Issue">Website Technical Issue</option>
                        </optgroup>
                        <optgroup label="💬 General">
                            <option value="General Inquiry">General Inquiry</option>
                            <option value="Other">Other</option>
                        </optgroup>
                    </select>
                    <div class="routing-hint" id="routingHint" style="display:none;">
                        <i class="fas fa-arrow-right" style="font-size:.7rem;"></i>
                        Will be routed to: <span class="chip" id="routingLabel"></span>
                    </div>
                </div>

                <!-- Subject -->
                <div class="form-group">
                    <label>Subject <span class="req">*</span></label>
                    <input type="text" name="subject" placeholder="Brief title of your issue" required maxlength="255" />
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label>Description <span class="req">*</span></label>
                    <textarea name="description" placeholder="Please describe your issue in detail — what happened, when, and any steps you have already tried." required></textarea>
                </div>

                <!-- Reference IDs -->
                <div class="form-row">
                    <div class="form-group">
                        <label>Booking ID <span style="color:var(--muted);font-size:.75rem;">(optional)</span></label>
                        <input type="number" name="bookingId" placeholder="e.g. 1042" min="1" />
                    </div>
                    <div class="form-group">
                        <label>Ticket ID <span style="color:var(--muted);font-size:.75rem;">(optional)</span></label>
                        <input type="number" name="ticketId" placeholder="e.g. 5821" min="1" />
                    </div>
                </div>

                <!-- Contact -->
                <div class="form-row">
                    <div class="form-group">
                        <label>Your Email <span class="req">*</span></label>
                        <input type="email" name="customerEmail" placeholder="you@email.com" required
                               value="${sessionScope.user != null ? sessionScope.user.email : ''}" />
                    </div>
                    <div class="form-group">
                        <label>Phone Number <span style="color:var(--muted);font-size:.75rem;">(optional)</span></label>
                        <input type="tel" name="customerPhone" placeholder="+94 7X XXX XXXX" />
                    </div>
                </div>

                <!-- Priority -->
                <div class="form-group">
                    <label>Priority</label>
                    <input type="hidden" name="priority" id="priorityInput" value="MEDIUM" />
                    <div class="priority-group">
                        <button type="button" class="priority-btn selected-medium" data-val="LOW"    onclick="setPriority(this)">🟢 Low</button>
                        <button type="button" class="priority-btn selected-medium" data-val="MEDIUM" onclick="setPriority(this)" id="defaultPriority">🟡 Medium</button>
                        <button type="button" class="priority-btn selected-medium" data-val="HIGH"   onclick="setPriority(this)">🔴 High</button>
                    </div>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fas fa-paper-plane"></i> Submit Issue
                </button>
            </form>
        </div>

<div class="card" id="my-issues" style="margin-top:18px;">
    <div class="card-title"><i class="fas fa-bell"></i> My Issue Notifications</div>

    <c:choose>
        <c:when test="${not empty myIssues}">
            <div style="display:grid; gap:14px;">
                <c:forEach var="issue" items="${myIssues}">
                    <a href="${pageContext.request.contextPath}/IssueServlet?action=myIssueDetail&id=${issue.issueId}"
                       style="display:block; text-decoration:none; color:inherit; background:var(--surface); border:1px solid var(--border); border-radius:12px; padding:16px; transition:.2s;">
                        <div style="display:flex; justify-content:space-between; gap:12px; align-items:flex-start; flex-wrap:wrap;">
                            <div>
                                <div style="font-weight:600; margin-bottom:6px;">#${issue.issueId} — ${issue.subject}</div>
                                <div style="font-size:.8rem; color:var(--muted);">${issue.category}</div>
                            </div>
                            <div style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
                                <span class="chip" style="background:rgba(108,92,231,.15); color:#a29bfe;">${issue.status}</span>
                                <span style="font-size:.75rem; color:var(--accent2); font-weight:600;">View Messages</span>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div style="background:var(--surface); border:1px dashed var(--border); border-radius:12px; padding:20px; color:var(--muted); text-align:center;">
                No issue notifications yet. When admins reply to your support requests, they will appear here.
            </div>
        </c:otherwise>
    </c:choose>
</div>

    </div>

    <!-- RIGHT: SIDEBAR -->
    <div class="contact-section">

        <!-- Authority Contact -->
        <div class="contact-card">
            <h3><i class="fas fa-address-book" style="margin-right:6px;color:var(--accent);"></i> Authority Contacts</h3>

            <div class="contact-item">
                <div class="contact-icon icon-purple"><i class="fas fa-phone"></i></div>
                <div class="contact-info">
                    <small>Support Hotline</small>
                    <a href="tel:+94711234567">+94 71 123 4567</a>
                </div>
            </div>
            <div class="contact-item">
                <div class="contact-icon icon-teal"><i class="fas fa-envelope"></i></div>
                <div class="contact-info">
                    <small>General Support</small>
                    <a href="mailto:support@eventhorizon.lk">support@eventhorizon.lk</a>
                </div>
            </div>
            <div class="contact-item">
                <div class="contact-icon icon-green"><i class="fas fa-ticket-alt"></i></div>
                <div class="contact-info">
                    <small>Booking Support</small>
                    <a href="mailto:bookings@eventhorizon.lk">bookings@eventhorizon.lk</a>
                </div>
            </div>
            <div class="contact-item">
                <div class="contact-icon icon-purple"><i class="fas fa-calendar-star"></i></div>
                <div class="contact-info">
                    <small>Events Support</small>
                    <a href="mailto:events@eventhorizon.lk">events@eventhorizon.lk</a>
                </div>
            </div>
            <div class="contact-item">
                <div class="contact-icon icon-orange"><i class="fas fa-clock"></i></div>
                <div class="contact-info">
                    <small>Support Hours</small>
                    <span>Mon – Sat, 8:00 AM – 8:00 PM</span>
                </div>
            </div>
        </div>

        <!-- Emergency -->
        <div class="emergency-card">
            <h3><i class="fas fa-exclamation-triangle"></i> Emergency Support</h3>
            <div class="contact-item" style="border-color:rgba(225,112,85,.2);">
                <div class="contact-icon icon-orange"><i class="fas fa-phone-alt"></i></div>
                <div class="contact-info">
                    <small>24/7 Emergency Line</small>
                    <a href="tel:+94777654321" style="color:var(--danger);">+94 77 765 4321</a>
                </div>
            </div>
            <p style="font-size:.77rem; color:var(--muted); margin-top:12px; line-height:1.6;">
                Use the emergency line only for <strong style="color:var(--text);">event-day critical issues</strong> such as venue access, immediate safety concerns, or event cancellations.
            </p>
        </div>

        <!-- Category Routing Guide -->
        <div class="contact-card">
            <h3><i class="fas fa-route" style="margin-right:6px;color:var(--accent2);"></i> How We Route Issues</h3>
            <div class="cat-guide">
                <div class="cat-row"><div class="cat-dot" style="background:#00cec9;"></div><div><strong>Bookings Team</strong> — Payments, tickets, refunds, QR codes</div></div>
                <div class="cat-row"><div class="cat-dot" style="background:#6c5ce7;"></div><div><strong>Events Team</strong> — Event info, venue, cancellations</div></div>
                <div class="cat-row"><div class="cat-dot" style="background:#fdcb6e;"></div><div><strong>Core Admin</strong> — Account, login, technical, general</div></div>
            </div>
        </div>

    </div>
</div>

<footer>
    &copy; 2025 EventHorizon. All rights reserved. &nbsp;|&nbsp;
    <a href="${pageContext.request.contextPath}/faq.jsp" style="color:var(--muted);text-decoration:none;">FAQ</a> &nbsp;|&nbsp;
    <a href="${pageContext.request.contextPath}/ticketPolicy.jsp" style="color:var(--muted);text-decoration:none;">Ticket Policy</a>
</footer>

<script>
    // ── Priority selection ───────────────────────────────────────────────────
    const btns = document.querySelectorAll('.priority-btn');
    function setPriority(btn) {
        btns.forEach(b => b.className = 'priority-btn');
        const val = btn.dataset.val;
        btn.classList.add('selected-' + val.toLowerCase());
        document.getElementById('priorityInput').value = val;
    }
    // Default medium selected
    btns[1].classList.add('selected-medium');

    // ── Category routing hint ────────────────────────────────────────────────
    const routingMap = {
        "Booking Problem":              "Bookings Team",
        "Payment Verification Issue":   "Bookings Team",
        "Ticket Not Received":          "Bookings Team",
        "QR Code Not Working":          "Bookings Team",
        "Refund Request":               "Bookings Team",
        "Seat Availability Problem":    "Bookings Team",
        "Event Information Error":      "Events Team",
        "Event Cancellation Complaint": "Events Team",
        "Account Login Problem":        "Core Admin",
        "Profile / Registration Problem":"Core Admin",
        "Website Technical Issue":      "Core Admin",
        "General Inquiry":              "Core Admin",
        "Other":                        "Core Admin"
    };

    function updateRouting() {
        const cat   = document.getElementById('categorySelect').value;
        const hint  = document.getElementById('routingHint');
        const label = document.getElementById('routingLabel');
        if (cat && routingMap[cat]) {
            label.textContent = routingMap[cat];
            hint.style.display = 'flex';
        } else {
            hint.style.display = 'none';
        }
    }
</script>
</body>
</html>
