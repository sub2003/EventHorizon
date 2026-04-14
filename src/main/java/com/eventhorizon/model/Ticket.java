package com.eventhorizon.model;

/**
 * Ticket – one physical ticket per seat inside a booking.
 * The qrToken is an HMAC-SHA-256 signature that only the server can validate;
 * any externally crafted QR will fail verification.
 */
public class Ticket {

    private String  ticketId;    // UUID
    private String  bookingId;
    private String  eventId;
    private String  customerId;
    private String  qrToken;     // HMAC-SHA-256 hex string
    private boolean used;
    private String  createdAt;

    public Ticket() {}

    public Ticket(String ticketId, String bookingId, String eventId,
                  String customerId, String qrToken, boolean used, String createdAt) {
        this.ticketId   = ticketId;
        this.bookingId  = bookingId;
        this.eventId    = eventId;
        this.customerId = customerId;
        this.qrToken    = qrToken;
        this.used       = used;
        this.createdAt  = createdAt;
    }

    // -------------------- Getters & Setters --------------------
    public String  getTicketId()                    { return ticketId; }
    public void    setTicketId(String ticketId)     { this.ticketId = ticketId; }

    public String  getBookingId()                   { return bookingId; }
    public void    setBookingId(String bookingId)   { this.bookingId = bookingId; }

    public String  getEventId()                     { return eventId; }
    public void    setEventId(String eventId)       { this.eventId = eventId; }

    public String  getCustomerId()                  { return customerId; }
    public void    setCustomerId(String id)         { this.customerId = id; }

    public String  getQrToken()                     { return qrToken; }
    public void    setQrToken(String qrToken)       { this.qrToken = qrToken; }

    public boolean isUsed()                         { return used; }
    public void    setUsed(boolean used)            { this.used = used; }

    public String  getCreatedAt()                   { return createdAt; }
    public void    setCreatedAt(String createdAt)   { this.createdAt = createdAt; }
}
