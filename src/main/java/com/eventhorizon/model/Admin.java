package com.eventhorizon.model;

/**
 * Admin class - inherits from User.
 * Supports permission categories for admin access control.
 */
public class Admin extends User {

    public static final String EVENTS_ONLY = "EVENTS_ONLY";
    public static final String BOOKINGS_ONLY = "BOOKINGS_ONLY";
    public static final String EVENTS_BOOKINGS = "EVENTS_BOOKINGS";
    public static final String FULL_ACCESS = "FULL_ACCESS";

    private String adminPermission;

    public Admin(String userId, String name, String email,
                 String password, String phone, String adminPermission) {
        super(userId, name, email, password, phone);
        setAdminPermission(adminPermission);
    }

    public Admin() {
        super();
        this.adminPermission = FULL_ACCESS;
    }

    @Override
    public String getRole() {
        return "ADMIN";
    }

    public String getAdminPermission() {
        return adminPermission;
    }

    public void setAdminPermission(String adminPermission) {
        if (adminPermission == null || adminPermission.trim().isEmpty()) {
            this.adminPermission = FULL_ACCESS;
            return;
        }

        String normalized = adminPermission.trim().toUpperCase();
        switch (normalized) {
            case EVENTS_ONLY:
            case BOOKINGS_ONLY:
            case EVENTS_BOOKINGS:
            case FULL_ACCESS:
                this.adminPermission = normalized;
                break;
            default:
                this.adminPermission = FULL_ACCESS;
        }
    }

    public boolean canManageEvents() {
        return FULL_ACCESS.equals(adminPermission)
                || EVENTS_ONLY.equals(adminPermission)
                || EVENTS_BOOKINGS.equals(adminPermission);
    }

    public boolean canManageBookings() {
        return FULL_ACCESS.equals(adminPermission)
                || BOOKINGS_ONLY.equals(adminPermission)
                || EVENTS_BOOKINGS.equals(adminPermission);
    }

    public String getPermissionLabel() {
        switch (adminPermission) {
            case EVENTS_ONLY:
                return "Events only";
            case BOOKINGS_ONLY:
                return "Bookings only";
            case EVENTS_BOOKINGS:
                return "Events + Bookings";
            default:
                return "Full Access";
        }
    }
}