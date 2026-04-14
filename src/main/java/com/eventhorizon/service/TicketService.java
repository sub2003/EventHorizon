package com.eventhorizon.service;

import com.eventhorizon.model.Ticket;
import com.eventhorizon.util.DatabaseConnection;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * TicketService – generates and validates secure QR-code tickets.
 *
 * Security model:
 *   qrToken = HMAC-SHA256( SECRET_KEY, "ticketId|bookingId|eventId|customerId" )
 *
 *   A scanner decodes the QR payload (which is the qrToken), then calls
 *   verifyAndRedeemTicket(qrToken, eventId). The server looks up the token in DB,
 *   checks it belongs to the supplied eventId (so cross-event re-use is impossible),
 *   and marks it used so it cannot be redeemed twice.
 *   Any externally fabricated QR will simply not exist in the DB → rejected.
 */
public class TicketService {

    // Change this to a long random string in production and store it in an env var.
    private static final String SECRET_KEY =
            System.getenv("TICKET_HMAC_SECRET") != null
            ? System.getenv("TICKET_HMAC_SECRET")
            : "EH@T1cket$3cr3tK3y_2026!#Horizon";

    // ==================== GENERATE ====================

    /**
     * Generate individual tickets for every seat in a booking.
     * Called after admin approves payment.
     * Returns the list of created Ticket objects, or empty list on failure.
     */
    public List<Ticket> generateTickets(String bookingId, String eventId,
                                        String customerId, int count) {
        List<Ticket> tickets = new ArrayList<>();

        String sql = "INSERT INTO tickets (ticket_id, booking_id, event_id, customer_id, qr_token, is_used) "
                   + "VALUES (?, ?, ?, ?, ?, 0)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < count; i++) {
                String ticketId = UUID.randomUUID().toString();
                String qrToken  = buildQrToken(ticketId, bookingId, eventId, customerId);

                ps.setString(1, ticketId);
                ps.setString(2, bookingId);
                ps.setString(3, eventId);
                ps.setString(4, customerId);
                ps.setString(5, qrToken);
                ps.addBatch();

                Ticket t = new Ticket(ticketId, bookingId, eventId, customerId, qrToken, false, null);
                tickets.add(t);
            }

            ps.executeBatch();

        } catch (SQLException e) {
            System.err.println("generateTickets error: " + e.getMessage());
            tickets.clear();
        }

        return tickets;
    }

    // ==================== READ ====================

    /** Get all tickets for a specific booking. */
    public List<Ticket> getTicketsByBooking(String bookingId) {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT * FROM tickets WHERE booking_id = ? ORDER BY created_at";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) tickets.add(mapRow(rs));

        } catch (SQLException e) {
            System.err.println("getTicketsByBooking error: " + e.getMessage());
        }
        return tickets;
    }

    /** Get all tickets for a specific customer (across all bookings). */
    public List<Ticket> getTicketsByCustomer(String customerId) {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT * FROM tickets WHERE customer_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) tickets.add(mapRow(rs));

        } catch (SQLException e) {
            System.err.println("getTicketsByCustomer error: " + e.getMessage());
        }
        return tickets;
    }

    // ==================== VERIFY & REDEEM ====================

    /**
     * Result codes returned to the scanner.
     */
    public enum VerifyResult {
        VALID,          // First scan – grant entry
        ALREADY_USED,   // Token exists but was already redeemed
        WRONG_EVENT,    // Token valid but belongs to a different event
        INVALID         // Token not found in DB (fake / tampered QR)
    }

    /**
     * Look up the QR token in DB; validate event match; mark as used if valid.
     * @param qrToken  the decoded string from the QR image
     * @param eventId  the event ID this scanner is set up for
     */
    public VerifyResult verifyAndRedeemTicket(String qrToken, String eventId) {
        if (qrToken == null || qrToken.isBlank()) return VerifyResult.INVALID;

        String selectSql = "SELECT * FROM tickets WHERE qr_token = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(selectSql)) {

            ps.setString(1, qrToken.trim());
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) return VerifyResult.INVALID;

            Ticket t = mapRow(rs);

            // Wrong event check
            if (!eventId.equals(t.getEventId())) return VerifyResult.WRONG_EVENT;

            // Already used check
            if (t.isUsed()) return VerifyResult.ALREADY_USED;

            // Mark used
            String updateSql = "UPDATE tickets SET is_used = 1 WHERE ticket_id = ?";
            try (PreparedStatement upd = conn.prepareStatement(updateSql)) {
                upd.setString(1, t.getTicketId());
                upd.executeUpdate();
            }

            return VerifyResult.VALID;

        } catch (SQLException e) {
            System.err.println("verifyAndRedeemTicket error: " + e.getMessage());
            return VerifyResult.INVALID;
        }
    }

    // ==================== HELPERS ====================

    /**
     * Build a unique, unforgeable QR token using HMAC-SHA256.
     * The payload encodes ticketId, bookingId, eventId and customerId so that
     * a token is cryptographically bound to a specific event.
     */
    public static String buildQrToken(String ticketId, String bookingId,
                                       String eventId, String customerId) {
        try {
            String payload = ticketId + "|" + bookingId + "|" + eventId + "|" + customerId;
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec keySpec = new SecretKeySpec(SECRET_KEY.getBytes("UTF-8"), "HmacSHA256");
            mac.init(keySpec);
            byte[] raw = mac.doFinal(payload.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : raw) sb.append(String.format("%02x", b));
            // Prefix with ticketId (first 8 chars) so scanner can send it back
            return ticketId.replace("-", "").substring(0, 8).toUpperCase() + "_" + sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("HMAC generation failed", e);
        }
    }

    private Ticket mapRow(ResultSet rs) throws SQLException {
        return new Ticket(
            rs.getString("ticket_id"),
            rs.getString("booking_id"),
            rs.getString("event_id"),
            rs.getString("customer_id"),
            rs.getString("qr_token"),
            rs.getInt("is_used") == 1,
            rs.getString("created_at")
        );
    }
}
