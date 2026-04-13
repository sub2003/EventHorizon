package com.eventhorizon.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    private static final String URL      = "jdbc:mysql://localhost:3307/eventhorizon_db"
            + "?useSSL=false&allowPublicKeyRetrieval=true"
            + "&serverTimezone=Asia/Colombo";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found: " + e.getMessage());
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("DB connection failed: " + e.getMessage());
            return false;
        }
    }
}