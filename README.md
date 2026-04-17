# EventHorizon

<p align="center">
  <img src="https://img.shields.io/badge/Java-Full%20Stack%20Web%20Application-6C63FF?style=for-the-badge" alt="Java Full Stack Web Application" />
  <img src="https://img.shields.io/badge/JSP%20%7C%20Servlets%20%7C%20JDBC-0E1530?style=for-the-badge" alt="JSP Servlets JDBC" />
  <img src="https://img.shields.io/badge/MySQL-Database-1D3557?style=for-the-badge" alt="MySQL Database" />
  <img src="https://img.shields.io/badge/Railway-Cloud%20Deployment-6C63FF?style=for-the-badge" alt="Railway Cloud Deployment" />
</p>

<p align="center">
  <strong>Full-Stack Event Booking and Administration Platform</strong><br>
  A professionally structured Java web application for event discovery, booking management, payment verification, digital ticketing, and permission-based administration.
</p>

<p align="center">
  <a href="https://glistening-light-production-f277.up.railway.app/">
    <img src="https://img.shields.io/badge/Live%20Demo-Open%20on%20Railway-6C63FF?style=for-the-badge" alt="Live Demo"/>
  </a>
</p>

---

## Overview

**EventHorizon** is a full-stack event booking platform built with **Java, JSP, Servlets, JDBC, and MySQL**. It simulates a realistic event management ecosystem by combining a customer-facing booking experience with a structured administrative workflow in one cohesive system.

The project goes beyond a basic CRUD application by implementing:

- session-based authentication
- role-based and permission-based access control
- event lifecycle management
- ticket booking and cancellation workflows
- payment submission and approval flow
- digital ticket generation
- QR-based verification
- production-style deployment on Railway

The system was designed as a practical full-stack learning project with strong focus on clean structure, realistic business logic, and scalable workflow design.

---

## Live Deployment

| Environment | URL | Status |
|---|---|---|
| Production | `https://glistening-light-production-f277.up.railway.app/` | Active |

---

## Technology Stack

### Backend
- Java
- Java Servlets
- JDBC

### Frontend
- JSP
- HTML
- CSS
- JavaScript

### Database
- MySQL

### Build & Runtime
- Maven
- Apache Tomcat

### Development Tools
- IntelliJ IDEA
- Git
- GitHub
- XAMPP

### Deployment
- Railway
- ngrok

---

## Core Features

## Customer Features
- Secure user registration and login
- Session-based account authentication
- Browse active events
- Search events by title and venue
- Filter events by category
- View full event details
- Select ticket quantities and ticket types
- Submit booking payment reference
- View personal booking history
- Cancel bookings when allowed
- Access approved digital tickets
- Use QR-based ticket validation links
- Manage profile information

## Admin Features
- Dedicated admin workspace
- Permission-aware dashboard modules
- Create new events
- Edit event details
- Cancel or delete events
- Manage uploaded event images
- View all customer bookings
- Approve or reject payment submissions
- Manage users
- Handle admin access requests
- Scan and verify QR tickets
- Work under categorized permission levels

---

## Multi-Ticket-Type Support

EventHorizon supports **multiple ticket categories per event**, enabling a more realistic event booking workflow.

### Supported Capabilities
- One event can contain multiple ticket types
- Examples: **VIP**, **Standard**, **Early Bird**
- Each ticket type has its own:
  - price
  - total seats
  - available seats
- Bookings are linked to the selected ticket type
- Ticket type information is stored in:
  - bookings
  - tickets
  - ticket generation flow
- Admins can configure ticket types while creating events

This enhancement makes the system closer to real commercial ticketing platforms.

---

## Digital Ticketing and QR Verification

A key highlight of **EventHorizon** is its secure ticket validation workflow.

### Ticket Flow
- Tickets are generated only after booking approval
- Each ticket receives a unique secure token
- Approved tickets are stored in the database
- Customers can view tickets through the ticket interface

### QR Verification Flow
- Each ticket includes a QR code linked to a verification endpoint
- Scanning a valid system-generated QR checks the database
- Approved tickets return a valid verification result
- Invalid or unknown QR codes return **Not Approved**
- Ticket verification is based on stored backend data, not static image trust

