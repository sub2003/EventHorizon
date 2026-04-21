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

            if (issue.getBookingId() != null) {
                ps.setInt(2, issue.getBookingId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            if (issue.getTicketId() != null) {
                ps.setInt(3, issue.getTicketId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

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
                    if (keys.next()) {
                        issue.setIssueId(keys.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Issue> getAllIssues() {
        return getIssuesByFilter(null, null, null);
    }

    public List<Issue> getIssuesByAdminType(String adminType) {
        return getIssuesByAdminView(adminType, null, null);
    }

    public List<Issue> getIssuesByAdminView(String adminType, String categoryFilter, String statusFilter) {
        if ("EVENTS_AND_BOOKINGS_ADMIN".equalsIgnoreCase(adminType)) {
            return getIssuesByFilter("EVENTS_ADMIN,BOOKINGS_ADMIN", categoryFilter, statusFilter);
        }
        if ("CORE_ADMIN".equalsIgnoreCase(adminType)) {
            return getIssuesByFilter(null, categoryFilter, statusFilter);
        }
        return getIssuesByFilter(adminType, categoryFilter, statusFilter);
    }

    public List<Issue> getIssuesByFilter(String adminTypeFilter, String categoryFilter, String statusFilter) {
        List<Issue> list = new ArrayList<>();

        categoryFilter = normalizeFilter(categoryFilter);
        statusFilter = normalizeFilter(statusFilter);

        StringBuilder sb = new StringBuilder(
                "SELECT i.* FROM issues i WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (adminTypeFilter != null && !adminTypeFilter.trim().isEmpty()) {
            String[] types = adminTypeFilter.split(",");
            sb.append("AND i.assigned_admin_type IN (");
            for (int t = 0; t < types.length; t++) {
                if (t > 0) {
                    sb.append(",");
                }
                sb.append("?");
                params.add(types[t].trim());
            }
            sb.append(") ");
        }

        if (categoryFilter != null) {
            sb.append("AND i.category = ? ");
            params.add(categoryFilter);
        }

        if (statusFilter != null) {
            sb.append("AND i.status = ? ");
            params.add(statusFilter);
        }

        sb.append("ORDER BY i.issue_id DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Issue issue = mapIssue(rs);

                    // Fallback so JSP always has something to display
                    if (issue.getUserName() == null || issue.getUserName().trim().isEmpty()) {
                        issue.setUserName(issue.getCustomerEmail() != null && !issue.getCustomerEmail().trim().isEmpty()
                                ? issue.getCustomerEmail()
                                : "Customer #" + issue.getUserId());
                    }

                    list.add(issue);
                }
            }

        } catch (SQLException e) {
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

                    if (issue.getUserName() == null || issue.getUserName().trim().isEmpty()) {
                        issue.setUserName(issue.getCustomerEmail() != null && !issue.getCustomerEmail().trim().isEmpty()
                                ? issue.getCustomerEmail()
                                : "Customer #" + issue.getUserId());
                    }

                    issue.setReplies(getRepliesByIssueId(issueId));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return issue;
    }

    public List<Issue> getIssuesByUser(int userId) {
        List<Issue> list = new ArrayList<>();
        String sql = "SELECT * FROM issues WHERE user_id = ? ORDER BY issue_id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Issue issue = mapIssue(rs);

                    if (issue.getUserName() == null || issue.getUserName().trim().isEmpty()) {
                        issue.setUserName(issue.getCustomerEmail() != null && !issue.getCustomerEmail().trim().isEmpty()
                                ? issue.getCustomerEmail()
                                : "Customer #" + issue.getUserId());
                    }

                    list.add(issue);
                }
            }

        } catch (SQLException e) {
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

        } catch (SQLException e) {
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

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countByStatus(String status, String adminType) {
        StringBuilder sb = new StringBuilder("SELECT COUNT(*) FROM issues WHERE status = ?");
        List<Object> params = new ArrayList<>();
        params.add(status);

        if (adminType != null && !adminType.trim().isEmpty()
                && !"CORE_ADMIN".equalsIgnoreCase(adminType)) {

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
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

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

        // Because issues.user_id is numeric while users.user_id is string in your app,
        // do not rely on SQL join here.
        i.setUserName(rs.getString("customer_email"));

        return i;
    }

    private String normalizeFilter(String value) {
        if (value == null) {
            return null;
        }

        value = value.trim();
        if (value.isEmpty()) {
            return null;
        }

        if ("all categories".equalsIgnoreCase(value) || "all statuses".equalsIgnoreCase(value)) {
            return null;
        }

        return value;
    }
}