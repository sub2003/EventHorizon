package com.eventhorizon.service;

import com.eventhorizon.model.Admin;
import com.eventhorizon.model.Customer;
import com.eventhorizon.model.User;
import com.eventhorizon.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserService {

    // ======================== CREATE ========================

    public boolean registerCustomer(String name, String email,
                                    String password, String phone) {
        if (getUserByEmail(email) != null) return false;

        String id = generateUserId("USR");

        String sql = "INSERT INTO users (user_id, name, email, password, phone, role) "
                + "VALUES (?, ?, ?, ?, ?, 'CUSTOMER')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setString(5, phone);

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("registerCustomer error: " + e.getMessage());
            return false;
        }
    }

    public boolean registerAdmin(String name, String email,
                                 String password, String phone) {
        if (getUserByEmail(email) != null) return false;

        String id = generateUserId("ADM");

        String sql = "INSERT INTO users (user_id, name, email, password, phone, role) "
                + "VALUES (?, ?, ?, ?, ?, 'ADMIN')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setString(5, phone);

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("registerAdmin error: " + e.getMessage());
            return false;
        }
    }

    // ======================== ADMIN REQUEST FLOW ========================

    public boolean submitAdminRequest(String requesterAdminId,
                                      String name,
                                      String email,
                                      String password,
                                      String phone) {
        if (requesterAdminId == null || requesterAdminId.trim().isEmpty()) return false;

        if (getUserByEmail(email) != null) return false;

        String pendingCheckSql = "SELECT request_id FROM admin_requests WHERE requested_email = ? AND status = 'PENDING'";
        String insertSql = "INSERT INTO admin_requests "
                + "(request_id, requester_admin_id, requested_name, requested_email, requested_password, requested_phone, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(pendingCheckSql);
             PreparedStatement insertPs = conn.prepareStatement(insertSql)) {

            checkPs.setString(1, email);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next()) {
                return false;
            }

            String requestId = generateAdminRequestId();

            insertPs.setString(1, requestId);
            insertPs.setString(2, requesterAdminId);
            insertPs.setString(3, name);
            insertPs.setString(4, email);
            insertPs.setString(5, password);
            insertPs.setString(6, phone);

            return insertPs.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("submitAdminRequest error: " + e.getMessage());
            return false;
        }
    }

    public List<Map<String, String>> getPendingAdminRequests() {
        List<Map<String, String>> requests = new ArrayList<>();

        String sql = "SELECT * FROM admin_requests WHERE status = 'PENDING' ORDER BY requested_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("requestId", rs.getString("request_id"));
                row.put("requesterAdminId", rs.getString("requester_admin_id"));
                row.put("requestedName", rs.getString("requested_name"));
                row.put("requestedEmail", rs.getString("requested_email"));
                row.put("requestedPhone", rs.getString("requested_phone"));
                row.put("status", rs.getString("status"));
                row.put("requestedAt", rs.getString("requested_at"));
                requests.add(row);
            }

        } catch (SQLException e) {
            System.err.println("getPendingAdminRequests error: " + e.getMessage());
        }

        return requests;
    }

    public boolean approveAdminRequest(String requestId, String approverAdminId) {
        String selectSql = "SELECT * FROM admin_requests WHERE request_id = ? AND status = 'PENDING'";
        String insertAdminSql = "INSERT INTO users (user_id, name, email, password, phone, role) "
                + "VALUES (?, ?, ?, ?, ?, 'ADMIN')";
        String updateRequestSql = "UPDATE admin_requests "
                + "SET status = 'APPROVED', reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP "
                + "WHERE request_id = ?";

        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement selectPs = conn.prepareStatement(selectSql)) {
                selectPs.setString(1, requestId);
                ResultSet rs = selectPs.executeQuery();

                if (!rs.next()) {
                    conn.rollback();
                    return false;
                }

                String requesterAdminId = rs.getString("requester_admin_id");
                String name = rs.getString("requested_name");
                String email = rs.getString("requested_email");
                String password = rs.getString("requested_password");
                String phone = rs.getString("requested_phone");

                if (requesterAdminId != null && requesterAdminId.equals(approverAdminId)) {
                    conn.rollback();
                    return false;
                }

                if (getUserByEmail(email) != null) {
                    conn.rollback();
                    return false;
                }

                String newAdminId = generateUserId("ADM", conn);

                try (PreparedStatement insertPs = conn.prepareStatement(insertAdminSql);
                     PreparedStatement updatePs = conn.prepareStatement(updateRequestSql)) {

                    insertPs.setString(1, newAdminId);
                    insertPs.setString(2, name);
                    insertPs.setString(3, email);
                    insertPs.setString(4, password);
                    insertPs.setString(5, phone);
                    insertPs.executeUpdate();

                    updatePs.setString(1, approverAdminId);
                    updatePs.setString(2, requestId);
                    updatePs.executeUpdate();
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("approveAdminRequest error: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ignored) {
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    public boolean rejectAdminRequest(String requestId, String approverAdminId) {
        String selectSql = "SELECT requester_admin_id FROM admin_requests WHERE request_id = ? AND status = 'PENDING'";
        String updateSql = "UPDATE admin_requests "
                + "SET status = 'REJECTED', reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP "
                + "WHERE request_id = ? AND status = 'PENDING'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement selectPs = conn.prepareStatement(selectSql);
             PreparedStatement updatePs = conn.prepareStatement(updateSql)) {

            selectPs.setString(1, requestId);
            ResultSet rs = selectPs.executeQuery();

            if (!rs.next()) {
                return false;
            }

            String requesterAdminId = rs.getString("requester_admin_id");

            if (requesterAdminId != null && requesterAdminId.equals(approverAdminId)) {
                return false;
            }

            updatePs.setString(1, approverAdminId);
            updatePs.setString(2, requestId);

            return updatePs.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("rejectAdminRequest error: " + e.getMessage());
            return false;
        }
    }

    // ======================== READ ========================

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                users.add(mapRowToUser(rs, conn));
            }

        } catch (SQLException e) {
            System.err.println("getAllUsers error: " + e.getMessage());
        }

        return users;
    }

    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'CUSTOMER'";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                String id = rs.getString("user_id");
                int bookingCount = getBookingCount(id, conn);

                customers.add(new Customer(
                        id,
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        bookingCount
                ));
            }

        } catch (SQLException e) {
            System.err.println("getAllCustomers error: " + e.getMessage());
        }

        return customers;
    }

    public User getUserById(String userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRowToUser(rs, conn);
            }

        } catch (SQLException e) {
            System.err.println("getUserById error: " + e.getMessage());
        }

        return null;
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRowToUser(rs, conn);
            }

        } catch (SQLException e) {
            System.err.println("getUserByEmail error: " + e.getMessage());
        }

        return null;
    }

    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRowToUser(rs, conn);
            }

        } catch (SQLException e) {
            System.err.println("login error: " + e.getMessage());
        }

        return null;
    }

    // ======================== UPDATE ========================

    public boolean updateUser(String userId, String newName,
                              String newPhone, String newPassword) {
        String sql = "UPDATE users SET name=?, phone=?, password=? WHERE user_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newName);
            ps.setString(2, newPhone);
            ps.setString(3, newPassword);
            ps.setString(4, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("updateUser error: " + e.getMessage());
            return false;
        }
    }

    // ======================== DELETE ========================

    public boolean deleteUser(String userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("deleteUser error: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteUserByEmail(String email) {
        String sql = "DELETE FROM users WHERE email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("deleteUserByEmail error: " + e.getMessage());
            return false;
        }
    }

    // ======================== HELPERS ========================

    private int getBookingCount(String customerId, Connection conn) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE customer_id = ? AND status = 'CONFIRMED'";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println("getBookingCount error: " + e.getMessage());
        }

        return 0;
    }

    private User mapRowToUser(ResultSet rs, Connection conn) throws SQLException {
        String role = rs.getString("role");
        String id = rs.getString("user_id");
        String name = rs.getString("name");
        String email = rs.getString("email");
        String pass = rs.getString("password");
        String phone = rs.getString("phone");

        if ("ADMIN".equals(role)) {
            return new Admin(id, name, email, pass, phone, "STANDARD");
        } else {
            int bookingCount = getBookingCount(id, conn);
            return new Customer(id, name, email, pass, phone, bookingCount);
        }
    }

    private String generateUserId(String prefix) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return generateUserId(prefix, conn);
        } catch (SQLException e) {
            System.err.println("generateUserId error: " + e.getMessage());
            return prefix + System.currentTimeMillis();
        }
    }

    private String generateUserId(String prefix, Connection conn) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if ("ADM".equals(prefix)) {
                ps.setString(1, "ADMIN");
            } else {
                ps.setString(1, "CUSTOMER");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return String.format("%s%03d", prefix, rs.getInt(1) + 1);
            }

        } catch (SQLException e) {
            System.err.println("generateUserId(conn) error: " + e.getMessage());
        }

        return prefix + System.currentTimeMillis();
    }

    private String generateAdminRequestId() {
        String sql = "SELECT COUNT(*) FROM admin_requests";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            if (rs.next()) {
                return String.format("ARQ%03d", rs.getInt(1) + 1);
            }

        } catch (SQLException e) {
            System.err.println("generateAdminRequestId error: " + e.getMessage());
        }

        return "ARQ" + System.currentTimeMillis();
    }
}