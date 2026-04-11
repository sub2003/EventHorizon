package com.eventhorizon.servlet;

import com.eventhorizon.model.Event;
import com.eventhorizon.service.EventService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * EventServlet - Handles all event-related HTTP requests.
 *
 * URL Mappings:
 *   GET  /event?action=list          -> Public event list
 *   GET  /event?action=view&id=X     -> View single event
 *   GET  /event?action=search&q=X    -> Search events
 *   POST /event?action=add           -> Add event (Admin)
 *   POST /event?action=update        -> Update event (Admin)
 *   POST /event?action=delete        -> Delete event (Admin)
 *   POST /event?action=cancel        -> Cancel event (Admin)
 */
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
            case "search":
                searchEvents(req, resp);
                break;
            case "adminList":
                showAdminEventList(req, resp);
                break;
            default:
                resp.sendRedirect("events.jsp");
        }
    }

    // ==================== POST ====================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // All POST actions require admin
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect("login.jsp");
            return;
        }

        switch (action == null ? "" : action) {
            case "add":    handleAdd(req, resp);    break;
            case "update": handleUpdate(req, resp); break;
            case "delete": handleDelete(req, resp); break;
            case "cancel": handleCancel(req, resp); break;
            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    // -------------------- List all active events --------------------
    private void showEventList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("events", eventService.getActiveEvents());
        req.getRequestDispatcher("/events.jsp").forward(req, resp);
    }

    // -------------------- Event detail --------------------
    private void showEventDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String id = req.getParameter("id");
        Event event = eventService.getEventById(id);
        if (event == null) { resp.sendRedirect("event?action=list"); return; }
        req.setAttribute("event", event);
        req.getRequestDispatcher("/eventDetail.jsp").forward(req, resp);
    }

    // -------------------- Search --------------------
    private void searchEvents(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("q");
        List<Event> results = (keyword == null || keyword.isEmpty())
                ? eventService.getActiveEvents()
                : eventService.searchEvents(keyword);
        req.setAttribute("events", results);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("/events.jsp").forward(req, resp);
    }

    // -------------------- Admin: list all --------------------
    private void showAdminEventList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("events", eventService.getAllEvents());
        req.getRequestDispatcher("/admin/events.jsp").forward(req, resp);
    }

    // -------------------- Add event --------------------
    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String title       = req.getParameter("title");
        String category    = req.getParameter("category");
        String date        = req.getParameter("date");
        String time        = req.getParameter("time");
        String venue       = req.getParameter("venue");
        double price       = Double.parseDouble(req.getParameter("ticketPrice"));
        int    seats       = Integer.parseInt(req.getParameter("totalSeats"));
        String description = req.getParameter("description");

        String newId = eventService.addEvent(title, category, date, time,
                                             venue, price, seats, description);
        resp.sendRedirect("event?action=adminList&msg=added&id=" + newId);
    }

    // -------------------- Update event --------------------
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String eventId     = req.getParameter("eventId");
        String title       = req.getParameter("title");
        String category    = req.getParameter("category");
        String date        = req.getParameter("date");
        String time        = req.getParameter("time");
        String venue       = req.getParameter("venue");
        double price       = Double.parseDouble(req.getParameter("ticketPrice"));
        String description = req.getParameter("description");

        boolean ok = eventService.updateEvent(eventId, title, category, date,
                                              time, venue, price, description);
        resp.sendRedirect("event?action=adminList&msg=" + (ok ? "updated" : "error"));
    }

    // -------------------- Delete event --------------------
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String eventId = req.getParameter("eventId");
        eventService.deleteEvent(eventId);
        resp.sendRedirect("event?action=adminList&msg=deleted");
    }

    // -------------------- Cancel event --------------------
    private void handleCancel(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String eventId = req.getParameter("eventId");
        eventService.cancelEvent(eventId);
        resp.sendRedirect("event?action=adminList&msg=cancelled");
    }
}
