# EventHorizon

<p align="center">
  <img src="https://img.shields.io/badge/Java-Full%20Stack%20Web%20Application-6C63FF?style=for-the-badge" alt="Java Full Stack Web Application" />
  <img src="https://img.shields.io/badge/JSP%20%7C%20Servlets%20%7C%20JDBC-0E1530?style=for-the-badge" alt="JSP Servlets JDBC" />
  <img src="https://img.shields.io/badge/MySQL-Database-1D3557?style=for-the-badge" alt="MySQL Database" />
  <img src="https://img.shields.io/badge/Railway-Cloud%20Deployment-6C63FF?style=for-the-badge" alt="Railway Cloud Deployment" />
</p>

<p align="center">
  <strong>Professional Event Booking, Ticketing, and Administration Platform</strong><br />
  A full-stack Java web application designed for event discovery, booking management, manual payment verification, digital ticket generation, QR-based validation, and permission-based administration.
</p>

<p align="center">
  <a href="https://www.eventhorizonapp.online/">
    <img src="https://img.shields.io/badge/Live%20Demo-eventhorizonapp.online-6C63FF?style=for-the-badge" alt="Live Demo" />
  </a>
</p>

---

## Table of Contents

- [Overview](#overview)
- [Live Deployment](#live-deployment)
- [Technology Stack](#technology-stack)
- [Core Capabilities](#core-capabilities)
- [System Architecture](#system-architecture)
- [Functional Modules](#functional-modules)
- [Admin Permission Model](#admin-permission-model)
- [Digital Ticketing and QR Verification](#digital-ticketing-and-qr-verification)
- [Business Logic](#business-logic)
- [Project Structure](#project-structure)
- [Deployment Summary](#deployment-summary)
- [Local Development Setup](#local-development-setup)
- [Project Highlights](#project-highlights)

---

## Overview

**EventHorizon** is a full-stack event booking platform built with **Java, JSP, Servlets, JDBC, and MySQL**. The system provides a complete customer-facing booking experience and a structured administration workflow for managing events, bookings, users, payments, tickets, and admin access levels.

The application is designed as a realistic academic full-stack project with a strong focus on:

- clean layered architecture
- role-based and permission-based access control
- database-backed workflows
- production-style deployment
- professional user interface design
- realistic event booking and ticket validation logic

Unlike a simple CRUD system, EventHorizon connects multiple workflows together: customers browse and book events, submit payment references, admins verify payments, tickets are generated after approval, and QR codes are validated through backend token verification.

---

## Live Deployment

| Environment | URL | Status |
|---|---|---|
| Production | `https://www.eventhorizonapp.online/` | Active |
| Railway Default | `https://glistening-light-production-f277.up.railway.app/` | Active |

---

## Technology Stack

| Category | Technologies |
|---|---|
| Backend | Java, Java Servlets, JDBC |
| Frontend | JSP, HTML, CSS, JavaScript |
| Database | MySQL |
| Build Tool | Maven |
| Runtime Server | Apache Tomcat |
| Development Tools | IntelliJ IDEA, Git, GitHub, XAMPP, MySQL Workbench |
| Deployment | Railway, Railway MySQL |
| Temporary Public Testing | ngrok |

---

## Core Capabilities

### Customer Features

- User registration and login
- Session-based authentication
- Browse active events
- Search events by title, venue, or category
- View detailed event information
- Select ticket types and quantities
- Submit booking requests
- Enter manual payment reference details
- View personal booking history
- Track booking and payment status
- Access approved digital tickets
- Use QR-based ticket verification links
- Update customer profile details
- Cancel bookings when allowed

### Admin Features

- Dedicated admin dashboard
- Permission-aware navigation and dashboard modules
- Add, update, cancel, and delete events
- Configure multiple ticket types per event
- Manage event images and event details
- View and manage customer bookings
- Approve or reject payment submissions
- Generate tickets after approved payments
- Verify QR-based ticket tokens
- Manage users based on permission level
- Handle admin access requests
- Work under categorized admin roles

---

## System Architecture

EventHorizon follows a layered architecture that separates presentation, request handling, business logic, and database access.

| Layer | Responsibility |
|---|---|
| Model Layer | Represents domain entities such as `User`, `Admin`, `Customer`, `Event`, `Booking`, `Ticket`, and `EventTicketType` |
| View Layer | JSP pages for customer interfaces, admin dashboards, forms, lists, and status pages |
| Controller Layer | Servlets that handle routing, validation, request processing, and response forwarding |
| Service Layer | Business logic for authentication, events, bookings, tickets, payments, users, and admin workflows |
| Data Access Layer | JDBC-based database operations using MySQL |
| Deployment Layer | Railway-hosted application and MySQL database environment |

### Architecture Benefits

- Clear separation of concerns
- Easier debugging and maintenance
- More readable code organization
- Reusable service-level logic
- Scalable structure for future features
- Better alignment with real-world Java web development practices

---

## Functional Modules

| Module | Responsibility | Primary Access |
|---|---|---|
| Authentication Module | Registration, login, logout, session handling, and role validation | Customers / Admins |
| Event Browsing Module | Display active events, event details, search, and filtering | Customers |
| Booking Module | Create bookings, submit payment references, cancel bookings, and track history | Customers |
| Payment Review Module | Review submitted payment references and approve or reject bookings | Admins |
| Ticket Module | Generate tickets, display ticket details, and validate QR tokens | Customers / Admins |
| Ticket Type Module | Manage VIP, Standard, Early Bird, and other ticket categories | Admins |
| Event Management Module | Create, edit, cancel, delete, and manage event data | Event Admins |
| User Management Module | View and manage customer and admin accounts | Full Access Admins |
| Admin Request Module | Submit, review, approve, or reject new admin access requests | Full Access Admins |
| Issue / Support Module | Allow users to report issues and receive admin responses | Customers / Admins |

---

## Admin Permission Model

EventHorizon includes a permission-based admin system that controls which dashboard modules and actions each admin can access.

| Permission Type | Access Scope |
|---|---|
| Events Only | Create, update, cancel, and manage events |
| Bookings Only | View bookings, approve payments, reject payments, and manage booking records |
| Events + Bookings | Combined access to event and booking workflows |
| Full Access | Complete administrative control, including users and admin requests |
| Core Admin | Highest-level control over the system and admin management workflows |

### Purpose of Permission Control

- Prevents unnecessary access to sensitive modules
- Supports clear separation of responsibilities
- Makes the admin dashboard more secure and organized
- Reflects realistic organizational access control
- Reduces accidental changes by limited-access admins

---

## Multi-Ticket-Type Support

EventHorizon supports multiple ticket categories for a single event. This makes the booking flow closer to real event ticketing platforms.

### Supported Ticket Type Details

Each event can include ticket types such as:

- VIP
- Standard
- Early Bird
- General Admission

Each ticket type can maintain its own:

- price
- total seat count
- available seat count
- booking relationship
- ticket generation data

### Ticket Type Workflow

1. Admin creates an event.
2. Admin defines one or more ticket types.
3. Customer selects a ticket type during booking.
4. The system calculates the total amount based on selected ticket type and quantity.
5. Available seats are updated according to the selected ticket category.
6. Ticket details are preserved in booking and ticket records.

---

## Digital Ticketing and QR Verification

A major feature of EventHorizon is its database-backed digital ticketing and QR verification workflow.

### Ticket Generation Flow

1. Customer creates a booking.
2. Customer submits a payment reference.
3. Admin reviews the payment reference.
4. Admin approves the booking if the payment is valid.
5. The system generates an approved ticket.
6. The ticket receives a unique verification token.
7. A QR code is generated using the verification link.

### QR Verification Flow

1. The QR code is scanned.
2. The verification endpoint receives the ticket token.
3. The backend checks the token against the database.
4. If the ticket exists and is approved, the system displays a valid result.
5. If the token is unknown, forged, expired, rejected, or not approved, the system displays a not-approved result.

### Security Advantage

QR validation is based on backend database verification, not just the QR image itself. This prevents external or fake QR codes from being accepted as valid system tickets.

---

## Business Logic

### Event Logic

- Events include title, category, date, time, venue, description, image, and status.
- Only active events are shown to customers.
- Admins can create, update, cancel, or delete events depending on permission.
- Event availability is connected to ticket type seat availability.

### Booking Logic

- Each booking belongs to a customer.
- Each booking is linked to an event and selected ticket type.
- Booking total is calculated based on ticket type price and quantity.
- Seat availability is reduced when a booking is created.
- Seats can be restored when bookings are cancelled or rejected.
- Booking status and payment status are tracked separately for clearer workflow control.

### Payment Logic

- Customers submit manual payment references.
- Admins review payment references from the dashboard.
- Valid payments can be approved.
- Invalid payments can be rejected.
- Ticket generation depends on payment approval.

### Ticket Logic

- Tickets are created only after admin approval.
- Each ticket receives a secure token.
- Tickets can be verified through QR code scanning.
- Ticket validity is checked using database records.
- Ticket status supports approved and not-approved verification outcomes.

### Admin Workflow Logic

- Admin access can be request-based.
- Requests remain pending until reviewed.
- Approved requests grant permission-specific access.
- Admin dashboard modules are shown based on permission level.
- Full access and core admin roles provide broader management capabilities.

---

## Project Structure

```text
EventHorizon/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/eventhorizon/
│       │       ├── model/
│       │       │   ├── User.java
│       │       │   ├── Admin.java
│       │       │   ├── Customer.java
│       │       │   ├── Event.java
│       │       │   ├── Booking.java
│       │       │   ├── Ticket.java
│       │       │   └── EventTicketType.java
│       │       ├── service/
│       │       │   ├── UserService.java
│       │       │   ├── EventService.java
│       │       │   ├── BookingService.java
│       │       │   ├── TicketService.java
│       │       │   └── AdminService.java
│       │       ├── servlet/
│       │       │   ├── UserServlet.java
│       │       │   ├── EventServlet.java
│       │       │   ├── BookingServlet.java
│       │       │   └── TicketServlet.java
│       │       └── util/
│       │           └── DatabaseConnection.java
│       ├── resources/
│       └── webapp/
│           ├── admin/
│           │   ├── dashboard.jsp
│           │   ├── events.jsp
│           │   ├── bookings.jsp
│           │   ├── managePayments.jsp
│           │   ├── users.jsp
│           │   ├── addAdmin.jsp
│           │   └── adminRequests.jsp
│           ├── css/
│           ├── js/
│           ├── WEB-INF/
│           │   └── web.xml
│           ├── index.jsp
│           ├── events.jsp
│           ├── eventDetails.jsp
│           ├── checkout.jsp
│           ├── myBookings.jsp
│           ├── profile.jsp
│           └── login.jsp
├── pom.xml
└── README.md
```

---

## Deployment Summary

| Component | Description |
|---|---|
| Hosting Platform | Railway |
| Application Runtime | Apache Tomcat |
| Backend | Java Servlets and JSP |
| Database | Railway MySQL |
| Configuration | Environment variables |
| Public Domain | `https://www.eventhorizonapp.online/` |
| Default Railway URL | `https://glistening-light-production-f277.up.railway.app/` |
| Database Access | JDBC |
| Build Method | Maven WAR deployment |

### Environment Variables

The deployed application can be configured with database environment variables such as:

```text
MYSQLHOST=
MYSQLPORT=
MYSQLDATABASE=
MYSQLUSER=
MYSQLPASSWORD=
```

The application can use these variables to connect to the Railway MySQL database in production.

---

## Local Development Setup

### Prerequisites

- Java JDK
- Apache Maven
- Apache Tomcat
- MySQL Server or XAMPP
- IntelliJ IDEA
- Git

### Basic Setup Steps

1. Clone the repository.

```bash
git clone <repository-url>
```

2. Open the project in IntelliJ IDEA.

3. Configure the MySQL database.

4. Update database connection settings for the local environment.

5. Build the project using Maven.

```bash
mvn clean package
```

6. Deploy the generated WAR file to Apache Tomcat.

7. Open the application in the browser.

```text
http://localhost:8080/EventHorizon
```

---

## Project Highlights

- Full-stack Java web application
- Professional event booking workflow
- Clean JSP, Servlet, JDBC, and MySQL integration
- Customer and admin role separation
- Permission-based admin dashboard
- Multi-ticket-type support
- Manual payment approval workflow
- Digital ticket generation
- QR-based ticket verification
- Database-backed validation logic
- Railway cloud deployment
- Custom domain integration
- Structured and scalable project architecture

---

## Future Improvements

- Online payment gateway integration
- Email notification improvements
- Advanced analytics dashboard
- PDF ticket download support
- Better image storage strategy
- Audit logging for admin actions
- Automated booking expiry handling
- Enhanced customer notification system

---

## Status

The project is actively maintained as a full-stack academic web application and continues to evolve with improved UI, better workflow handling, stronger admin access control, and more production-style features.
