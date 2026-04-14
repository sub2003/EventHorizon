package com.eventhorizon.service;

import com.eventhorizon.model.Event;
import com.eventhorizon.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventService {

    public String addEvent(String title, String category, String date, String time,
                           String venue, double ticketPrice, int totalSeats,
                           String description, byte[] imageData, String imageType) {

        String id = generateId();

        String sql = "INSERT INTO events (event_id, title, category, date, time, venue, " +
                "ticket_price, total_seats, available_seats, description, status, image_data, image_type) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'ACTIVE', ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.setString(2, title);
            ps.setString(3, category);
            ps.setString(4, date);
            ps.setString(5, time);
            ps.setString(6, venue);
            ps.setDouble(7, ticketPrice);
            ps.setInt(8, totalSeats);
            ps.setInt(9, totalSeats);
            ps.setString(10, description);

            if (imageData != null && imageData.length > 0) {
                ps.setBytes(11, imageData);
                ps.setString(12, imageType);
            } else {
                ps.setNull(11, Types.BLOB);
                ps.setNull(12, Types.VARCHAR);
            }

            ps.executeUpdate();
            return id;

        } catch (SQLException e) {
            System.err.println("addEvent error: " + e.getMessage());
            return null;
        }
    }

    public List<Event> getAllEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events ORDER BY date ASC, time ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                events.add(mapRowToEvent(rs));
            }

        } catch (SQLException e) {
            System.err.println("getAllEvents error: " + e.getMessage());
        }

        return events;
    }

    public List<Event> getActiveEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE status = 'ACTIVE' ORDER BY date ASC, time ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                events.add(mapRowToEvent(rs));
            }

        } catch (SQLException e) {
            System.err.println("getActiveEvents error: " + e.getMessage());
        }

        return events;
    }

    public Event getEventById(String eventId) {
        String sql = "SELECT * FROM events WHERE event_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, eventId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRowToEvent(rs);
            }

        } catch (SQLException e) {
            System.err.println("getEventById error: " + e.getMessage());
        }

        return null;
    }

    public List<Event> searchEvents(String keyword) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE status = 'ACTIVE' AND " +
                "(title LIKE ? OR category LIKE ? OR venue LIKE ?) ORDER BY date ASC, time ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String q = "%" + keyword + "%";
            ps.setString(1, q);
            ps.setString(2, q);
            ps.setString(3, q);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                events.add(mapRowToEvent(rs));
            }

        } catch (SQLException e) {
            System.err.println("searchEvents error: " + e.getMessage());
        }

        return events;
    }

    public boolean updateEvent(String eventId, String title, String category,
                               String date, String time, String venue,
                               double ticketPrice, String description) {

        String sql = "UPDATE events SET title=?, category=?, date=?, time=?, " +
                "venue=?, ticket_price=?, description=? WHERE event_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, category);
            ps.setString(3, date);
            ps.setString(4, time);
            ps.setString(5, venue);
            ps.setDouble(6, ticketPrice);
            ps.setString(7, description);
            ps.setString(8, eventId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("updateEvent error: " + e.getMessage());
            return false;
        }
    }

    public boolean updateEventWithImage(String eventId, String title, String category,
                                        String date, String time, String venue,
                                        double ticketPrice, String description,
                                        byte[] imageData, String imageType) {

        String sql = "UPDATE events SET title=?, category=?, date=?, time=?, " +
                "venue=?, ticket_price=?, description=?, image_data=?, image_type=? WHERE event_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, category);
            ps.setString(3, date);
            ps.setString(4, time);
            ps.setString(5, venue);
            ps.setDouble(6, ticketPrice);
            ps.setString(7, description);

            if (imageData != null && imageData.length > 0) {
                ps.setBytes(8, imageData);
                ps.setString(9, imageType);
            } else {
                ps.setNull(8, Types.BLOB);
                ps.setNull(9, Types.VARCHAR);
            }

            ps.setString(10, eventId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("updateEventWithImage error: " + e.getMessage());
            return false;
        }
    }

    public boolean cancelEvent(String eventId) {
        String sql = "UPDATE events SET status='CANCELLED' WHERE event_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, eventId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("cancelEvent error: " + e.getMessage());
            return false;
        }
    }

    public boolean reduceSeat(String eventId, int count) {
        String sql = "UPDATE events SET available_seats = available_seats - ? " +
                "WHERE event_id = ? AND available_seats >= ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, count);
            ps.setString(2, eventId);
            ps.setInt(3, count);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("reduceSeat error: " + e.getMessage());
            return false;
        }
    }

    public boolean restoreSeat(String eventId, int count) {
        String sql = "UPDATE events SET available_seats = available_seats + ? WHERE event_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, count);
            ps.setString(2, eventId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("restoreSeat error: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteEvent(String eventId) {
        String sql = "DELETE FROM events WHERE event_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, eventId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("deleteEvent error: " + e.getMessage());
            return false;
        }
    }

    private Event mapRowToEvent(ResultSet rs) throws SQLException {
        Event event = new Event(
                rs.getString("event_id"),
                rs.getString("title"),
                rs.getString("category"),
                rs.getString("date"),
                rs.getString("time"),
                rs.getString("venue"),
                rs.getDouble("ticket_price"),
                rs.getInt("total_seats"),
                rs.getInt("available_seats"),
                rs.getString("description"),
                rs.getString("status"),
                rs.getString("image_path")
        );

        event.setImageData(rs.getBytes("image_data"));
        event.setImageType(rs.getString("image_type"));

        return event;
    }

    private String generateId() {
        String sql = "SELECT MAX(CAST(SUBSTRING(event_id, 4) AS UNSIGNED)) FROM events WHERE event_id LIKE 'EVT%'";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            int next = 1;
            if (rs.next()) {
                next = rs.getInt(1) + 1;
            }
            return String.format("EVT%03d", next);

        } catch (SQLException e) {
            System.err.println("generateId error: " + e.getMessage());
            return "EVT" + System.currentTimeMillis();
        }
    }
}