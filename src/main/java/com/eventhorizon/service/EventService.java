package com.eventhorizon.service;

import com.eventhorizon.model.Event;
import com.eventhorizon.util.FileHandler;

import java.util.ArrayList;
import java.util.List;

/**
 * EventService - Handles all CRUD operations for Events.
 * Data is stored in / read from events.txt
 *
 * CRUD:
 *  CREATE  → addEvent()
 *  READ    → getAllEvents(), getEventById(), searchEvents()
 *  UPDATE  → updateEvent()
 *  DELETE  → deleteEvent()
 */
public class EventService {

    // ======================== CREATE ========================

    /**
     * Add a new event. Returns the generated Event ID.
     */
    public String addEvent(String title, String category, String date, String time,
                           String venue, double ticketPrice,
                           int totalSeats, String description) {
        String id = FileHandler.generateId(FileHandler.EVENTS_FILE, "EVT");
        Event event = new Event(id, title, category, date, time, venue,
                                ticketPrice, totalSeats, totalSeats,
                                description, "ACTIVE");
        FileHandler.appendLine(FileHandler.EVENTS_FILE, event.toFileString());
        return id;
    }

    // ======================== READ ========================

    /**
     * Returns all events from events.txt
     */
    public List<Event> getAllEvents() {
        List<String> lines = FileHandler.readAllLines(FileHandler.EVENTS_FILE);
        List<Event> events = new ArrayList<>();
        for (String line : lines) {
            try {
                events.add(Event.fromFileString(line));
            } catch (Exception e) {
                System.err.println("Skipping malformed event line: " + line);
            }
        }
        return events;
    }

    /**
     * Returns only ACTIVE events (for the public browsing page).
     */
    public List<Event> getActiveEvents() {
        List<Event> active = new ArrayList<>();
        for (Event e : getAllEvents()) {
            if ("ACTIVE".equals(e.getStatus())) active.add(e);
        }
        return active;
    }

    /**
     * Find a single event by its ID.
     */
    public Event getEventById(String eventId) {
        for (Event e : getAllEvents()) {
            if (e.getEventId().equals(eventId)) return e;
        }
        return null;
    }

    /**
     * Search events by title or category (case-insensitive).
     */
    public List<Event> searchEvents(String keyword) {
        List<Event> results = new ArrayList<>();
        String lower = keyword.toLowerCase();
        for (Event e : getActiveEvents()) {
            if (e.getTitle().toLowerCase().contains(lower) ||
                e.getCategory().toLowerCase().contains(lower) ||
                e.getVenue().toLowerCase().contains(lower)) {
                results.add(e);
            }
        }
        return results;
    }

    // ======================== UPDATE ========================

    /**
     * Update event details by ID. Preserves seat counts and status.
     */
    public boolean updateEvent(String eventId, String title, String category,
                               String date, String time, String venue,
                               double ticketPrice, String description) {
        Event event = getEventById(eventId);
        if (event == null) return false;

        event.setTitle(title);
        event.setCategory(category);
        event.setDate(date);
        event.setTime(time);
        event.setVenue(venue);
        event.setTicketPrice(ticketPrice);
        event.setDescription(description);

        return FileHandler.updateLine(FileHandler.EVENTS_FILE,
                eventId, event.toFileString(), "|");
    }

    /**
     * Cancel an event (sets status to CANCELLED).
     */
    public boolean cancelEvent(String eventId) {
        Event event = getEventById(eventId);
        if (event == null) return false;

        event.setStatus("CANCELLED");
        return FileHandler.updateLine(FileHandler.EVENTS_FILE,
                eventId, event.toFileString(), "|");
    }

    // ======================== DELETE ========================

    /**
     * Permanently delete an event by ID.
     */
    public boolean deleteEvent(String eventId) {
        return FileHandler.deleteLine(FileHandler.EVENTS_FILE, eventId, "|");
    }

    // ======================== SEAT MANAGEMENT ========================

    /**
     * Reduce available seats when a booking is made.
     * Called internally by BookingService.
     */
    public boolean reduceSeat(String eventId, int count) {
        Event event = getEventById(eventId);
        if (event == null || !event.bookSeats(count)) return false;
        return FileHandler.updateLine(FileHandler.EVENTS_FILE,
                eventId, event.toFileString(), "|");
    }

    /**
     * Restore seats when a booking is cancelled.
     */
    public boolean restoreSeat(String eventId, int count) {
        Event event = getEventById(eventId);
        if (event == null) return false;
        event.cancelSeats(count);
        return FileHandler.updateLine(FileHandler.EVENTS_FILE,
                eventId, event.toFileString(), "|");
    }
}