This creates a more secure and realistic event-entry process.

---

## System Architecture

The application follows a layered architecture to separate presentation, control, business logic, and persistence.

| Layer | Responsibility |
|---|---|
| Model Layer | Core entities such as `User`, `Admin`, `Customer`, `Event`, `Booking`, `Ticket`, and `EventTicketType` |
| View Layer | JSP pages for customer and admin interfaces |
| Controller Layer | Servlets for routing, request handling, validation, and workflow control |
| Service Layer | Business logic for users, events, bookings, ticket types, tickets, and admin processes |
| Database Layer | MySQL persistence through JDBC |

### Architecture Benefits
- better maintainability
- better readability
- clear separation of concerns
- easier debugging
- easier feature expansion

---

## Functional Modules

| Module | Responsibility | Access |
|---|---|---|
| Authentication Module | Registration, login, logout, session validation, role checks | All Users |
| Event Browsing Module | Browse, search, filter, and view active events | Customers |
| Booking Module | Create bookings, submit payments, cancel bookings, track booking history | Customers |
| Ticket Module | Generate tickets, display QR tickets, verify ticket validity | Customers / Admin |
| Ticket Type Module | Define multiple ticket categories for each event | Admin |
| Event Management Module | Create, update, cancel, and delete events | Admin |
| Booking Management Module | Review bookings, approve payments, reject requests, delete old records | Admin |
| User Management Module | Manage user accounts and access levels | Full Access Admin |
| Admin Request Module | Submit, review, approve, and reject admin access requests | Full Access Admin |

---

## Permission-Based Admin Access Control

EventHorizon includes categorized admin permissions that dynamically control visible dashboard modules and operational scope.

| Permission Type | Access Scope |
|---|---|
| Events Only | Event management only |
| Bookings Only | Booking and payment management only |
| Events + Bookings | Combined event and booking access |
| Full Access | Full administrative control including users and admin requests |

### Why This Matters
- improves administrative security
- supports role separation
- reflects real organizational workflow
- makes dashboard behavior more flexible

---

## Business Logic Highlights

### Event Logic
- Events maintain total seats and available seats
- Only active events are shown to customers
- Events include category, venue, date, time, description, and images
- Events can include multiple ticket types with separate seat pools

### Booking Logic
- Bookings are linked to customers and events
- Bookings store selected ticket type
- Total amount is calculated from selected ticket type price
- Seat availability is reduced at booking time
- Seats are restored when bookings are rejected or cancelled
- Payment status is tracked independently from booking status

### Ticket Logic
- Tickets are created only after admin payment approval
- Tickets store ticket type details
- Tickets include QR-based verification support
- Used and unused ticket states are tracked

### Admin Workflow
- Admin creation can be request-based
- Requests stay pending until reviewed
- Approval grants permission-specific dashboard access
- Full-access admins can manage broader system operations

---

## Project Highlights

- Full-stack Java web application with realistic workflows
- Clean layered architecture
- Role-based and permission-based access control
- Multi-ticket-type event support
- Secure booking and payment approval flow
- Digital ticket generation with QR verification
- Database-backed validation logic
- Admin dashboard adaptation based on permission type
- Professional dark-themed UI
- Railway cloud deployment with MySQL integration

---

## Deployment Details

| Component | Description |
|---|---|
| Hosting Platform | Railway |
| Database | Railway MySQL |
| Web Server | Apache Tomcat |
| Runtime | Java Servlets + JSP |
| Configuration | Environment variables |
| Image Storage | Managed through application and database fields |
| Ticket Storage | MySQL-backed records |
| Email Support | Limited / currently restricted by SMTP environment |

---

## Project Structure

```text
src/
 ├── main/
 │   ├── java/
 │   │   └── com.eventhorizon/
 │   │       ├── model/
 │   │       ├── service/
 │   │       ├── servlet/
 │   │       └── util/
 │   ├── resources/
 │   └── webapp/
 │       ├── admin/
 │       ├── css/
 │       ├── js/
 │       ├── WEB-INF/
 │       └── *.jsp
 ├── pom.xml
 └── README.md
