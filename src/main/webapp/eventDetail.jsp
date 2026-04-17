<!-- eventDetail.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.EventTicketType" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    List<EventTicketType> ticketTypes = (List<EventTicketType>) request.getAttribute("ticketTypes");
    if (ticketTypes == null) {
        ticketTypes = new java.util.ArrayList<EventTicketType>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${event.title} – EventHorizon</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .ticket-type-grid {
            display: grid;
            gap: 12px;
            margin-bottom: 18px;
        }

        .ticket-type-card {
            position: relative;
            border: 1px solid rgba(255,255,255,0.10);
            background: rgba(255,255,255,0.03);
            border-radius: 14px;
            padding: 14px;
            transition: 0.2s ease;
            cursor: pointer;
        }

        .ticket-type-card:hover {
            border-color: rgba(124,92,255,0.35);
            background: rgba(124,92,255,0.06);
        }

        .ticket-type-card.selected {
            border-color: rgba(43,192,255,0.55);
            background: rgba(43,192,255,0.08);
            box-shadow: 0 0 0 1px rgba(43,192,255,0.10) inset;
        }

        .ticket-type-radio {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .ticket-type-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 10px;
        }

        .ticket-type-name {
            color: #ffffff;
            font-size: 1rem;
            font-weight: 800;
        }

        .ticket-type-price {
            color: var(--accent-teal, #2bc0ff);
            font-size: 1rem;
            font-weight: 800;
            white-space: nowrap;
        }

        .ticket-type-meta {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            color: var(--text-muted);
            font-size: 0.86rem;
            flex-wrap: wrap;
        }

        .ticket-type-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 800;
            letter-spacing: 0.4px;
            text-transform: uppercase;
        }

        .badge-available {
            background: rgba(46, 204, 113, 0.14);
            color: #87f0aa;
        }

        .badge-soldout {
            background: rgba(231, 76, 60, 0.14);
            color: #ff9f95;
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <div class="hamburger"><span></span><span></span><span></span></div>
    <ul class="navbar-links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="event?action=list" class="active">Events</a></li>

        <c:if test="${not empty sessionScope.userId and sessionScope.role == 'CUSTOMER'}">
            <li><a href="booking?action=myBookings">My Bookings</a></li>
            <li><a href="profile.jsp">Profile</a></li>
            <li><a href="user?action=logout" class="btn-nav">Logout</a></li>
        </c:if>

        <c:if test="${not empty sessionScope.userId and sessionScope.role == 'ADMIN'}">
            <li><a href="admin/dashboard.jsp">Dashboard</a></li>
            <li><a href="profile.jsp">Profile</a></li>
            <li><a href="user?action=logout" class="btn-nav">Logout</a></li>
        </c:if>

        <c:if test="${empty sessionScope.userId}">
            <li><a href="login.jsp">Login</a></li>
            <li><a href="register.jsp" class="btn-nav">Sign Up</a></li>
        </c:if>
    </ul>
</nav>

<div class="container" style="padding-top:32px;padding-bottom:60px;">

    <a href="event?action=list" style="color:var(--text-muted);font-size:0.9rem;">
        ← Back to Events
    </a>

    <div style="display:grid;grid-template-columns:1fr 360px;gap:32px;margin-top:24px;align-items:start;">

        <div>
            <div class="event-detail-hero">
                <div class="event-detail-icon">
                    <c:choose>
                        <c:when test="${event.category == 'Concert'}">🎵</c:when>
                        <c:when test="${event.category == 'Sports'}">⚽</c:when>
                        <c:when test="${event.category == 'Technology'}">💻</c:when>
                        <c:when test="${event.category == 'Cultural'}">🎭</c:when>
                        <c:when test="${event.category == 'Theater'}">🎬</c:when>
                        <c:otherwise>🎟️</c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <div class="card-category">${event.category}</div>
                    <h1 class="event-detail-title">${event.title}</h1>
                    <c:if test="${event.status == 'CANCELLED'}">
                        <span class="badge badge-danger">CANCELLED</span>
                    </c:if>
                    <c:if test="${event.status == 'ACTIVE'}">
                        <span class="badge badge-success">ACTIVE</span>
                    </c:if>
                </div>
            </div>

            <div class="event-meta-grid">
                <div class="event-meta-item">
                    <label>📅 Date</label>
                    <span>${event.date}</span>
                </div>
                <div class="event-meta-item">
                    <label>⏰ Time</label>
                    <span>${event.time}</span>
                </div>
                <div class="event-meta-item">
                    <label>📍 Venue</label>
                    <span>${event.venue}</span>
                </div>
                <div class="event-meta-item">
                    <label>💺 Available Seats</label>
                    <span>${event.availableSeats} / ${event.totalSeats}</span>
                </div>
            </div>

            <div style="background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius);padding:24px;margin-top:16px;">
                <h3 style="margin-bottom:12px;color:var(--text-muted);text-transform:uppercase;letter-spacing:1px;font-size:0.8rem;">About This Event</h3>
                <p style="color:var(--text-primary);line-height:1.8;">${event.description}</p>
            </div>
        </div>

        <div>
            <div class="booking-card">
                <div class="booking-price">
                    LKR ${event.ticketPrice}
                    <small>/ starting from</small>
                </div>

                <div class="seats-bar" style="margin-top:12px;">
                    <div class="seats-bar-fill"
                         data-pct="${event.totalSeats > 0 ? (event.availableSeats * 100) / event.totalSeats : 0}">
                    </div>
                </div>
                <p style="font-size:0.8rem;color:var(--text-muted);margin-bottom:20px;">
                    ${event.availableSeats} seats remaining in total
                </p>

                <c:choose>
                    <c:when test="${event.status == 'CANCELLED'}">
                        <div class="alert alert-danger">This event has been cancelled.</div>
                    </c:when>

                    <c:when test="${event.availableSeats == 0}">
                        <div class="alert alert-warning">Sold Out!</div>
                    </c:when>

                    <c:when test="${empty sessionScope.userId}">
                        <div class="alert alert-info" style="margin-bottom:16px;">
                            Please log in to book tickets.
                        </div>
                        <a href="login.jsp" class="btn btn-primary btn-block">
                            🔑 Login to Book
                        </a>
                    </c:when>

                    <c:when test="${sessionScope.role == 'CUSTOMER'}">
                        <form action="booking" method="get" id="bookingForm">
                            <input type="hidden" name="action" value="checkout">
                            <input type="hidden" name="eventId" value="${event.eventId}">

                            <div class="form-group">
                                <label class="form-label">Select Ticket Type</label>

                                <div class="ticket-type-grid" id="ticketTypeGrid">
                                    <%
                                        boolean hasAvailableType = false;
                                        int typeIndex = 0;
                                        for (EventTicketType type : ticketTypes) {
                                            boolean available = type.getAvailableSeats() > 0;
                                            if (available) hasAvailableType = true;
                                    %>
                                        <label class="ticket-type-card <%= (available && !hasAvailableType ? "selected" : "") %>"
                                               data-price="<%= type.getPrice() %>"
                                               data-available="<%= type.getAvailableSeats() %>"
                                               onclick="selectTicketCard(this)">
                                            <input
                                                class="ticket-type-radio"
                                                type="radio"
                                                name="ticketTypeId"
                                                value="<%= type.getTicketTypeId() %>"
                                                <%= (available && typeIndex == 0) ? "checked" : "" %>
                                                <%= !available ? "disabled" : "" %> >

                                            <div class="ticket-type-top">
                                                <div class="ticket-type-name"><%= type.getTypeName() %></div>
                                                <div class="ticket-type-price">LKR <%= String.format("%.2f", type.getPrice()) %></div>
                                            </div>

                                            <div class="ticket-type-meta">
                                                <span><%= type.getAvailableSeats() %> / <%= type.getTotalSeats() %> seats available</span>
                                                <span class="ticket-type-badge <%= available ? "badge-available" : "badge-soldout" %>">
                                                    <%= available ? "Available" : "Sold Out" %>
                                                </span>
                                            </div>
                                        </label>
                                    <%
                                            typeIndex++;
                                        }
                                    %>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="numberOfTickets">
                                    Number of Tickets
                                </label>
                                <input type="number"
                                       id="numberOfTickets"
                                       name="tickets"
                                       class="form-control"
                                       value="1"
                                       min="1"
                                       max="1"
                                       required>
                            </div>

                            <div style="background:rgba(6,182,212,0.08);border:1px solid rgba(6,182,212,0.2);border-radius:8px;padding:14px;margin-bottom:16px;">
                                <div style="font-size:0.8rem;color:var(--text-muted);">Selected Type</div>
                                <div id="selectedTypeName" style="font-size:1rem;color:#ffffff;font-weight:700;margin-top:4px;">Select a ticket type</div>

                                <div style="font-size:0.8rem;color:var(--text-muted);margin-top:10px;">Total Amount</div>
                                <div id="totalAmount" style="font-family:'Orbitron',monospace;font-size:1.3rem;color:var(--accent-teal);font-weight:700;">
                                    LKR 0.00
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary btn-block" id="checkoutBtn">
                                🎟️ Proceed to Checkout
                            </button>
                        </form>
                    </c:when>

                    <c:when test="${sessionScope.role == 'ADMIN'}">
                        <div class="alert alert-warning" style="margin-bottom:16px;">
                            Admin accounts cannot book tickets.
                        </div>
                        <a href="admin/dashboard.jsp" class="btn btn-secondary btn-block">
                            Go to Dashboard
                        </a>
                    </c:when>

                    <c:otherwise>
                        <div class="alert alert-info" style="margin-bottom:16px;">
                            Please log in to continue.
                        </div>
                        <a href="login.jsp" class="btn btn-primary btn-block">
                            🔑 Login
                        </a>
                    </c:otherwise>
                </c:choose>

                <% if ("bookingFailed".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger" style="margin-top:12px;">
                        ❌ Booking failed. Please try again. Seats may have just changed or the booking transaction did not complete.
                    </div>
                <% } %>

                <% if ("inactive".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-warning" style="margin-top:12px;">
                        ⚠ This event is not active for booking.
                    </div>
                <% } %>

                <% if ("noSeats".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger" style="margin-top:12px;">
                        ❌ Not enough seats available for your request.
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="js/main.js"></script>
<script>
    function selectTicketCard(card) {
        const radio = card.querySelector('input[type="radio"]');
        if (!radio || radio.disabled) {
            return;
        }

        document.querySelectorAll('.ticket-type-card').forEach(function (c) {
            c.classList.remove('selected');
        });

        card.classList.add('selected');
        radio.checked = true;
        updateBookingSummary();
    }

    function updateBookingSummary() {
        const selected = document.querySelector('.ticket-type-radio:checked');
        const qtyInput = document.getElementById('numberOfTickets');
        const totalAmount = document.getElementById('totalAmount');
        const selectedTypeName = document.getElementById('selectedTypeName');
        const checkoutBtn = document.getElementById('checkoutBtn');

        if (!selected || !qtyInput || !totalAmount || !selectedTypeName) {
            return;
        }

        const card = selected.closest('.ticket-type-card');
        const price = parseFloat(card.getAttribute('data-price') || '0');
        const available = parseInt(card.getAttribute('data-available') || '0', 10);
        const nameEl = card.querySelector('.ticket-type-name');

        qtyInput.max = available > 0 ? available : 1;

        let qty = parseInt(qtyInput.value || '1', 10);
        if (isNaN(qty) || qty < 1) qty = 1;
        if (qty > available && available > 0) {
            qty = available;
            qtyInput.value = available;
        }

        selectedTypeName.textContent = nameEl ? nameEl.textContent : 'Selected Ticket';
        totalAmount.textContent = 'LKR ' + (price * qty).toFixed(2);

        if (checkoutBtn) {
            checkoutBtn.disabled = available <= 0;
        }
    }

    (function () {
        const qtyInput = document.getElementById('numberOfTickets');
        if (qtyInput) {
            qtyInput.addEventListener('input', updateBookingSummary);
        }

        const firstAvailable = document.querySelector('.ticket-type-radio:not([disabled])');
        if (firstAvailable) {
            firstAvailable.checked = true;
            selectTicketCard(firstAvailable.closest('.ticket-type-card'));
        }
    })();
</script>
</body>
</html>