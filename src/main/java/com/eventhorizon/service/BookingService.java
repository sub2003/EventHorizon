package com.eventhorizon.service;

import com.eventhorizon.model.Booking;
import com.eventhorizon.model.Event;
import com.eventhorizon.model.Ticket;
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

    private final EventService  eventService  = new EventService();
    private final TicketService ticketService = new TicketService();

    // ==================== CREATE ====================

    /**
     * Create a new booking (status = CONFIRMED, payment_status = PENDING).
     * Seats are deducted immediately; they are restored if payment is rejected.
     * Returns booking ID or null on failure.
     */
    public String createBooking(String customerId, String eventId,
                                int numberOfTickets, String paymentReference) {
        Event event = eventService.getEventById(eventId);
        if (event == null)                                return null;
        if (!"ACTIVE".equals(event.getStatus()))          return null;
        if (event.getAvailableSeats() < numberOfTickets)  return null;

        boolean seated = eventService.reduceSeat(eventId, numberOfTickets);
        if (!seated) return null;

        String id    = generateId();
        double total = event.getTicketPrice() * numberOfTickets;
        String today = LocalDate.now().toString();

        String sql = "INSERT INTO bookings "
                   + "(booking_id, customer_id, event_id, event_title, "
                   + "number_of_tickets, total_amount, booking_date, status, "
                   + "payment_status, payment_reference) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, 'CONFIRMED', 'PENDING', ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.setString(2, customerId);
            ps.setString(3, eventId);
            ps.setString(4, event.getTitle());
            ps.setInt(5, numberOfTickets);
            ps.setDouble(6, total);
            ps.setString(7, today);
            ps.setString(8, paymentReference != null ? paymentReference.trim() : "");
            ps.executeUpdate();
            return id;

        } catch (SQLException e) {
            System.err.println("createBooking error: " + e.getMessage());
            eventService.restoreSeat(eventId, numberOfTickets);
            return null;
        }
    }

    /** Backward-compatible overload (no payment reference). */
    public String createBooking(String customerId, String eventId, int numberOfTickets) {
        return createBooking(customerId, eventId, numberOfTickets, "");
    }

    // ==================== APPROVE PAYMENT ====================

    /**
     * Admin approves a payment → payment_status = APPROVED → generate tickets.
     * Returns true on success.
     */
    public boolean approveBooking(String bookingId) {
        Booking booking = getBookingById(bookingId);
        if (booking == null) return false;
        if ("APPROVED".equals(booking.getPaymentStatus())) return false; // already done

        String sql = "UPDATE bookings SET payment_status='APPROVED' WHERE booking_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bookingId);
            if (ps.executeUpdate() == 0) return false;

        } catch (SQLException e) {
            System.err.println("approveBooking error: " + e.getMessage());
            return false;
        }

        // Generate individual tickets
        List<Ticket> tickets = ticketService.generateTickets(
                bookingId, booking.getEventId(),
                booking.getCustomerId(), booking.getNumberOfTickets());
        return !tickets.isEmpty();
    }

    /**
     * Admin rejects a payment → payment_status = REJECTED, status = CANCELLED,
     * seats restored.
     */
    public boolean rejectBooking(String bookingId) {
        Booking booking = getBookingById(bookingId);
        if (booking == null) return false;

        eventService.restoreSeat(booking.getEventId(), booking.getNumberOfTickets());

        String sql = "UPDATE bookings SET payment_status='REJECTED', status='CANCELLED' "
                   + "WHERE booking_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bookingId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("rejectBooking error: " + e.getMessage());
            return false;
        }
    }

    // ==================== PENDING BOOKINGS ====================

    /** Get bookings where payment is still PENDING (admin approval queue). */
    public List<Booking> getPendingBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE payment_status='PENDING' "
                   + "AND status='CONFIRMED' ORDER BY booking_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRowToBooking(rs));
        } catch (SQLException e) {
            System.err.println("getPendingBookings error: " + e.getMessage());
        }
        return list;
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
        String payStatus = null;
        String payRef    = null;
        try { payStatus = rs.getString("payment_status"); } catch (SQLException ignored) {}
        try { payRef    = rs.getString("payment_reference"); } catch (SQLException ignored) {}
        return new Booking(
            rs.getString("booking_id"),
            rs.getString("customer_id"),
            rs.getString("event_id"),
            rs.getString("event_title"),
            rs.getInt("number_of_tickets"),
            rs.getDouble("total_amount"),
            rs.getString("booking_date"),
            rs.getString("status"),
            payStatus != null ? payStatus : "PENDING",
            payRef
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
