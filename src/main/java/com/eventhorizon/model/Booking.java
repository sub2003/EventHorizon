package com.eventhorizon.model;

/**
 * Booking model - links a Customer to an Event.
 */
public class Booking {

    private String bookingId;
    private String customerId;
    private String eventId;
    private String eventTitle;        // Stored for easy display
    private int    numberOfTickets;
    private double totalAmount;
    private String bookingDate;       // Format: YYYY-MM-DD
    private String status;            // "CONFIRMED" or "CANCELLED"
    private String paymentStatus;     // "PENDING", "APPROVED", "REJECTED"
    private String paymentReference;  // Customer's bank transaction reference

    public Booking(String bookingId, String customerId, String eventId,
                   String eventTitle, int numberOfTickets, double totalAmount,
                   String bookingDate, String status) {
        this(bookingId, customerId, eventId, eventTitle,
             numberOfTickets, totalAmount, bookingDate, status, "PENDING", null);
    }

    public Booking(String bookingId, String customerId, String eventId,
                   String eventTitle, int numberOfTickets, double totalAmount,
                   String bookingDate, String status,
                   String paymentStatus, String paymentReference) {
        this.bookingId        = bookingId;
        this.customerId       = customerId;
        this.eventId          = eventId;
        this.eventTitle       = eventTitle;
        this.numberOfTickets  = numberOfTickets;
        this.totalAmount      = totalAmount;
        this.bookingDate      = bookingDate;
        this.status           = status;
        this.paymentStatus    = paymentStatus;
        this.paymentReference = paymentReference;
    }

    public Booking() {}

    // Serialize → bookings.txt
    public String toFileString() {
        return bookingId + "|" + customerId + "|" + eventId + "|" + eventTitle + "|" +
               numberOfTickets + "|" + totalAmount + "|" + bookingDate + "|" + status;
    }

    // Deserialize ← bookings.txt
    public static Booking fromFileString(String line) {
        String[] p = line.split("\\|");
        return new Booking(p[0], p[1], p[2], p[3],
                           Integer.parseInt(p[4]),
                           Double.parseDouble(p[5]),
                           p[6], p[7]);
    }

    // -------------------- Getters & Setters --------------------
    public String getBookingId()                        { return bookingId; }
    public void   setBookingId(String bookingId)        { this.bookingId = bookingId; }

    public String getCustomerId()                       { return customerId; }
    public void   setCustomerId(String id)              { this.customerId = id; }

    public String getEventId()                          { return eventId; }
    public void   setEventId(String eventId)            { this.eventId = eventId; }

    public String getEventTitle()                       { return eventTitle; }
    public void   setEventTitle(String title)           { this.eventTitle = title; }

    public int  getNumberOfTickets()                    { return numberOfTickets; }
    public void setNumberOfTickets(int n)               { this.numberOfTickets = n; }

    public double getTotalAmount()                      { return totalAmount; }
    public void   setTotalAmount(double amount)         { this.totalAmount = amount; }

    public String getBookingDate()                      { return bookingDate; }
    public void   setBookingDate(String date)           { this.bookingDate = date; }

    public String getStatus()                                    { return status; }
    public void   setStatus(String status)                       { this.status = status; }

    public String getPaymentStatus()                             { return paymentStatus; }
    public void   setPaymentStatus(String paymentStatus)         { this.paymentStatus = paymentStatus; }

    public String getPaymentReference()                          { return paymentReference; }
    public void   setPaymentReference(String paymentReference)   { this.paymentReference = paymentReference; }
}
