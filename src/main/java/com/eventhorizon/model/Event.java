package com.eventhorizon.model;

/**
 * Event model - encapsulates all event data.
 * Supports file serialization/deserialization.
 */
public class Event {

    private String eventId;
    private String title;
    private String category;     // e.g., Concert, Sports, Theater
    private String date;         // Format: YYYY-MM-DD
    private String time;         // Format: HH:MM
    private String venue;
    private double ticketPrice;
    private int    totalSeats;
    private int    availableSeats;
    private String description;
    private String status;       // "ACTIVE" or "CANCELLED"

    public Event(String eventId, String title, String category, String date,
                 String time, String venue, double ticketPrice,
                 int totalSeats, int availableSeats, String description, String status) {
        this.eventId        = eventId;
        this.title          = title;
        this.category       = category;
        this.date           = date;
        this.time           = time;
        this.venue          = venue;
        this.ticketPrice    = ticketPrice;
        this.totalSeats     = totalSeats;
        this.availableSeats = availableSeats;
        this.description    = description;
        this.status         = status;
    }

    public Event() {}

    // Serialize to CSV line → save to events.txt
    public String toFileString() {
        return eventId + "|" + title + "|" + category + "|" + date + "|" + time + "|" +
               venue + "|" + ticketPrice + "|" + totalSeats + "|" + availableSeats + "|" +
               description + "|" + status;
    }

    // Deserialize from CSV line ← read from events.txt
    public static Event fromFileString(String line) {
        String[] p = line.split("\\|");
        return new Event(p[0], p[1], p[2], p[3], p[4], p[5],
                         Double.parseDouble(p[6]),
                         Integer.parseInt(p[7]),
                         Integer.parseInt(p[8]),
                         p[9], p[10]);
    }

    // Check if tickets are available
    public boolean hasAvailableSeats() {
        return availableSeats > 0;
    }

    // Book N seats (reduce availableSeats)
    public boolean bookSeats(int count) {
        if (availableSeats >= count) {
            availableSeats -= count;
            return true;
        }
        return false;
    }

    // Cancel N seats (restore availableSeats)
    public void cancelSeats(int count) {
        availableSeats = Math.min(availableSeats + count, totalSeats);
    }

    // -------------------- Getters & Setters --------------------
    public String getEventId()                      { return eventId; }
    public void   setEventId(String eventId)        { this.eventId = eventId; }

    public String getTitle()                        { return title; }
    public void   setTitle(String title)            { this.title = title; }

    public String getCategory()                     { return category; }
    public void   setCategory(String category)      { this.category = category; }

    public String getDate()                         { return date; }
    public void   setDate(String date)              { this.date = date; }

    public String getTime()                         { return time; }
    public void   setTime(String time)              { this.time = time; }

    public String getVenue()                        { return venue; }
    public void   setVenue(String venue)            { this.venue = venue; }

    public double getTicketPrice()                  { return ticketPrice; }
    public void   setTicketPrice(double price)      { this.ticketPrice = price; }

    public int  getTotalSeats()                     { return totalSeats; }
    public void setTotalSeats(int seats)            { this.totalSeats = seats; }

    public int  getAvailableSeats()                 { return availableSeats; }
    public void setAvailableSeats(int seats)        { this.availableSeats = seats; }

    public String getDescription()                  { return description; }
    public void   setDescription(String desc)       { this.description = desc; }

    public String getStatus()                       { return status; }
    public void   setStatus(String status)          { this.status = status; }
}
