package com.eventhorizon.servlet;

import com.eventhorizon.model.Admin;
import com.eventhorizon.model.Booking;
import com.eventhorizon.model.Event;
import com.eventhorizon.service.BookingService;
import com.eventhorizon.service.EventService;
import com.eventhorizon.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class BookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final EventService eventService = new EventService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {

            case "myBookings":
                requireCustomer(session, req, resp);
                if (resp.isCommitted()) return;

                String customerId = (String) session.getAttribute("userId");
                req.setAttribute("bookings", bookingService.getBookingsByCustomer(customerId));
                req.getRequestDispatcher("/myBookings.jsp").forward(req, resp);
                break;

            case "allBookings":
                requireBookingAdmin(session, req, resp);
                if (resp.isCommitted()) return;

                req.setAttribute("bookings", bookingService.getAllBookings());
                req.getRequestDispatcher("/admin/bookings.jsp").forward(req, resp);
                break;

            case "eventBookings":
                requireBookingAdmin(session, req, resp);
                if (resp.isCommitted()) return;

                req.setAttribute("bookings", bookingService.getBookingsByEvent(req.getParameter("eventId")));
                req.getRequestDispatcher("/admin/bookings.jsp").forward(req, resp);
                break;

            case "checkout":
                requireCustomer(session, req, resp);
                if (resp.isCommitted()) return;

                handleCheckoutPage(req, resp);
                break;

            case "pendingPayments":
                requireBookingAdmin(session, req, resp);
                if (resp.isCommitted()) return;

                req.setAttribute("pendingBookings", bookingService.getPendingBookings());
                req.getRequestDispatcher("/admin/managePayments.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {

            case "confirmPayment":
                requireCustomer(session, req, resp);
                if (resp.isCommitted()) return;

                handleConfirmPayment(req, resp, session);
                break;

            case "cancel":
                handleCancel(req, resp, session);
                break;

            case "approvePayment":
                requireBookingAdmin(session, req, resp);
                if (resp.isCommitted()) return;

                handleApprovePayment(req, resp);
                break;

            case "rejectPayment":
                requireBookingAdmin(session, req, resp);
                if (resp.isCommitted()) return;

                handleRejectPayment(req, resp);
                break;

            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    private void handleCheckoutPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String eventId = req.getParameter("eventId");
        String ticketsParam = req.getParameter("tickets");

        int tickets = 1;
        try {
            tickets = Integer.parseInt(ticketsParam);
            if (tickets <= 0) tickets = 1;
        } catch (Exception ignored) {
            tickets = 1;
        }

        Event event = eventService.getEventById(eventId);

        if (event == null) {
            resp.sendRedirect(req.getContextPath() + "/event?action=list");
            return;
        }

        if (!"ACTIVE".equalsIgnoreCase(event.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/event?action=view&id=" + eventId + "&error=inactive");
            return;
        }

        if (event.getAvailableSeats() < tickets) {
            resp.sendRedirect(req.getContextPath() + "/event?action=view&id=" + eventId + "&error=noSeats");
            return;
        }

        req.setAttribute("event", event);
        req.setAttribute("tickets", tickets);
        req.setAttribute("total", event.getTicketPrice() * tickets);
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    private void handleConfirmPayment(HttpServletRequest req, HttpServletResponse resp,
                                      HttpSession session) throws IOException {

        String customerId = (String) session.getAttribute("userId");
        String eventId = req.getParameter("eventId");
        String paymentReference = req.getParameter("paymentReference");

        int tickets;
        try {
            tickets = Integer.parseInt(req.getParameter("numberOfTickets"));
            if (tickets <= 0) tickets = 1;
        } catch (Exception e) {
            tickets = 1;
        }

        if (paymentReference == null || paymentReference.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/booking?action=checkout&eventId="
                    + eventId + "&tickets=" + tickets + "&error=noReference");
            return;
        }

        String bookingId = bookingService.createBooking(customerId, eventId, tickets, paymentReference);

        if (bookingId != null) {
            resp.sendRedirect(req.getContextPath() + "/booking?action=myBookings&msg=paymentPending&id=" + bookingId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/event?action=view&id=" + eventId + "&error=bookingFailed");
        }
    }

    private void handleCancel(HttpServletRequest req, HttpServletResponse resp,
                              HttpSession session) throws IOException {

        String bookingId = req.getParameter("bookingId");
        String role = (String) session.getAttribute("role");
        String currentUserId = (String) session.getAttribute("userId");

        if (bookingId == null || bookingId.trim().isEmpty()) {
            if ("ADMIN".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/booking?action=allBookings&error=invalidBooking");
            } else {
                resp.sendRedirect(req.getContextPath() + "/booking?action=myBookings&error=invalidBooking");
            }
            return;
        }

        if ("ADMIN".equals(role)) {
            String permission = (String) session.getAttribute("adminPermission");
            if (!UserService.hasBookingAccess(permission)) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp?error=noBookingPermission");
                return;
            }
        } else {
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking == null || !currentUserId.equals(booking.getCustomerId())) {
                resp.sendRedirect(req.getContextPath() + "/booking?action=myBookings&error=unauthorized");
                return;
            }
        }

        boolean ok = bookingService.cancelBooking(bookingId);

        if ("ADMIN".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/booking?action=allBookings&msg=" + (ok ? "cancelled" : "error"));
        } else {
            resp.sendRedirect(req.getContextPath() + "/booking?action=myBookings&msg=" + (ok ? "cancelled" : "error"));
        }
    }

    private void handleApprovePayment(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String bookingId = req.getParameter("bookingId");
        boolean ok = bookingService.approveBooking(bookingId);
        resp.sendRedirect(req.getContextPath() + "/booking?action=allBookings&msg=" + (ok ? "approved" : "error"));
    }

    private void handleRejectPayment(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String bookingId = req.getParameter("bookingId");
        boolean ok = bookingService.rejectBooking(bookingId);
        resp.sendRedirect(req.getContextPath() + "/booking?action=allBookings&msg=" + (ok ? "rejected" : "error"));
    }

    private void requireCustomer(HttpSession session, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        if (!"CUSTOMER".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    private void requireBookingAdmin(HttpSession session, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        if (!"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String permission = (String) session.getAttribute("adminPermission");
        if (permission == null) permission = Admin.FULL_ACCESS;

        if (!UserService.hasBookingAccess(permission)) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp?error=noBookingPermission");
        }
    }
}