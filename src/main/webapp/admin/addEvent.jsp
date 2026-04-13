<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("userId") == null ||
        !"ADMIN".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Events - EventHorizon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <div class="hamburger"><span></span><span></span><span></span></div>

    <ul class="navbar-links">
        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/event?action=list">Events</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="active">Admin Panel</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?action=myBookings">My Bookings</a></li>
        <li><a href="${pageContext.request.contextPath}/profile.jsp">Profile</a></li>
        <li><a href="${pageContext.request.contextPath}/user?action=logout" class="btn-nav">Logout</a></li>
    </ul>
</nav>

<div class="container">
    <div class="section-header">
        <h2 class="section-title">Manage <span>Events</span></h2>
        <div class="section-divider"></div>
        <p style="color:var(--text-muted);margin-top:12px;font-size:0.95rem;">
            Add, update, cancel, and delete events
        </p>
    </div>

    <c:if test="${param.msg == 'added'}">
        <div class="alert alert-success" data-auto-dismiss>✅ Event added successfully.</div>
    </c:if>
    <c:if test="${param.msg == 'updated'}">
        <div class="alert alert-success" data-auto-dismiss>✅ Event updated successfully.</div>
    </c:if>
    <c:if test="${param.msg == 'deleted'}">
        <div class="alert alert-success" data-auto-dismiss>✅ Event deleted successfully.</div>
    </c:if>
    <c:if test="${param.msg == 'cancelled'}">
        <div class="alert alert-info" data-auto-dismiss>⚠️ Event cancelled successfully.</div>
    </c:if>
    <c:if test="${param.msg == 'error'}">
        <div class="alert alert-danger" data-auto-dismiss>❌ Something went wrong.</div>
    </c:if>

    <div class="card" style="padding:24px;margin-bottom:32px;">
        <h3 style="margin-bottom:20px;">➕ Add New Event</h3>

        <form action="${pageContext.request.contextPath}/event"
              method="post"
              enctype="multipart/form-data">
            <input type="hidden" name="action" value="add">

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Title</label>
                    <input type="text" name="title" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Category</label>
                    <select name="category" class="form-control" required>
                        <option value="">Select Category</option>
                        <option value="Concert">Concert</option>
                        <option value="Sports">Sports</option>
                        <option value="Technology">Technology</option>
                        <option value="Cultural">Cultural</option>
                        <option value="Theater">Theater</option>
                        <option value="Comedy">Comedy</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Date</label>
                    <input type="date" name="date" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Time</label>
                    <input type="time" name="time" class="form-control" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Venue</label>
                    <input type="text" name="venue" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Ticket Price</label>
                    <input type="number" step="0.01" name="ticketPrice" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Total Seats</label>
                    <input type="number" name="totalSeats" class="form-control" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Event Image</label>
                <input type="file" name="eventImage" class="form-control" accept="image/*">
            </div>

            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="4" required></textarea>
            </div>

            <button type="submit" class="btn btn-primary">Add Event</button>
        </form>
    </div>

    <div class="card" style="padding:24px;">
        <div style="display:flex;justify-content:space-between;align-items:center;gap:16px;flex-wrap:wrap;margin-bottom:20px;">
            <h3>📋 All Events</h3>
            <a href="${pageContext.request.contextPath}/event?action=adminList" class="btn btn-outline">Refresh</a>
        </div>

        <c:choose>
            <c:when test="${not empty events}">
                <div style="overflow-x:auto;">
                    <table class="table" style="width:100%;">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Image</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Venue</th>
                            <th>Price</th>
                            <th>Total Seats</th>
                            <th>Available</th>
                            <th>Status</th>
                            <th style="min-width:280px;">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="event" items="${events}">
                            <tr>
                                <td>${event.eventId}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty event.imagePath}">
                                            <img src="${pageContext.request.contextPath}/${event.imagePath}"
                                                 alt="${event.title}"
                                                 style="width:70px;height:50px;object-fit:cover;border-radius:8px;">
                                        </c:when>
                                        <c:otherwise>
                                            <span style="font-size:1.4rem;">🎟️</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${event.title}</td>
                                <td>${event.category}</td>
                                <td>${event.date}</td>
                                <td>${event.time}</td>
                                <td>${event.venue}</td>
                                <td>LKR ${event.ticketPrice}</td>
                                <td>${event.totalSeats}</td>
                                <td>${event.availableSeats}</td>
                                <td>${event.status}</td>
                                <td>
                                    <details style="margin-bottom:8px;">
                                        <summary class="btn btn-outline" style="display:inline-block;cursor:pointer;">Edit</summary>

                                        <form action="${pageContext.request.contextPath}/event"
                                              method="post"
                                              enctype="multipart/form-data"
                                              style="margin-top:12px;">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="eventId" value="${event.eventId}">

                                            <div class="form-group">
                                                <label class="form-label">Title</label>
                                                <input type="text" name="title" value="${event.title}" class="form-control" required>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">Category</label>
                                                <select name="category" class="form-control" required>
                                                    <option value="Concert" ${event.category == 'Concert' ? 'selected' : ''}>Concert</option>
                                                    <option value="Sports" ${event.category == 'Sports' ? 'selected' : ''}>Sports</option>
                                                    <option value="Technology" ${event.category == 'Technology' ? 'selected' : ''}>Technology</option>
                                                    <option value="Cultural" ${event.category == 'Cultural' ? 'selected' : ''}>Cultural</option>
                                                    <option value="Theater" ${event.category == 'Theater' ? 'selected' : ''}>Theater</option>
                                                    <option value="Comedy" ${event.category == 'Comedy' ? 'selected' : ''}>Comedy</option>
                                                </select>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">Date</label>
                                                <input type="text" name="date" value="${event.date}" class="form-control" required>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">Time</label>
                                                <input type="text" name="time" value="${event.time}" class="form-control" required>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">Venue</label>
                                                <input type="text" name="venue" value="${event.venue}" class="form-control" required>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">Ticket Price</label>
                                                <input type="number" step="0.01" name="ticketPrice" value="${event.ticketPrice}" class="form-control" required>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">Replace Image (optional)</label>
                                                <input type="file" name="eventImage" class="form-control" accept="image/*">
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">Description</label>
                                                <textarea name="description" class="form-control" rows="3" required>${event.description}</textarea>
                                            </div>

                                            <button type="submit" class="btn btn-primary btn-sm">Save Changes</button>
                                        </form>
                                    </details>

                                    <form action="${pageContext.request.contextPath}/event" method="post" style="display:inline-block;margin-right:6px;">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="eventId" value="${event.eventId}">
                                        <button type="submit" class="btn btn-outline btn-sm"
                                                onclick="return confirm('Are you sure you want to cancel this event?');">
                                            Cancel
                                        </button>
                                    </form>

                                    <form action="${pageContext.request.contextPath}/event" method="post" style="display:inline-block;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="eventId" value="${event.eventId}">
                                        <button type="submit" class="btn btn-danger btn-sm"
                                                onclick="return confirm('Are you sure you want to delete this event?');">
                                            Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>

            <c:otherwise>
                <div class="empty-state">
                    <span class="emoji">📭</span>
                    <h3>No Events Available</h3>
                    <p>There are no events in the system yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<footer class="footer">
    <div class="footer-brand">⬡ EVENTHORIZON</div>
    <p>SE1020 – Object Oriented Programming Project &copy; 2026</p>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>