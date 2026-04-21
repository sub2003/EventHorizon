package com.eventhorizon.service;

import com.eventhorizon.model.Issue;
import com.eventhorizon.model.IssueReply;
import com.eventhorizon.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IssueService {

    // ─── Category → Admin type routing ──────────────────────────────────────

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

    // ─── Submit new issue ────────────────────────────────────────────────────

    public boolean submitIssue(Issue issue) {
        String sql = "INSERT INTO issues (user_id, booking_id, ticket_id, category, subject, " +
                     "description, priority, assigned_admin_type, status, customer_email, customer_phone) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'OPEN', ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, issue.getUserId());
            if (issue.getBookingId() != null) ps.setInt(2, issue.getBookingId()); else ps.setNull(2, Types.INTEGER);
            if (issue.getTicketId()  != null) ps.setInt(3, issue.getTicketId());  else ps.setNull(3, Types.INTEGER);
            ps.setString(4,  issue.getCategory());
            ps.setString(5,  issue.getSubject());
            ps.setString(6,  issue.getDescription());
            ps.setString(7,  issue.getPriority());
            ps.setString(8,  issue.getAssignedAdminType());
            ps.setString(9,  issue.getCustomerEmail());
            ps.setString(10, issue.getCustomerPhone());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) issue.setIssueId(keys.getInt(1));
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ─── Get all issues (admin full view) ────────────────────────────────────

    public List<Issue> getAllIssues() {
        return getIssuesByFilter(null, null, null);
    }

    // ─── Get issues filtered by admin type ───────────────────────────────────

    public List<Issue> getIssuesByAdminType(String adminType) {
        // EVENTS_AND_BOOKINGS_ADMIN can see both
        if ("EVENTS_AND_BOOKINGS_ADMIN".equals(adminType)) {
            return getIssuesByFilter("EVENTS_ADMIN,BOOKINGS_ADMIN", null, null);
        }
        return getIssuesByFilter(adminType, null, null);
    }

    // ─── Get issues with optional category + status filter ───────────────────

    public List<Issue> getIssuesByFilter(String adminTypeFilter, String categoryFilter, String statusFilter) {
        List<Issue> list  = new ArrayList<>();
        StringBuilder sb  = new StringBuilder(
            "SELECT i.*, u.name AS user_name FROM issues i " +
            "LEFT JOIN users u ON i.user_id = u.user_id WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (adminTypeFilter != null && !adminTypeFilter.isEmpty()) {
            String[] types = adminTypeFilter.split(",");
            sb.append("AND i.assigned_admin_type IN (");
            for (int t = 0; t < types.length; t++) {
                sb.append(t == 0 ? "?" : ",?");
                params.add(types[t].trim());
            }
            sb.append(") ");
        }
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sb.append("AND i.category = ? ");
            params.add(categoryFilter);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sb.append("AND i.status = ? ");
            params.add(statusFilter);
        }
        sb.append("ORDER BY i.created_at DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapIssue(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── Get single issue with replies ───────────────────────────────────────

    public Issue getIssueById(int issueId) {
        String sql = "SELECT i.*, u.name AS user_name FROM issues i " +
                     "LEFT JOIN users u ON i.user_id = u.user_id WHERE i.issue_id = ?";
        Issue issue = null;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, issueId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                issue = mapIssue(rs);
                issue.setReplies(getRepliesByIssueId(issueId));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return issue;
    }

    // ─── Get issues by user (customer view) ──────────────────────────────────

    public List<Issue> getIssuesByUser(int userId) {
        List<Issue> list = new ArrayList<>();
        String sql = "SELECT i.*, u.name AS user_name FROM issues i " +
                     "LEFT JOIN users u ON i.user_id = u.user_id " +
                     "WHERE i.user_id = ? ORDER BY i.created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapIssue(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── Update issue status ─────────────────────────────────────────────────

    public boolean updateStatus(int issueId, String status) {
        String sql = "UPDATE issues SET status = ? WHERE issue_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, issueId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ─── Add admin reply ─────────────────────────────────────────────────────

    public boolean addReply(IssueReply reply) {
        String sql = "INSERT INTO issue_replies (issue_id, admin_id, reply_message) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reply.getIssueId());
            ps.setInt(2, reply.getAdminId());
            ps.setString(3, reply.getReplyMessage());
            if (ps.executeUpdate() > 0) {
                // Auto-move to IN_PROGRESS if still OPEN
                updateStatusIfOpen(reply.getIssueId());
                return true;
            }
        } catch (SQLException e) {
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ─── Get replies for an issue ─────────────────────────────────────────────

    public List<IssueReply> getRepliesByIssueId(int issueId) {
        List<IssueReply> list = new ArrayList<>();
        String sql = "SELECT r.*, u.name AS admin_name FROM issue_replies r " +
                     "LEFT JOIN users u ON r.admin_id = u.user_id " +
                     "WHERE r.issue_id = ? ORDER BY r.replied_at ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, issueId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                IssueReply reply = new IssueReply();
                reply.setReplyId(rs.getInt("reply_id"));
                reply.setIssueId(rs.getInt("issue_id"));
                reply.setAdminId(rs.getInt("admin_id"));
                reply.setReplyMessage(rs.getString("reply_message"));
                reply.setRepliedAt(rs.getTimestamp("replied_at"));
                reply.setAdminName(rs.getString("admin_name"));
                list.add(reply);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── Count helpers for dashboard stats ───────────────────────────────────

    public int countByStatus(String status, String adminType) {
        StringBuilder sb = new StringBuilder("SELECT COUNT(*) FROM issues WHERE status = ?");
        if (adminType != null && !adminType.isEmpty() && !"CORE_ADMIN".equals(adminType)) {
            sb.append(" AND assigned_admin_type = ?");
        }
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            ps.setString(1, status);
            if (adminType != null && !adminType.isEmpty() && !"CORE_ADMIN".equals(adminType)) {
                ps.setString(2, adminType);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ─── Mapper ───────────────────────────────────────────────────────────────

    private Issue mapIssue(ResultSet rs) throws SQLException {
        Issue i = new Issue();
        i.setIssueId(rs.getInt("issue_id"));
        i.setUserId(rs.getInt("user_id"));
        i.setBookingId((Integer) rs.getObject("booking_id"));
        i.setTicketId((Integer) rs.getObject("ticket_id"));
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
        try { i.setUserName(rs.getString("user_name")); } catch (SQLException ignored) {}
        return i;
    }
}
