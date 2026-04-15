<%@ page import="java.util.*, com.eventhorizon.model.Booking" %>

<%
    List<Booking> pendingBookings = (List<Booking>) request.getAttribute("pendingBookings");
%>

<h2>Pending Payments</h2>

<table>
    <thead>
    <tr>
        <th>Booking ID</th>
        <th>Customer</th>
        <th>Event</th>
        <th>Tickets</th>
        <th>Total</th>
        <th>Reference</th>
        <th>Action</th>
    </tr>
    </thead>

    <tbody>
    <%
        if (pendingBookings != null) {
            for (Booking b : pendingBookings) {
    %>
    <tr>
        <td><%= b.getBookingId() %></td>
        <td><%= b.getCustomerId() %></td>
        <td><%= b.getEventTitle() %></td>
        <td><%= b.getNumberOfTickets() %></td>
        <td><%= b.getTotalAmount() %></td>

        <!-- 🔥 IMPORTANT -->
        <td style="color:yellow;">
            <%= b.getPaymentReference() %>
        </td>

        <td>
            <form action="booking" method="post" style="display:inline;">
                <input type="hidden" name="action" value="approvePayment"/>
                <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>"/>
                <button class="btn btn-primary">Approve</button>
            </form>

            <form action="booking" method="post" style="display:inline;">
                <input type="hidden" name="action" value="rejectPayment"/>
                <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>"/>
                <button class="btn btn-danger">Reject</button>
            </form>
        </td>
    </tr>
    <%
            }
        }
    %>
    </tbody>
</table>