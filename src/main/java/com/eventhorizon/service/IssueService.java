package com.eventhorizon.service;

import com.eventhorizon.model.Issue;
import com.eventhorizon.model.IssueReply;
import com.eventhorizon.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IssueService {

    public static String resolveAdminType(String category) {
        switch (category) {
            case "Booking Problem":
            case "Payment Verification Issue":
            case "Ticket Not Received":
            case "QR Code Not Working":
            case "Refund Request":
            case "Seat Availability Problem":
                return "BOOKINGS_ADMIN";

            case "Event Information Error":
            case "Event Cancellation Complaint":
                return "EVENTS_ADMIN";

            case "Account Login Problem":
            case "Profile / Registration Problem":
            case "Website Technical Issue":
            case "General Inquiry":
            case "Other":
                return "CORE_ADMIN";

            default:
                return "CORE_ADMIN";
        }
    }

    public boolean submitIssue(Issue issue) {
        String sql = "INSERT INTO issues (user_id, booking_id, ticket_id, category, subject, " +
                "description, priority, assigned_admin_type, status, customer_email, customer_phone) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'OPEN', ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, issue.getUserId());

            if (issue.getBookingId() != null) ps.setInt(2, issue.getBookingId());
            else ps.setNull(2, Types.INTEGER);

            if (issue.getTicketId() != null) ps.setInt(3, issue.getTicketId());
            else ps.setNull(3, Types.INTEGER);

            ps.setString(4, issue.getCategory());
            ps.setString(5, issue.getSubject());
            ps.setString(6, issue.getDescription());
            ps.setString(7, issue.getPriority());
            ps.setString(8, issue.getAssignedAdminType());
            ps.setString(9, issue.getCustomerEmail());
            ps.setString(10, issue.getCustomerPhone());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) issue.setIssueId(keys.getInt(1));
                }
                return true;
            }
        } catch (Exception e) {
            System.err.println("[IssueService] submitIssue error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<Issue> getAllIssues() {
        return getIssuesByFilter(null, null, null);
    }

    public List<Issue> getIssuesByAdminType(String adminType) {
        if ("EVENTS_AND_BOOKINGS_ADMIN".equals(adminType)) {
            return getIssuesByFilter("EVENTS_ADMIN,BOOKINGS_ADMIN", null, null);
        }
        return getIssuesByFilter(adminType, null, null);
    }

    public List<Issue> getIssuesByFilter(String adminTypeFilter, String categoryFilter, String statusFilter) {
        List<Issue> list = new ArrayList<>();

        // Plain SELECT * — no JOIN to avoid schema mismatch errors
        StringBuilder sb = new StringBuilder("SELECT * FROM issues WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (adminTypeFilter != null && !adminTypeFilter.trim().isEmpty()) {
            String[] types = adminTypeFilter.split(",");
            sb.append("AND assigned_admin_type IN (");
            for (int i = 0; i < types.length; i++) {
                if (i > 0) sb.append(",");
                sb.append("?");
                params.add(types[i].trim());
            }
            sb.append(") ");
        }

        if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
            sb.append("AND category = ? ");
            params.add(categoryFilter.trim());
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sb.append("AND status = ? ");
            params.add(statusFilter.trim());
        }

        sb.append("ORDER BY created_at DESC");

        System.out.println("[IssueService] Query: " + sb);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    try {
                        list.add(mapIssue(rs));
                    } catch (Exception rowEx) {
                        // Per-row catch: one bad row won't kill the whole list
                        System.err.println("[IssueService] Failed mapping issue_id="
                                + safeGetInt(rs, "issue_id") + " — " + rowEx.getMessage());
                        rowEx.printStackTrace();
                    }
                }
            }

            System.out.println("[IssueService] Loaded " + list.size() + " issues.");

        } catch (Exception e) {
            System.err.println("[IssueService] getIssuesByFilter error: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public Issue getIssueById(int issueId) {
        String sql = "SELECT * FROM issues WHERE issue_id = ?";
        Issue issue = null;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    issue = mapIssue(rs);
                    issue.setReplies(getRepliesByIssueId(issueId));
                }
            }

        } catch (Exception e) {
            System.err.println("[IssueService] getIssueById error: " + e.getMessage());
            e.printStackTrace();
        }

        return issue;
    }

    public List<Issue> getIssuesByUser(int userId) {
        List<Issue> list = new ArrayList<>();
        String sql = "SELECT * FROM issues WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapIssue(rs));
                }
            }

        } catch (Exception e) {
            System.err.println("[IssueService] getIssuesByUser error: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateStatus(int issueId, String status) {
        String sql = "UPDATE issues SET status = ? WHERE issue_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, issueId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[IssueService] updateStatus error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean addReply(IssueReply reply) {
        String sql = "INSERT INTO issue_replies (issue_id, admin_id, reply_message) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reply.getIssueId());
            ps.setInt(2, reply.getAdminId());
            ps.setString(3, reply.getReplyMessage());

            if (ps.executeUpdate() > 0) {
                updateStatusIfOpen(reply.getIssueId());
                return true;
            }

        } catch (Exception e) {
            System.err.println("[IssueService] addReply error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private void updateStatusIfOpen(int issueId) {
        String sql = "UPDATE issues SET status = 'IN_PROGRESS' WHERE issue_id = ? AND status = 'OPEN'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId);
            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("[IssueService] updateStatusIfOpen error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<IssueReply> getRepliesByIssueId(int issueId) {
        List<IssueReply> list = new ArrayList<>();
        String sql = "SELECT * FROM issue_replies WHERE issue_id = ? ORDER BY replied_at ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    IssueReply reply = new IssueReply();
                    reply.setReplyId(rs.getInt("reply_id"));
                    reply.setIssueId(rs.getInt("issue_id"));
                    reply.setAdminId(rs.getInt("admin_id"));
                    reply.setReplyMessage(rs.getString("reply_message"));
                    reply.setRepliedAt(rs.getTimestamp("replied_at"));
                    reply.setAdminName("Admin #" + rs.getInt("admin_id"));
                    list.add(reply);
                }
            }

        } catch (Exception e) {
            System.err.println("[IssueService] getRepliesByIssueId error: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public int countByStatus(String status, String adminType) {
        StringBuilder sb = new StringBuilder("SELECT COUNT(*) FROM issues WHERE status = ?");
        List<Object> params = new ArrayList<>();
        params.add(status);

        if (adminType != null && !adminType.trim().isEmpty() && !"CORE_ADMIN".equalsIgnoreCase(adminType)) {
            if ("EVENTS_AND_BOOKINGS_ADMIN".equalsIgnoreCase(adminType)) {
                sb.append(" AND assigned_admin_type IN (?, ?)");
                params.add("EVENTS_ADMIN");
                params.add("BOOKINGS_ADMIN");
            } else {
                sb.append(" AND assigned_admin_type = ?");
                params.add(adminType);
            }
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (Exception e) {
            System.err.println("[IssueService] countByStatus error: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    private Issue mapIssue(ResultSet rs) throws SQLException {
        Issue i = new Issue();
        i.setIssueId(rs.getInt("issue_id"));
        i.setUserId(rs.getInt("user_id"));

        // Safe extraction — avoids ClassCastException when DB column is BIGINT
        Object bookingIdObj = rs.getObject("booking_id");
        i.setBookingId(bookingIdObj != null ? ((Number) bookingIdObj).intValue() : null);

        Object ticketIdObj = rs.getObject("ticket_id");
        i.setTicketId(ticketIdObj != null ? ((Number) ticketIdObj).intValue() : null);

        i.setCategory(rs.getString("category"));
        i.setSubject(rs.getString("subject"));
        i.setDescription(rs.getString("description"));
        i.setPriority(rs.getString("priority"));
        i.setAssignedAdminType(rs.getString("assigned_admin_type"));
        i.setStatus(rs.getString("status"));
        i.setCustomerEmail(rs.getString("customer_email"));
        i.setCustomerPhone(rs.getString("customer_phone"));
        i.setCreatedAt(rs.getTimestamp("created_at"));
        i.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Use email as the display name — no JOIN required
        i.setUserName(rs.getString("customer_email"));

        return i;
    }

    private int safeGetInt(ResultSet rs, String col) {
        try { return rs.getInt(col); } catch (Exception e) { return -1; }
    }
}
