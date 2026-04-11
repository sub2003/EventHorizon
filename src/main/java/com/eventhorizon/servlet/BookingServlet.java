package com.eventhorizon.servlet;

import com.eventhorizon.service.BookingService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

/**
 * BookingServlet - Handles all booking-related HTTP requests.
 *
 * URL Mappings:
 *   POST /booking?action=create          -> Create booking (Customer)
 *   POST /booking?action=cancel          -> Cancel booking (Customer / Admin)
 *   GET  /booking?action=myBookings      -> Customer: view own bookings
 *   GET  /booking?action=allBookings     -> Admin: view all bookings
 *   GET  /booking?action=eventBookings   -> Admin: bookings per event
 */
public class BookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    // ==================== GET ====================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect("login.jsp"); return; }

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {

            case "myBookings":
                // Customer views their own bookings
                String customerId = (String) session.getAttribute("userId");
                req.setAttribute("bookings", bookingService.getBookingsByCustomer(customerId));
                req.getRequestDispatcher("/myBookings.jsp").forward(req, resp);
                break;

            case "allBookings":
                // Admin views all bookings
                if (!"ADMIN".equals(session.getAttribute("role"))) {
                    resp.sendRedirect("login.jsp"); return;
                }
                req.setAttribute("bookings", bookingService.getAllBookings());
                req.getRequestDispatcher("/admin/bookings.jsp").forward(req, resp);
                break;

            case "eventBookings":
                // Admin views bookings for a specific event
                if (!"ADMIN".equals(session.getAttribute("role"))) {
                    resp.sendRedirect("login.jsp"); return;
                }
                String eventId = req.getParameter("eventId");
                req.setAttribute("bookings", bookingService.getBookingsByEvent(eventId));
                req.getRequestDispatcher("/admin/bookings.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect("index.jsp");
        }
    }

    // ==================== POST ====================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect("login.jsp"); return; }

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {
            case "create": handleCreate(req, resp, session); break;
            case "cancel": handleCancel(req, resp, session); break;
            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    // -------------------- Create Booking --------------------
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp,
                               HttpSession session) throws IOException {
        String customerId = (String) session.getAttribute("userId");
        String eventId    = req.getParameter("eventId");
        int    tickets    = Integer.parseInt(req.getParameter("numberOfTickets"));

        String bookingId = bookingService.createBooking(customerId, eventId, tickets);

        if (bookingId != null) {
            resp.sendRedirect("booking?action=myBookings&msg=booked&id=" + bookingId);
        } else {
            resp.sendRedirect("event?action=view&id=" + eventId + "&error=bookingFailed");
        }
    }

    // -------------------- Cancel Booking --------------------
    private void handleCancel(HttpServletRequest req, HttpServletResponse resp,
                               HttpSession session) throws IOException {
        String bookingId = req.getParameter("bookingId");
        String role      = (String) session.getAttribute("role");

        boolean ok = bookingService.cancelBooking(bookingId);

        if ("ADMIN".equals(role)) {
            resp.sendRedirect("booking?action=allBookings&msg=" + (ok ? "cancelled" : "error"));
        } else {
            resp.sendRedirect("booking?action=myBookings&msg=" + (ok ? "cancelled" : "error"));
        }
    }
}
