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

    public boolean registerCustomer(String name, String email, String password, String phone) {
        name = safeTrim(name);
        email = normalizeEmail(email);
        password = safeTrim(password);
        phone = safeTrim(phone);

        if (isBlank(name) || isBlank(email) || isBlank(password) || isBlank(phone)) {
            return false;
        }

        if (getUserByEmail(email) != null) {
            return false;
        }

        String id = generateUserId("USR");

        String sql = "INSERT INTO users (user_id, name, email, password, phone, role) " +
                "VALUES (?, ?, ?, ?, ?, 'CUSTOMER')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setString(5, phone);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("registerCustomer error: " + e.getMessage());
            return false;
        }
    }

    public boolean registerAdmin(String name, String email, String password,
                                 String phone, String adminPermission) {
        name = safeTrim(name);
        email = normalizeEmail(email);
        password = safeTrim(password);
        phone = safeTrim(phone);
        adminPermission = normalizeAdminPermission(adminPermission);

        if (isBlank(name) || isBlank(email) || isBlank(password) || isBlank(phone)) {
            return false;
        }

        if (getUserByEmail(email) != null) {
            return false;
        }

        String id = generateUserId("ADM");

        String sql = "INSERT INTO users (user_id, name, email, password, phone, role, admin_permission) " +
                "VALUES (?, ?, ?, ?, ?, 'ADMIN', ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setString(5, phone);
            ps.setString(6, adminPermission);

            return ps.executeUpdate() > 0;

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
                                      String phone,
                                      String adminPermission) {

        requesterAdminId = safeTrim(requesterAdminId);
        name = safeTrim(name);
        email = normalizeEmail(email);
        password = safeTrim(password);
        phone = safeTrim(phone);
        adminPermission = normalizeAdminPermission(adminPermission);

        if (isBlank(requesterAdminId) || isBlank(name) || isBlank(email)
                || isBlank(password) || isBlank(phone)) {
            return false;
        }

        if (getUserByEmail(email) != null) {
            return false;
        }

        String pendingCheckSql =
                "SELECT request_id FROM admin_requests WHERE requested_email = ? AND status = 'PENDING'";

        String insertSql =
                "INSERT INTO admin_requests " +
                        "(request_id, requester_admin_id, requested_name, requested_email, requested_password, requested_phone, requested_permission, status) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(pendingCheckSql);
             PreparedStatement insertPs = conn.prepareStatement(insertSql)) {

            checkPs.setString(1, email);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    return false;
                }
            }

            String requestId = generateAdminRequestId();

            insertPs.setString(1, requestId);
            insertPs.setString(2, requesterAdminId);
            insertPs.setString(3, name);
            insertPs.setString(4, email);
            insertPs.setString(5, password);
            insertPs.setString(6, phone);
            insertPs.setString(7, adminPermission);

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

                String requestedPermission;
                try {
                    requestedPermission = rs.getString("requested_permission");
                } catch (SQLException e) {
                    requestedPermission = Admin.FULL_ACCESS;
                }
                row.put("requestedPermission", normalizeAdminPermission(requestedPermission));

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
        String selectSql =
                "SELECT * FROM admin_requests WHERE request_id = ? AND status = 'PENDING'";

        String insertAdminSql =
                "INSERT INTO users (user_id, name, email, password, phone, role, admin_permission) " +
                        "VALUES (?, ?, ?, ?, ?, 'ADMIN', ?)";

        String updateRequestSql =
                "UPDATE admin_requests " +
                        "SET status = 'APPROVED', reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP " +
                        "WHERE request_id = ?";

        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement selectPs = conn.prepareStatement(selectSql)) {
                selectPs.setString(1, requestId);

                try (ResultSet rs = selectPs.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }

                    String requesterAdminId = rs.getString("requester_admin_id");
                    String name = rs.getString("requested_name");
                    String email = normalizeEmail(rs.getString("requested_email"));
                    String password = rs.getString("requested_password");
                    String phone = rs.getString("requested_phone");

                    String permission;
                    try {
                        permission = rs.getString("requested_permission");
                    } catch (SQLException e) {
                        permission = Admin.FULL_ACCESS;
                    }
                    permission = normalizeAdminPermission(permission);

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
                        insertPs.setString(6, permission);
                        insertPs.executeUpdate();

                        updatePs.setString(1, approverAdminId);
                        updatePs.setString(2, requestId);
                        updatePs.executeUpdate();
                    }
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
        String selectSql =
                "SELECT requester_admin_id FROM admin_requests WHERE request_id = ? AND status = 'PENDING'";

        String updateSql =
                "UPDATE admin_requests " +
                        "SET status = 'REJECTED', reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP " +
                        "WHERE request_id = ? AND status = 'PENDING'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement selectPs = conn.prepareStatement(selectSql);
             PreparedStatement updatePs = conn.prepareStatement(updateSql)) {

            selectPs.setString(1, requestId);

            try (ResultSet rs = selectPs.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }

                String requesterAdminId = rs.getString("requester_admin_id");

                if (requesterAdminId != null && requesterAdminId.equals(approverAdminId)) {
                    return false;
                }
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
        String sql = "SELECT * FROM users ORDER BY role DESC, name ASC";

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
        String sql = "SELECT * FROM users WHERE role = 'CUSTOMER' ORDER BY name ASC";

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

            ps.setString(1, safeTrim(userId));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs, conn);
                }
            }

        } catch (SQLException e) {
            System.err.println("getUserById error: " + e.getMessage());
        }

        return null;
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, normalizeEmail(email));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs, conn);
                }
            }

        } catch (SQLException e) {
            System.err.println("getUserByEmail error: " + e.getMessage());
        }

        return null;
    }

    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(?) AND password = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, normalizeEmail(email));
            ps.setString(2, safeTrim(password));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs, conn);
                }
            }

        } catch (SQLException e) {
            System.err.println("login error: " + e.getMessage());
        }

        return null;
    }

    public String getAdminPermission(String userId) {
        String sql = "SELECT admin_permission FROM users WHERE user_id = ? AND role = 'ADMIN'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, safeTrim(userId));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return normalizeAdminPermission(rs.getString("admin_permission"));
                }
            }

        } catch (SQLException e) {
            System.err.println("getAdminPermission error: " + e.getMessage());
        }

        return Admin.FULL_ACCESS;
    }

    // ======================== UPDATE ========================

    public boolean updateUser(String userId, String newName, String newPhone, String newPassword) {
        userId = safeTrim(userId);
        newName = safeTrim(newName);
        newPhone = safeTrim(newPhone);
        newPassword = safeTrim(newPassword);

        if (isBlank(userId) || isBlank(newName) || isBlank(newPhone)) {
            return false;
        }

        boolean updatePassword = !isBlank(newPassword);
        String sql = updatePassword
                ? "UPDATE users SET name = ?, phone = ?, password = ? WHERE user_id = ?"
                : "UPDATE users SET name = ?, phone = ? WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newName);
            ps.setString(2, newPhone);

            if (updatePassword) {
                ps.setString(3, newPassword);
                ps.setString(4, userId);
            } else {
                ps.setString(3, userId);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("updateUser error: " + e.getMessage());
            return false;
        }
    }

    public boolean updateUserByAdmin(String targetUserId,
                                     String name,
                                     String email,
                                     String phone,
                                     String password,
                                     String role,
                                     String currentAdminId,
                                     String adminPermission) {

        targetUserId = safeTrim(targetUserId);
        name = safeTrim(name);
        email = normalizeEmail(email);
        phone = safeTrim(phone);
        password = safeTrim(password);
        role = safeTrim(role);
        currentAdminId = safeTrim(currentAdminId);
        adminPermission = normalizeAdminPermission(adminPermission);

        if (isBlank(targetUserId) || isBlank(name) || isBlank(email)
                || isBlank(phone) || isBlank(role)) {
            return false;
        }

        if (!"ADMIN".equalsIgnoreCase(role) && !"CUSTOMER".equalsIgnoreCase(role)) {
            return false;
        }

        User existing = getUserById(targetUserId);
        if (existing == null) {
            return false;
        }

        User userWithSameEmail = getUserByEmail(email);
        if (userWithSameEmail != null && !targetUserId.equals(userWithSameEmail.getUserId())) {
            return false;
        }

        if (targetUserId.equals(currentAdminId) && !"ADMIN".equalsIgnoreCase(role)) {
            return false;
        }

        boolean updatePassword = !isBlank(password);
        boolean targetIsAdmin = "ADMIN".equalsIgnoreCase(role);

        String sql;
        if (targetIsAdmin) {
            if (updatePassword) {
                sql = "UPDATE users SET name = ?, email = ?, phone = ?, password = ?, role = ?, admin_permission = ? WHERE user_id = ?";
            } else {
                sql = "UPDATE users SET name = ?, email = ?, phone = ?, role = ?, admin_permission = ? WHERE user_id = ?";
            }
        } else {
            if (updatePassword) {
                sql = "UPDATE users SET name = ?, email = ?, phone = ?, password = ?, role = ?, admin_permission = NULL WHERE user_id = ?";
            } else {
                sql = "UPDATE users SET name = ?, email = ?, phone = ?, role = ?, admin_permission = NULL WHERE user_id = ?";
            }
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);

            if (targetIsAdmin) {
                if (updatePassword) {
                    ps.setString(4, password);
                    ps.setString(5, role.toUpperCase());
                    ps.setString(6, adminPermission);
                    ps.setString(7, targetUserId);
                } else {
                    ps.setString(4, role.toUpperCase());
                    ps.setString(5, adminPermission);
                    ps.setString(6, targetUserId);
                }
            } else {
                if (updatePassword) {
                    ps.setString(4, password);
                    ps.setString(5, role.toUpperCase());
                    ps.setString(6, targetUserId);
                } else {
                    ps.setString(4, role.toUpperCase());
                    ps.setString(5, targetUserId);
                }
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("updateUserByAdmin error: " + e.getMessage());
            return false;
        }
    }

    // ======================== DELETE ========================

    public boolean deleteUser(String userId) {
        return deleteUser(userId, null);
    }

    public boolean deleteUser(String userId, String currentAdminId) {
        userId = safeTrim(userId);
        currentAdminId = safeTrim(currentAdminId);

        if (isBlank(userId)) {
            return false;
        }

        if (userId.equals(currentAdminId)) {
            return false;
        }

        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement bookingPs =
                         conn.prepareStatement("DELETE FROM bookings WHERE customer_id = ?")) {
                bookingPs.setString(1, userId);
                bookingPs.executeUpdate();
            } catch (SQLException ignored) {
            }

            try (PreparedStatement requestByApproverPs =
                         conn.prepareStatement("DELETE FROM admin_requests WHERE reviewed_by = ?")) {
                requestByApproverPs.setString(1, userId);
                requestByApproverPs.executeUpdate();
            } catch (SQLException ignored) {
            }

            try (PreparedStatement deletePs =
                         conn.prepareStatement("DELETE FROM users WHERE user_id = ?")) {
                deletePs.setString(1, userId);

                boolean success = deletePs.executeUpdate() > 0;
                if (!success) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("deleteUser error: " + e.getMessage());

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

    public boolean deleteUserByEmail(String email) {
        String sql = "DELETE FROM users WHERE LOWER(email) = LOWER(?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, normalizeEmail(email));
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

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
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

        if ("ADMIN".equalsIgnoreCase(role)) {
            String permission;
            try {
                permission = rs.getString("admin_permission");
            } catch (SQLException e) {
                permission = Admin.FULL_ACCESS;
            }

            return new Admin(id, name, email, pass, phone, normalizeAdminPermission(permission));
        }

        int bookingCount = getBookingCount(id, conn);
        return new Customer(id, name, email, pass, phone, bookingCount);
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
        String sql =
                "SELECT MAX(CAST(SUBSTRING(user_id, 4) AS UNSIGNED)) " +
                        "FROM users WHERE user_id LIKE ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");

            try (ResultSet rs = ps.executeQuery()) {
                int next = 1;
                if (rs.next()) {
                    next = rs.getInt(1) + 1;
                }
                return String.format("%s%03d", prefix, next);
            }

        } catch (SQLException e) {
            System.err.println("generateUserId(conn) error: " + e.getMessage());
            return prefix + System.currentTimeMillis();
        }
    }

    private String generateAdminRequestId() {
        String sql =
                "SELECT MAX(CAST(SUBSTRING(request_id, 4) AS UNSIGNED)) " +
                        "FROM admin_requests WHERE request_id LIKE 'ARQ%'";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            int next = 1;
            if (rs.next()) {
                next = rs.getInt(1) + 1;
            }
            return String.format("ARQ%03d", next);

        } catch (SQLException e) {
            System.err.println("generateAdminRequestId error: " + e.getMessage());
            return "ARQ" + System.currentTimeMillis();
        }
    }

    public static boolean hasEventAccess(String permission) {
        String p = permission == null ? Admin.FULL_ACCESS : permission.trim().toUpperCase();
        return Admin.FULL_ACCESS.equals(p)
                || Admin.EVENTS_ONLY.equals(p)
                || Admin.EVENTS_BOOKINGS.equals(p);
    }

    public static boolean hasBookingAccess(String permission) {
        String p = permission == null ? Admin.FULL_ACCESS : permission.trim().toUpperCase();
        return Admin.FULL_ACCESS.equals(p)
                || Admin.BOOKINGS_ONLY.equals(p)
                || Admin.EVENTS_BOOKINGS.equals(p);
    }

    public static String permissionLabel(String permission) {
        String p = permission == null ? Admin.FULL_ACCESS : permission.trim().toUpperCase();
        switch (p) {
            case Admin.EVENTS_ONLY:
                return "Events only";
            case Admin.BOOKINGS_ONLY:
                return "Bookings only";
            case Admin.EVENTS_BOOKINGS:
                return "Events + Bookings";
            default:
                return "Full Access";
        }
    }

    private String normalizeAdminPermission(String permission) {
        if (permission == null || permission.trim().isEmpty()) {
            return Admin.FULL_ACCESS;
        }

        String p = permission.trim().toUpperCase();

        switch (p) {
            case "EVENTS":
            case "EVENTS_ONLY":
                return Admin.EVENTS_ONLY;
            case "BOOKINGS":
            case "BOOKINGS_ONLY":
                return Admin.BOOKINGS_ONLY;
            case "EVENTS_BOOKINGS":
            case "EVENTS+BOOKINGS":
            case "EVENTS_AND_BOOKINGS":
                return Admin.EVENTS_BOOKINGS;
            case "FULL":
            case "FULL_ACCESS":
                return Admin.FULL_ACCESS;
            default:
                return Admin.FULL_ACCESS;
        }
    }

    private String safeTrim(String value) {
        return value == null ? null : value.trim();
    }

    private String normalizeEmail(String email) {
        return email == null ? null : email.trim().toLowerCase();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}