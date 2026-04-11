package com.eventhorizon.service;

import com.eventhorizon.model.Admin;
import com.eventhorizon.model.Customer;
import com.eventhorizon.model.User;
import com.eventhorizon.util.FileHandler;

import java.util.ArrayList;
import java.util.List;

/**
 * UserService - Handles all CRUD operations for Users (Customers & Admins).
 * Data is stored in / read from users.txt
 *
 * CRUD:
 *  CREATE  → registerCustomer(), registerAdmin()
 *  READ    → getAllUsers(), getUserById(), getUserByEmail()
 *  UPDATE  → updateUser()
 *  DELETE  → deleteUser()
 */
public class UserService {

    // ======================== CREATE ========================

    /**
     * Register a new Customer. Returns false if email already exists.
     */
    public boolean registerCustomer(String name, String email,
                                    String password, String phone) {
        // Check for duplicate email
        if (getUserByEmail(email) != null) return false;

        String id = FileHandler.generateId(FileHandler.USERS_FILE, "USR");
        Customer customer = new Customer(id, name, email, password, phone, 0);
        FileHandler.appendLine(FileHandler.USERS_FILE, customer.toFileString());
        return true;
    }

    /**
     * Register a new Admin.
     */
    public boolean registerAdmin(String name, String email,
                                 String password, String phone) {
        if (getUserByEmail(email) != null) return false;

        String id = FileHandler.generateId(FileHandler.USERS_FILE, "ADM");
        Admin admin = new Admin(id, name, email, password, phone, "STANDARD");
        FileHandler.appendLine(FileHandler.USERS_FILE, admin.toFileString());
        return true;
    }

    // ======================== READ ========================

    /**
     * Returns all users (Customers + Admins) from users.txt
     */
    public List<User> getAllUsers() {
        List<String> lines = FileHandler.readAllLines(FileHandler.USERS_FILE);
        List<User> users = new ArrayList<>();

        for (String line : lines) {
            try {
                String[] parts = line.split(",");
                if (parts.length < 6) continue;
                String role = parts[5];

                if (role.equals("CUSTOMER")) {
                    users.add(Customer.fromFileString(line));
                } else if (role.equals("ADMIN")) {
                    users.add(Admin.fromFileString(line));
                }
            } catch (Exception e) {
                System.err.println("Skipping malformed user line: " + line);
            }
        }
        return users;
    }

    /**
     * Find a user by their ID.
     */
    public User getUserById(String userId) {
        for (User u : getAllUsers()) {
            if (u.getUserId().equals(userId)) return u;
        }
        return null;
    }

    /**
     * Find a user by email (used for login).
     */
    public User getUserByEmail(String email) {
        for (User u : getAllUsers()) {
            if (u.getEmail().equalsIgnoreCase(email)) return u;
        }
        return null;
    }

    /**
     * Login: validate email + password. Returns the User or null.
     */
    public User login(String email, String password) {
        User user = getUserByEmail(email);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    /**
     * Returns only Customer objects.
     */
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        for (User u : getAllUsers()) {
            if (u instanceof Customer) customers.add((Customer) u);
        }
        return customers;
    }

    // ======================== UPDATE ========================

    /**
     * Update a user's name, phone, and password by their ID.
     */
    public boolean updateUser(String userId, String newName,
                              String newPhone, String newPassword) {
        User user = getUserById(userId);
        if (user == null) return false;

        user.setName(newName);
        user.setPhone(newPhone);
        user.setPassword(newPassword);

        return FileHandler.updateLine(FileHandler.USERS_FILE,
                userId, user.toFileString(), ",");
    }

    // ======================== DELETE ========================

    /**
     * Delete a user by their ID.
     */
    public boolean deleteUser(String userId) {
        return FileHandler.deleteLine(FileHandler.USERS_FILE, userId, ",");
    }
}
