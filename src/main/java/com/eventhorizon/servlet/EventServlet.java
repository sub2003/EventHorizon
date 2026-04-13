package com.eventhorizon.servlet;

import com.eventhorizon.model.Event;
import com.eventhorizon.service.EventService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class EventServlet extends HttpServlet {

    private final EventService eventService = new EventService();

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
            case "search":
                showEventList(req, resp);
                break;
            case "adminList":
                showAdminEventList(req, resp);
                break;
            default:
                resp.sendRedirect("event?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect("login.jsp");
            return;
        }

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
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    private void showEventList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");

        if (keyword != null) keyword = keyword.trim();
        if (category != null) category = category.trim();

        List<Event> allEvents = eventService.getActiveEvents();
        List<Event> filteredEvents = new ArrayList<>();

        boolean hasKeyword = keyword != null && !keyword.isEmpty();
        boolean hasCategory = category != null && !category.isEmpty();

        if (!hasKeyword && !hasCategory) {
            filteredEvents = allEvents;
        } else {
            String lowerKeyword = hasKeyword ? keyword.toLowerCase() : "";

            for (Event event : allEvents) {
                boolean matchesKeyword = true;
                boolean matchesCategory = true;

                if (hasKeyword) {
                    String title = event.getTitle() != null ? event.getTitle().toLowerCase() : "";
                    String venue = event.getVenue() != null ? event.getVenue().toLowerCase() : "";

                    matchesKeyword = title.contains(lowerKeyword) || venue.contains(lowerKeyword);
                }

                if (hasCategory) {
                    String eventCategory = event.getCategory() != null ? event.getCategory() : "";
                    matchesCategory = eventCategory.equalsIgnoreCase(category);
                }

                if (matchesKeyword && matchesCategory) {
                    filteredEvents.add(event);
                }
            }
        }

        req.setAttribute("events", filteredEvents);
        req.setAttribute("keyword", keyword != null ? keyword : "");
        req.setAttribute("category", category != null ? category : "");

        req.getRequestDispatcher("/events.jsp").forward(req, resp);
    }

    private void showEventDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = req.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            resp.sendRedirect("event?action=list");
            return;
        }

        Event event = eventService.getEventById(id.trim());

        if (event == null) {
            resp.sendRedirect("event?action=list");
            return;
        }

        req.setAttribute("event", event);
        req.getRequestDispatcher("/eventDetail.jsp").forward(req, resp);
    }

    private void showAdminEventList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect("login.jsp");
            return;
        }

        List<Event> events = eventService.getAllEvents();
        req.setAttribute("events", events);

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

        String imagePath = saveUploadedImage(req.getPart("eventImage"));

        String newId = eventService.addEvent(
                title,
                category,
                date,
                time,
                venue,
                price,
                seats,
                description,
                imagePath
        );

        resp.sendRedirect("event?action=adminList&msg=" + (newId != null ? "added" : "error"));
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
        boolean ok;

        if (imagePart != null && imagePart.getSize() > 0) {
            String imagePath = saveUploadedImage(imagePart);
            ok = eventService.updateEventWithImage(
                    eventId,
                    title,
                    category,
                    date,
                    time,
                    venue,
                    price,
                    description,
                    imagePath
            );
        } else {
            ok = eventService.updateEvent(
                    eventId,
                    title,
                    category,
                    date,
                    time,
                    venue,
                    price,
                    description
            );
        }

        resp.sendRedirect("event?action=adminList&msg=" + (ok ? "updated" : "error"));
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

    private String saveUploadedImage(Part imagePart) throws IOException {
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }

        String originalFileName = imagePart.getSubmittedFileName();
        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            return null;
        }

        String extension = "";
        int dotIndex = originalFileName.lastIndexOf('.');
        if (dotIndex >= 0) {
            extension = originalFileName.substring(dotIndex);
        }

        String uniqueFileName = UUID.randomUUID() + extension;

        String uploadPath = getServletContext().getRealPath("/uploads/events");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        File savedFile = new File(uploadDir, uniqueFileName);
        imagePart.write(savedFile.getAbsolutePath());

        return "uploads/events/" + uniqueFileName;
    }
}