package com.eventhorizon.servlet;

import com.eventhorizon.model.Event;
import com.eventhorizon.service.EventService;
import com.eventhorizon.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class EventServlet extends HttpServlet {

    private final EventService eventService = new EventService();

    // ==================== GET ====================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        switch (action == null ? "list" : action) {

            case "list":
                showEventList(req, resp);
                break;

            case "view":
                showEventDetail(req, resp);
                break;

            case "adminList":
                requireEventAdmin(req, resp);
                if (resp.isCommitted()) return;
                showAdminEventList(req, resp);
                break;

            case "image":
                serveEventImage(req, resp);
                break;

            default:
                resp.sendRedirect("event?action=list");
        }
    }

    // ==================== POST ====================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // 🔥 IMPORTANT: permission check
        String permission = (String) session.getAttribute("adminPermission");
        if (!UserService.hasEventAccess(permission)) {
            resp.sendRedirect("admin/dashboard.jsp?error=noEventPermission");
            return;
        }

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {

            case "add":
                handleAdd(req, resp);
                break;

            case "update":
                handleUpdate(req, resp);
                break;

            case "delete":
                handleDelete(req, resp);
                break;

            case "cancel":
                handleCancel(req, resp);
                break;

            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // ==================== SECURITY ====================
    private void requireEventAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String permission = (String) session.getAttribute("adminPermission");

        if (!UserService.hasEventAccess(permission)) {
            resp.sendRedirect("admin/dashboard.jsp?error=noEventPermission");
        }
    }

    // ==================== EXISTING METHODS ====================
    private void showEventList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Event> events = eventService.getActiveEvents();
        req.setAttribute("events", events);
        req.getRequestDispatcher("/events.jsp").forward(req, resp);
    }

    private void showEventDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Event event = eventService.getEventById(req.getParameter("id"));
        req.setAttribute("event", event);
        req.getRequestDispatcher("/eventDetail.jsp").forward(req, resp);
    }

    private void showAdminEventList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("events", eventService.getAllEvents());
        req.getRequestDispatcher("/admin/addEvent.jsp").forward(req, resp);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String title = req.getParameter("title");
        String category = req.getParameter("category");
        String date = req.getParameter("date");
        String time = req.getParameter("time");
        String venue = req.getParameter("venue");
        String description = req.getParameter("description");

        double price = Double.parseDouble(req.getParameter("ticketPrice"));
        int seats = Integer.parseInt(req.getParameter("totalSeats"));

        Part imagePart = req.getPart("eventImage");

        byte[] imageData = null;
        String imageType = null;

        if (imagePart != null && imagePart.getSize() > 0) {
            imageData = imagePart.getInputStream().readAllBytes();
            imageType = imagePart.getContentType();
        }

        eventService.addEvent(
                title, category, date, time, venue,
                price, seats, description,
                imageData, imageType
        );

        resp.sendRedirect("event?action=adminList&msg=added");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String eventId = req.getParameter("eventId");
        String title = req.getParameter("title");
        String category = req.getParameter("category");
        String date = req.getParameter("date");
        String time = req.getParameter("time");
        String venue = req.getParameter("venue");
        String description = req.getParameter("description");

        double price = Double.parseDouble(req.getParameter("ticketPrice"));

        Part imagePart = req.getPart("eventImage");

        boolean success;

        if (imagePart != null && imagePart.getSize() > 0) {
            byte[] imageData = imagePart.getInputStream().readAllBytes();
            String imageType = imagePart.getContentType();

            success = eventService.updateEventWithImage(
                    eventId, title, category, date, time,
                    venue, price, description,
                    imageData, imageType
            );
        } else {
            success = eventService.updateEvent(
                    eventId, title, category, date, time,
                    venue, price, description
            );
        }

        resp.sendRedirect("event?action=adminList&msg=" + (success ? "updated" : "error"));
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String eventId = req.getParameter("eventId");
        eventService.deleteEvent(eventId);

        resp.sendRedirect("event?action=adminList&msg=deleted");
    }

    private void handleCancel(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String eventId = req.getParameter("eventId");
        eventService.cancelEvent(eventId);

        resp.sendRedirect("event?action=adminList&msg=cancelled");
    }

    private void serveEventImage(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        Event event = eventService.getEventById(req.getParameter("id"));

        if (event == null || event.getImageData() == null) {
            resp.sendError(404);
            return;
        }

        resp.setContentType(event.getImageType());
        resp.getOutputStream().write(event.getImageData());
    }
}