package com.eventhorizon.servlet;

import com.eventhorizon.service.BookingService;
import com.eventhorizon.model.Event;
import com.eventhorizon.service.EventService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

/**
 * BookingServlet – orchestrates the booking + payment lifecycle.
 *
 * GET  /booking?action=myBookings             -> customer: my bookings list
 * GET  /booking?action=allBookings            -> admin:    all bookings
 * GET  /booking?action=eventBookings&eventId  -> admin bookings per event
 * GET  /booking?action=checkout&eventId=X&tickets=N -> customer checkout page
 * GET  /booking?action=pendingPayments        -> admin: pending payment queue
 *
 * POST /booking?action=confirmPayment         -> customer: save booking + payment reference
 * POST /booking?action=cancel                 -> customer/admin: cancel booking
 * POST /booking?action=approvePayment         -> admin: approve payment → issue tickets
 * POST /booking?action=rejectPayment          -> admin: reject payment → restore seats
 */
public class BookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final EventService eventService = new EventService();

    // ==================== GET ====================
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
                requireCustomer(session, resp, req);
                if (resp.isCommitted()) return;

                String customerId = (String) session.getAttribute("userId");
                req.setAttribute("bookings", bookingService.getBookingsByCustomer(customerId));
                req.getRequestDispatcher("/myBookings.jsp").forward(req, resp);
                break;

            case "allBookings":
                requireAdmin(session, resp, req);
                if (resp.isCommitted()) return;

                req.setAttribute("bookings", bookingService.getAllBookings());
                req.getRequestDispatcher("/admin/bookings.jsp").forward(req, resp);
                break;

            case "eventBookings":
                requireAdmin(session, resp, req);
                if (resp.isCommitted()) return;

                req.setAttribute("bookings", bookingService.getBookingsByEvent(req.getParameter("eventId")));
                req.getRequestDispatcher("/admin/bookings.jsp").forward(req, resp);
                break;

            case "checkout":
                requireCustomer(session, resp, req);
                if (resp.isCommitted()) return;

                handleCheckoutPage(req, resp, session);
                break;

            case "pendingPayments":
                requireAdmin(session, resp, req);
                if (resp.isCommitted()) return;

                req.setAttribute("pendingBookings", bookingService.getPendingBookings());
                req.getRequestDispatcher("/admin/managePayments.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }

    // ==================== POST ====================
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
                requireCustomer(session, resp, req);
                if (resp.isCommitted()) return;

                handleConfirmPayment(req, resp, session);
                break;

            case "cancel":
                handleCancel(req, resp, session);
                break;

            case "approvePayment":
                requireAdmin(session, resp, req);
                if (resp.isCommitted()) return;

                handleApprovePayment(req, resp, session);
                break;

            case "rejectPayment":
                requireAdmin(session, resp, req);
                if (resp.isCommitted()) return;

                handleRejectPayment(req, resp, session);
                break;

            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    // -------------------- Checkout page (GET) --------------------
    private void handleCheckoutPage(HttpServletRequest req, HttpServletResponse resp,
                                    HttpSession session) throws ServletException, IOException {

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

    // -------------------- Confirm payment (POST) --------------------
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

        String bookingId = bookingService.createBooking(
                customerId,
                eventId,
                tickets,
                paymentReference
        );

        if (bookingId != null) {
            resp.sendRedirect(req.getContextPath() + "/booking?action=myBookings&msg=paymentPending&id=" + bookingId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/event?action=view&id=" + eventId + "&error=bookingFailed");
        }
    }

    // -------------------- Cancel booking (POST) --------------------
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

        // Optional security improvement:
        // Customer should only cancel own bookings
        if (!"ADMIN".equals(role)) {
            com.eventhorizon.model.Booking booking = bookingService.getBookingById(bookingId);
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

    // -------------------- Admin: Approve payment (POST) --------------------
    private void handleApprovePayment(HttpServletRequest req, HttpServletResponse resp,
                                      HttpSession session) throws IOException {

        String bookingId = req.getParameter("bookingId");
        boolean ok = bookingService.approveBooking(bookingId);
        resp.sendRedirect(req.getContextPath() + "/booking?action=pendingPayments&msg=" + (ok ? "approved" : "error"));
    }

    // -------------------- Admin: Reject payment (POST) --------------------
    private void handleRejectPayment(HttpServletRequest req, HttpServletResponse resp,
                                     HttpSession session) throws IOException {

        String bookingId = req.getParameter("bookingId");
        boolean ok = bookingService.rejectBooking(bookingId);
        resp.sendRedirect(req.getContextPath() + "/booking?action=pendingPayments&msg=" + (ok ? "rejected" : "error"));
    }

    // -------------------- Helpers --------------------
    private void requireAdmin(HttpSession session, HttpServletResponse resp, HttpServletRequest req) throws IOException {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    private void requireCustomer(HttpSession session, HttpServletResponse resp, HttpServletRequest req) throws IOException {
        if (!"CUSTOMER".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}