package com.eventhorizon.servlet;

import com.eventhorizon.model.Ticket;
import com.eventhorizon.service.BookingService;
import com.eventhorizon.service.TicketService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * TicketServlet – handles ticket viewing and QR code verification.
 *
 * URL Mappings:
 *   GET  /ticket?action=viewTickets&bookingId=XXX  → Customer views tickets for a booking
 *   GET  /ticket?action=scanPage                   → Admin QR scanner page
 *   POST /ticket?action=verify                     → Admin validates a QR token (JSON response)
 */
public class TicketServlet extends HttpServlet {

    private final TicketService  ticketService  = new TicketService();
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect("login.jsp"); return; }

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {

            case "viewTickets":
                handleViewTickets(req, resp, session);
                break;

            case "scanPage":
                // Admin-only scanner page
                if (!"ADMIN".equals(session.getAttribute("role"))) {
                    resp.sendRedirect("login.jsp"); return;
                }
                req.getRequestDispatcher("/admin/scanTicket.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendError(HttpServletResponse.SC_UNAUTHORIZED); return; }

        String action = req.getParameter("action");

        if ("verify".equals(action)) {
            // Admin-only endpoint: verify a scanned QR token
            if (!"ADMIN".equals(session.getAttribute("role"))) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN); return;
            }
            handleVerify(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    // -------------------- View tickets for a booking --------------------
    private void handleViewTickets(HttpServletRequest req, HttpServletResponse resp,
                                   HttpSession session) throws ServletException, IOException {

        String bookingId  = req.getParameter("bookingId");
        String customerId = (String) session.getAttribute("userId");
        String role       = (String) session.getAttribute("role");

        if (bookingId == null || bookingId.isBlank()) {
            resp.sendRedirect("booking?action=myBookings");
            return;
        }

        // Security: customers can only view their own tickets
        if (!"ADMIN".equals(role)) {
            var booking = bookingService.getBookingById(bookingId);
            if (booking == null || !customerId.equals(booking.getCustomerId())) {
                resp.sendRedirect("booking?action=myBookings");
                return;
            }
            // Only show tickets if payment is approved
            if (!"APPROVED".equals(booking.getPaymentStatus())) {
                req.setAttribute("paymentPending", true);
                req.setAttribute("booking", booking);
                req.getRequestDispatcher("/viewTickets.jsp").forward(req, resp);
                return;
            }
        }

        List<Ticket> tickets = ticketService.getTicketsByBooking(bookingId);
        req.setAttribute("tickets", tickets);
        req.setAttribute("bookingId", bookingId);
        req.getRequestDispatcher("/viewTickets.jsp").forward(req, resp);
    }

    // -------------------- Verify QR token (JSON API) --------------------
    private void handleVerify(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String qrToken = req.getParameter("qrToken");
        String eventId = req.getParameter("eventId");

        TicketService.VerifyResult result = ticketService.verifyAndRedeemTicket(qrToken, eventId);

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.print("{\"result\":\"" + result.name() + "\"}");
        out.flush();
    }
}
