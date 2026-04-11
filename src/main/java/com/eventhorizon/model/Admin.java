package com.eventhorizon.model;

/**
 * Admin class - INHERITS from User.
 * Admins can create/update/delete events and manage bookings.
 */
public class Admin extends User {

    private String adminLevel;   // e.g., "SUPER" or "STANDARD"

    public Admin(String userId, String name, String email,
                 String password, String phone, String adminLevel) {
        super(userId, name, email, password, phone);
        this.adminLevel = adminLevel;
    }

    public Admin() { super(); }

    // POLYMORPHISM - overrides abstract method from User
    @Override
    public String getRole() {
        return "ADMIN";
    }

    @Override
    public String toFileString() {
        return super.toFileString() + "," + adminLevel;
    }

    // Build Admin from a CSV line in users.txt
    public static Admin fromFileString(String line) {
        String[] parts = line.split(",");
        String level = parts.length > 6 ? parts[6] : "STANDARD";
        return new Admin(parts[0], parts[1], parts[2], parts[3], parts[4], level);
    }

    public String getAdminLevel()              { return adminLevel; }
    public void   setAdminLevel(String level)  { this.adminLevel = level; }
}
