package com.eventhorizon.service;

import com.eventhorizon.model.Booking;
import com.eventhorizon.model.Event;
import com.eventhorizon.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * BookingService - CRUD operations for Bookings using MySQL.
 *
 * CREATE → createBooking()
 * READ   → getAllBookings(), getBookingById(), getBookingsByCustomer(), getBookingsByEvent()
 * UPDATE → cancelBooking()
 * DELETE → (handled via cancel - soft delete)
 */
public class BookingService {

    private final EventService eventService = new EventService();

    // ==================== CREATE ====================

    /**
     * Create a new booking.
     * Automatically deducts seats from the event.
     * Returns booking ID or null if failed.
     */
    public String createBooking(String customerId, String eventId, int numberOfTickets) {
        // Check event exists and has enough seats
        Event event = eventService.getEventById(eventId);
        if (event == null)                         return null;
        if (!"ACTIVE".equals(event.getStatus()))   return null;
        if (event.getAvailableSeats() < numberOfTickets) return null;

        // Deduct seats from event
        boolean seated = eventService.reduceSeat(eventId, numberOfTickets);
        if (!seated) return null;

        // Save booking
        String id     = generateId();
        double total  = event.getTicketPrice() * numberOfTickets;
        String today  = LocalDate.now().toString();

        String sql = "INSERT INTO bookings (booking_id, customer_id, event_id, event_title, "
                   + "number_of_tickets, total_amount, booking_date, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, 'CONFIRMED')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.setString(2, customerId);
            ps.setString(3, eventId);
            ps.setString(4, event.getTitle());
            ps.setInt(5, numberOfTickets);
            ps.setDouble(6, total);
            ps.setString(7, today);
            ps.executeUpdate();
            return id;

        } catch (SQLException e) {
            System.err.println("createBooking error: " + e.getMessage());
            // Restore seats if booking save failed
            eventService.restoreSeat(eventId, numberOfTickets);
            return null;
        }
    }

    // ==================== READ ====================

    /** Get all bookings (Admin view). */
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings ORDER BY booking_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) bookings.add(mapRowToBooking(rs));

        } catch (SQLException e) {
            System.err.println("getAllBookings error: " + e.getMessage());
        }
        return bookings;
    }

    /** Get a booking by ID. */
    public Booking getBookingById(String bookingId) {
        String sql = "SELECT * FROM bookings WHERE booking_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRowToBooking(rs);

        } catch (SQLException e) {
            System.err.println("getBookingById error: " + e.getMessage());
        }
        return null;
    }

    /** Get all bookings by a specific customer. */
    public List<Booking> getBookingsByCustomer(String customerId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE customer_id = ? ORDER BY booking_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) bookings.add(mapRowToBooking(rs));

        } catch (SQLException e) {
            System.err.println("getBookingsByCustomer error: " + e.getMessage());
        }
        return bookings;
    }

    /** Get all bookings for a specific event (Admin view). */
    public List<Booking> getBookingsByEvent(String eventId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE event_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, eventId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) bookings.add(mapRowToBooking(rs));

        } catch (SQLException e) {
            System.err.println("getBookingsByEvent error: " + e.getMessage());
        }
        return bookings;
    }

    // ==================== CANCEL (UPDATE status) ====================

    /** Cancel a booking and restore event seats. */
    public boolean cancelBooking(String bookingId) {
        Booking booking = getBookingById(bookingId);
        if (booking == null)                          return false;
        if ("CANCELLED".equals(booking.getStatus())) return false;

        // Restore seats
        eventService.restoreSeat(booking.getEventId(), booking.getNumberOfTickets());

        // Update status to CANCELLED
        String sql = "UPDATE bookings SET status='CANCELLED' WHERE booking_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bookingId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("cancelBooking error: " + e.getMessage());
            return false;
        }
    }

    // ==================== HELPERS ====================

    private Booking mapRowToBooking(ResultSet rs) throws SQLException {
        return new Booking(
            rs.getString("booking_id"),
            rs.getString("customer_id"),
            rs.getString("event_id"),
            rs.getString("event_title"),
            rs.getInt("number_of_tickets"),
            rs.getDouble("total_amount"),
            rs.getString("booking_date"),
            rs.getString("status")
        );
    }

    private String generateId() {
        String sql = "SELECT COUNT(*) FROM bookings";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return String.format("BKG%03d", rs.getInt(1) + 1);
            }
        } catch (SQLException e) {
            System.err.println("generateId error: " + e.getMessage());
        }
        return "BKG" + System.currentTimeMillis();
    }
}
