package com.eventhorizon.service;

import com.eventhorizon.model.Booking;
import com.eventhorizon.model.Event;
import com.eventhorizon.util.FileHandler;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * BookingService - Handles all CRUD operations for Bookings.
 * Data is stored in / read from bookings.txt
 *
 * CRUD:
 *  CREATE  → createBooking()
 *  READ    → getAllBookings(), getBookingById(), getBookingsByCustomer()
 *  UPDATE  → (status changes via cancelBooking)
 *  DELETE  → cancelBooking()
 */
public class BookingService {

    private final EventService eventService = new EventService();

    // ======================== CREATE ========================

    /**
     * Create a new booking. Automatically reduces available seats on the event.
     * Returns the generated Booking ID, or null if booking failed.
     */
    public String createBooking(String customerId, String eventId, int numberOfTickets) {
        // Fetch the event
        Event event = eventService.getEventById(eventId);
        if (event == null)                       return null;
        if (!"ACTIVE".equals(event.getStatus())) return null;
        if (event.getAvailableSeats() < numberOfTickets) return null;

        // Deduct seats from event
        boolean seated = eventService.reduceSeat(eventId, numberOfTickets);
        if (!seated) return null;

        // Create booking record
        String id     = FileHandler.generateId(FileHandler.BOOKINGS_FILE, "BKG");
        double total  = event.getTicketPrice() * numberOfTickets;
        String today  = LocalDate.now().toString();

        Booking booking = new Booking(id, customerId, eventId,
                                      event.getTitle(), numberOfTickets,
                                      total, today, "CONFIRMED");
        FileHandler.appendLine(FileHandler.BOOKINGS_FILE, booking.toFileString());
        return id;
    }

    // ======================== READ ========================

    /**
     * Returns all bookings from bookings.txt
     */
    public List<Booking> getAllBookings() {
        List<String> lines = FileHandler.readAllLines(FileHandler.BOOKINGS_FILE);
        List<Booking> bookings = new ArrayList<>();
        for (String line : lines) {
            try {
                bookings.add(Booking.fromFileString(line));
            } catch (Exception e) {
                System.err.println("Skipping malformed booking line: " + line);
            }
        }
        return bookings;
    }

    /**
     * Get a booking by its ID.
     */
    public Booking getBookingById(String bookingId) {
        for (Booking b : getAllBookings()) {
            if (b.getBookingId().equals(bookingId)) return b;
        }
        return null;
    }

    /**
     * Get all bookings made by a specific customer.
     */
    public List<Booking> getBookingsByCustomer(String customerId) {
        List<Booking> result = new ArrayList<>();
        for (Booking b : getAllBookings()) {
            if (b.getCustomerId().equals(customerId)) result.add(b);
        }
        return result;
    }

    /**
     * Get all bookings for a specific event (admin view).
     */
    public List<Booking> getBookingsByEvent(String eventId) {
        List<Booking> result = new ArrayList<>();
        for (Booking b : getAllBookings()) {
            if (b.getEventId().equals(eventId)) result.add(b);
        }
        return result;
    }

    // ======================== CANCEL (Update status) ========================

    /**
     * Cancel a booking: sets status to CANCELLED and restores event seats.
     */
    public boolean cancelBooking(String bookingId) {
        Booking booking = getBookingById(bookingId);
        if (booking == null)                          return false;
        if ("CANCELLED".equals(booking.getStatus())) return false;

        // Restore seats to the event
        eventService.restoreSeat(booking.getEventId(), booking.getNumberOfTickets());

        // Update booking status
        booking.setStatus("CANCELLED");
        return FileHandler.updateLine(FileHandler.BOOKINGS_FILE,
                bookingId, booking.toFileString(), "|");
    }
}
