<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${event.title} – EventHorizon</title>
    <link rel="stylesheet" href="css/style.css">
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

    <div style="display:grid;grid-template-columns:1fr 340px;gap:32px;margin-top:24px;align-items:start;">

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
                <h3 style="margin-bottom:12px;font-size:1rem;color:var(--text-muted);text-transform:uppercase;letter-spacing:1px;font-size:0.8rem;">About This Event</h3>
                <p style="color:var(--text-primary);line-height:1.8;">${event.description}</p>
            </div>
        </div>

        <div>
            <div class="booking-card">
                <div class="booking-price">
                    LKR ${event.ticketPrice}
                    <small>/ ticket</small>
                </div>

                <div class="seats-bar" style="margin-top:12px;">
                    <div class="seats-bar-fill"
                         data-pct="${(event.availableSeats * 100) / event.totalSeats}">
                    </div>
                </div>
                <p style="font-size:0.8rem;color:var(--text-muted);margin-bottom:20px;">
                    ${event.availableSeats} seats remaining
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
                        <form action="booking" method="get">
                            <input type="hidden" name="action" value="checkout">
                            <input type="hidden" name="eventId" value="${event.eventId}">
                            <input type="hidden" id="pricePerTicket" value="${event.ticketPrice}">

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
                                       max="${event.availableSeats}"
                                       required>
                            </div>

                            <div style="background:rgba(6,182,212,0.08);border:1px solid rgba(6,182,212,0.2);border-radius:8px;padding:14px;margin-bottom:16px;">
                                <div style="font-size:0.8rem;color:var(--text-muted);">Total Amount</div>
                                <div id="totalAmount" style="font-family:'Orbitron',monospace;font-size:1.3rem;color:var(--accent-teal);font-weight:700;">
                                    LKR ${event.ticketPrice}
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary btn-block">
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
                        ❌ Booking failed. Not enough seats available.
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
    (function () {
        const qtyInput = document.getElementById('numberOfTickets');
        const totalAmount = document.getElementById('totalAmount');
        const pricePerTicketInput = document.getElementById('pricePerTicket');

        if (qtyInput && totalAmount && pricePerTicketInput) {
            const price = parseFloat(pricePerTicketInput.value || '0');

            function updateTotal() {
                let qty = parseInt(qtyInput.value || '1', 10);
                if (isNaN(qty) || qty < 1) qty = 1;
                totalAmount.textContent = 'LKR ' + (price * qty).toFixed(2);
            }

            qtyInput.addEventListener('input', updateTotal);
            updateTotal();
        }
    })();
</script>
</body>
</html>