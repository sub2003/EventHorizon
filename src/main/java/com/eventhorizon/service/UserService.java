package com.eventhorizon.service;

import com.eventhorizon.model.Admin;
import com.eventhorizon.model.Customer;
import com.eventhorizon.model.User;
import com.eventhorizon.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserService {

    // ======================== CREATE ========================

    public boolean registerCustomer(String name, String email,
                                    String password, String phone) {
        if (getUserByEmail(email) != null) return false;

        String id = generateId("USR");

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

        String id = generateId("ADM");

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

    private String generateId(String prefix) {
        String sql = "SELECT COUNT(*) FROM users";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            if (rs.next()) {
                return String.format("%s%03d", prefix, rs.getInt(1) + 1);
            }

        } catch (SQLException e) {
            System.err.println("generateId error: " + e.getMessage());
        }

        return prefix + System.currentTimeMillis();
    }
}