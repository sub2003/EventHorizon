package com.eventhorizon.servlet;

import com.eventhorizon.model.Booking;
import com.eventhorizon.model.Ticket;
import com.eventhorizon.service.BookingService;
import com.eventhorizon.service.TicketService;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * TicketServlet
 *
 * GET  /ticket?action=viewTickets&bookingId=BKG001
 * GET  /ticket?action=qr&token=...
 * GET  /ticket?action=verify&token=...
 * GET  /ticket?action=scanPage
 * POST /ticket?action=verify
 */
public class TicketServlet extends HttpServlet {

    private static final String PUBLIC_BASE_URL =
            "https://glistening-light-production-f277.up.railway.app";

    private final TicketService ticketService = new TicketService();
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "viewTickets":
                if (session == null) {
                    resp.sendRedirect(req.getContextPath() + "/login.jsp");
                    return;
                }
                handleViewTickets(req, resp, session);
                break;

            case "qr":
                if (session == null) {
                    resp.sendRedirect(req.getContextPath() + "/login.jsp");
                    return;
                }
                handleQrImage(req, resp, session);
                break;

            case "verify":
                handlePublicVerifyPage(req, resp);
                break;

            case "scanPage":
                if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
                    resp.sendRedirect(req.getContextPath() + "/login.jsp");
                    return;
                }
                req.getRequestDispatcher("/admin/scanTicket.jsp").forward(req, resp);
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
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = req.getParameter("action");
        if ("verify".equals(action)) {
            if (!"ADMIN".equals(session.getAttribute("role"))) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            handleVerify(req, resp);
            return;
        }

        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
    }

    private void handleViewTickets(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {

        String bookingId = req.getParameter("bookingId");
        String customerId = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (bookingId == null || bookingId.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/booking?action=myBookings");
            return;
        }

        Booking booking = bookingService.getBookingById(bookingId);
        if (booking == null) {
            resp.sendRedirect(req.getContextPath() + "/booking?action=myBookings");
            return;
        }

        if (!"ADMIN".equals(role)) {
            if (!customerId.equals(booking.getCustomerId())) {
                resp.sendRedirect(req.getContextPath() + "/booking?action=myBookings");
                return;
            }

            if (!"APPROVED".equalsIgnoreCase(booking.getPaymentStatus())) {
                req.setAttribute("paymentPending", true);
                req.setAttribute("booking", booking);
                req.getRequestDispatcher("/viewTickets.jsp").forward(req, resp);
                return;
            }
        }

        List<Ticket> tickets = ticketService.getTicketsByBooking(bookingId);
        req.setAttribute("tickets", tickets);
        req.setAttribute("booking", booking);
        req.setAttribute("bookingId", bookingId);
        req.getRequestDispatcher("/viewTickets.jsp").forward(req, resp);
    }

    private void handleQrImage(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws IOException {

        String token = req.getParameter("token");
        String role = (String) session.getAttribute("role");
        String currentUserId = (String) session.getAttribute("userId");

        if (token == null || token.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing token");
            return;
        }

        boolean allowed = false;

        if ("ADMIN".equals(role)) {
            allowed = true;
        } else {
            List<Ticket> myTickets = ticketService.getTicketsByCustomer(currentUserId);
            for (Ticket t : myTickets) {
                if (token.equals(t.getQrToken())) {
                    allowed = true;
                    break;
                }
            }
        }

        if (!allowed) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            String qrData = PUBLIC_BASE_URL
                    + "/ticket?action=verify&token="
                    + URLEncoder.encode(token, "UTF-8");

            Map<EncodeHintType, Object> hints = new HashMap<>();
            hints.put(EncodeHintType.MARGIN, 1);

            BitMatrix matrix = new MultiFormatWriter().encode(
                    qrData,
                    BarcodeFormat.QR_CODE,
                    320,
                    320,
                    hints
            );

            resp.setContentType("image/png");
            MatrixToImageWriter.writeToStream(matrix, "PNG", resp.getOutputStream());
            resp.getOutputStream().flush();

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "QR generation failed");
        }
    }

    private void handlePublicVerifyPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("token");

        Ticket ticket = ticketService.getTicketByToken(token);
        boolean approved = ticketService.isTicketApprovedForPublicScan(token);

        req.setAttribute("ticket", ticket);
        req.setAttribute("approved", approved);
        req.getRequestDispatcher("/verifyTicket.jsp").forward(req, resp);
    }

    private void handleVerify(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String qrToken = req.getParameter("qrToken");
        String eventId = req.getParameter("eventId");

        TicketService.VerifyResult result = ticketService.verifyAndRedeemTicket(qrToken, eventId);

        String message;
        switch (result) {
            case VALID:
                message = "Approved";
                break;
            case ALREADY_USED:
                message = "Already used";
                break;
            case WRONG_EVENT:
                message = "Wrong event";
                break;
            default:
                message = "Not approved";
                break;
        }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.print("{\"result\":\"" + result.name() + "\",\"message\":\"" + message + "\"}");
        out.flush();
    }
}