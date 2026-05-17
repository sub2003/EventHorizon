package com.eventhorizon.service;

import com.eventhorizon.model.EventTicketType;
import com.eventhorizon.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class EventTicketTypeService {

    // ─── Read ────────────────────────────────────────────────────────────────

    /** Fetch all ticket types for an event using its own connection (read-only / outside a tx). */
    public List<EventTicketType> getByEvent(String eventId) {
        List<EventTicketType> list = new ArrayList<>();
        String sql = "SELECT * FROM event_ticket_types WHERE event_id = ? ORDER BY ticket_type_id ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            System.err.println("getByEvent error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Fetch all ticket types for an event using an existing connection (inside a transaction).
     * Always use this overload when you already hold a transactional Connection.
     */
    public List<EventTicketType> getByEvent(String eventId, Connection conn) throws SQLException {
        List<EventTicketType> list = new ArrayList<>();
        String sql = "SELECT * FROM event_ticket_types WHERE event_id = ? ORDER BY ticket_type_id ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public EventTicketType getById(int ticketTypeId) {
        String sql = "SELECT * FROM event_ticket_types WHERE ticket_type_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ticketTypeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }

        } catch (SQLException e) {
            System.err.println("getById error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public EventTicketType getById(int ticketTypeId, Connection conn) throws SQLException {
        String sql = "SELECT * FROM event_ticket_types WHERE ticket_type_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticketTypeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    // ─── Write ───────────────────────────────────────────────────────────────

    public void addTicketType(String eventId, String typeName, double price, int seats, Connection conn)
            throws SQLException {
        String sql = "INSERT INTO event_ticket_types (event_id, type_name, price, total_seats, available_seats) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, eventId);
            ps.setString(2, typeName);
            ps.setDouble(3, price);
            ps.setInt(4, seats);
            ps.setInt(5, seats);  // brand-new type: all seats available
            ps.executeUpdate();
        }
    }

    /**
     * Smart UPDATE for the EDIT-EVENT flow.
     *
     * For each row submitted from the form:
     *   - If ticketTypeId is non-empty → UPDATE that row in place.
     *     available_seats is recalculated as: newTotal − bookedCount
     *     so existing bookings are never lost.
     *   - If ticketTypeId is empty   → INSERT a brand-new row.
     *
     * Ticket types that were present in the DB but are no longer in the
     * submitted form are DELETED — but only after a FK safety check.
     * If a type cannot be deleted (because tickets still reference it),
     * the delete is skipped and a warning is logged rather than rolling
     * back the whole transaction.
     *
     * @param eventId the event being edited
     * @param ids     hidden ticketTypeId values from the form (empty string for new rows)
     * @param names   typeName values
     * @param prices  typePrice values
     * @param seats   typeSeats (total) values
     * @param conn    the current transactional connection
     */
    public void updateTicketTypes(String eventId,
                                  String[] ids,
                                  String[] names,
                                  String[] prices,
                                  String[] seats,
                                  Connection conn) throws SQLException {

        // Load the current state of all types for this event (within the same tx)
        List<EventTicketType> existing = getByEvent(eventId, conn);

        // Track which existing IDs the form still contains (to know what to delete later)
        Set<Integer> keptIds = new HashSet<>();

        // Determine the shortest array length so we never go out of bounds
        int len = safeLen(ids, names, prices, seats);

        for (int i = 0; i < len; i++) {
            String idStr    = ids[i]    == null ? "" : ids[i].trim();
            String name     = names[i]  == null ? "" : names[i].trim();
            String priceStr = prices[i] == null ? "" : prices[i].trim();
            String seatStr  = seats[i]  == null ? "" : seats[i].trim();

            // Skip completely blank rows (browser might submit empty inputs)
            if (name.isEmpty() || priceStr.isEmpty() || seatStr.isEmpty()) continue;

            double price;
            int    totalSeats;
            try {
                price      = Double.parseDouble(priceStr);
                totalSeats = Integer.parseInt(seatStr);
            } catch (NumberFormatException e) {
                // Malformed number from form — skip this row safely
                System.err.println("updateTicketTypes: bad number at index " + i +
                        " price='" + priceStr + "' seats='" + seatStr + "'");
                continue;
            }

            if (price < 0 || totalSeats <= 0) continue;

            if (!idStr.isEmpty()) {
                // ── Existing row: UPDATE in place ─────────────────────────────
                int typeId;
                try {
                    typeId = Integer.parseInt(idStr);
                } catch (NumberFormatException e) {
                    System.err.println("updateTicketTypes: bad ticketTypeId '" + idStr + "' at index " + i);
                    continue;
                }

                keptIds.add(typeId);

                // Find the old record so we can preserve the booked-seats count
                EventTicketType old = existing.stream()
                        .filter(t -> t.getTicketTypeId() == typeId)
                        .findFirst()
                        .orElse(null);

                // bookedCount = how many seats are already sold for this type
                int bookedCount = (old != null)
                        ? Math.max(0, old.getTotalSeats() - old.getAvailableSeats())
                        : 0;

                // new available = new total minus already-booked (never negative)
                int newAvailable = Math.max(0, totalSeats - bookedCount);

                String updateSql =
                        "UPDATE event_ticket_types " +
                                "SET type_name = ?, price = ?, total_seats = ?, available_seats = ? " +
                                "WHERE ticket_type_id = ? AND event_id = ?";

                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setString(1, name);
                    ps.setDouble(2, price);
                    ps.setInt(3, totalSeats);
                    ps.setInt(4, newAvailable);
                    ps.setInt(5, typeId);
                    ps.setString(6, eventId);
                    ps.executeUpdate();
                }

            } else {
                // ── New row: INSERT ───────────────────────────────────────────
                addTicketType(eventId, name, price, totalSeats, conn);
            }
        }

        // ── Delete rows that were removed from the form ───────────────────────
        for (EventTicketType old : existing) {
            if (!keptIds.contains(old.getTicketTypeId())) {
                String delSql = "DELETE FROM event_ticket_types WHERE ticket_type_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(delSql)) {
                    ps.setInt(1, old.getTicketTypeId());
                    ps.executeUpdate();
                } catch (SQLException e) {
                    // FK constraint: tickets table still references this type.
                    // Log it but do not abort the transaction — the type stays.
                    System.err.println("updateTicketTypes: could not delete ticket_type_id="
                            + old.getTicketTypeId() + " (likely FK constraint): " + e.getMessage());
                }
            }
        }

        // ── Sync the events summary row ───────────────────────────────────────
        refreshEventSummary(eventId, conn);
    }

    /**
     * Used ONLY for the ADD-EVENT flow where all ticket types are brand new
     * (there are no existing rows to preserve, so delete+reinsert is safe).
     *
     * Do NOT call this from the edit-event flow — use updateTicketTypes instead.
     */
    public void replaceTicketTypes(String eventId,
                                   String[] names,
                                   String[] prices,
                                   String[] seats,
                                   Connection conn) throws SQLException {

        // Safe to delete all: the event was just inserted, no bookings can exist yet
        try (PreparedStatement del = conn.prepareStatement(
                "DELETE FROM event_ticket_types WHERE event_id = ?")) {
            del.setString(1, eventId);
            del.executeUpdate();
        }

        if (names == null || prices == null || seats == null) {
            refreshEventSummary(eventId, conn);
            return;
        }

        int len = Math.min(names.length, Math.min(prices.length, seats.length));
        for (int i = 0; i < len; i++) {
            String name     = names[i]  == null ? "" : names[i].trim();
            String priceStr = prices[i] == null ? "" : prices[i].trim();
            String seatStr  = seats[i]  == null ? "" : seats[i].trim();

            if (name.isEmpty() || priceStr.isEmpty() || seatStr.isEmpty()) continue;

            double price;
            int    totalSeats;
            try {
                price      = Double.parseDouble(priceStr);
                totalSeats = Integer.parseInt(seatStr);
            } catch (NumberFormatException e) {
                System.err.println("replaceTicketTypes: bad number at index " + i +
                        " price='" + priceStr + "' seats='" + seatStr + "'");
                continue;
            }

            if (price < 0 || totalSeats <= 0) continue;

            addTicketType(eventId, name, price, totalSeats, conn);
        }

        refreshEventSummary(eventId, conn);
    }

    // ─── Seat management ─────────────────────────────────────────────────────

    public boolean reduceSeat(int ticketTypeId, int count, Connection conn) throws SQLException {
        String sql =
                "UPDATE event_ticket_types " +
                        "SET available_seats = available_seats - ? " +
                        "WHERE ticket_type_id = ? AND available_seats >= ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, count);
            ps.setInt(2, ticketTypeId);
            ps.setInt(3, count);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean restoreSeat(int ticketTypeId, int count, Connection conn) throws SQLException {
        String sql =
                "UPDATE event_ticket_types " +
                        "SET available_seats = LEAST(total_seats, available_seats + ?) " +
                        "WHERE ticket_type_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, count);
            ps.setInt(2, ticketTypeId);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── Summary sync ────────────────────────────────────────────────────────

    /**
     * Recalculates and writes ticket_price (lowest), total_seats, and available_seats
     * back to the events row so the events table is always consistent.
     */
    public void refreshEventSummary(String eventId, Connection conn) throws SQLException {
        String summarySql =
                "SELECT COALESCE(MIN(price), 0)           AS min_price, " +
                        "       COALESCE(SUM(total_seats), 0)      AS total_seats, " +
                        "       COALESCE(SUM(available_seats), 0)  AS available_seats " +
                        "FROM event_ticket_types WHERE event_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(summarySql)) {
            ps.setString(1, eventId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double minPrice      = rs.getDouble("min_price");
                    int    totalSeats    = rs.getInt("total_seats");
                    int    availableSeats = rs.getInt("available_seats");

                    try (PreparedStatement upd = conn.prepareStatement(
                            "UPDATE events " +
                                    "SET ticket_price = ?, total_seats = ?, available_seats = ? " +
                                    "WHERE event_id = ?")) {
                        upd.setDouble(1, minPrice);
                        upd.setInt(2, totalSeats);
                        upd.setInt(3, availableSeats);
                        upd.setString(4, eventId);
                        upd.executeUpdate();
                    }
                }
            }
        }
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────

    private int safeLen(String[]... arrays) {
        int min = Integer.MAX_VALUE;
        for (String[] a : arrays) {
            if (a == null) return 0;
            min = Math.min(min, a.length);
        }
        return min == Integer.MAX_VALUE ? 0 : min;
    }

    private EventTicketType mapRow(ResultSet rs) throws SQLException {
        return new EventTicketType(
                rs.getInt("ticket_type_id"),
                rs.getString("event_id"),
                rs.getString("type_name"),
                rs.getDouble("price"),
                rs.getInt("total_seats"),
                rs.getInt("available_seats")
        );
    }
}
