# EventHorizon

<p align="center">
  <strong>Full-Stack Event Booking and Administration Platform</strong><br>
  A Java web application for event discovery, ticket booking, user management, and permission-based administrative control.
</p>

<p align="center">
  <a href="https://glistening-light-production-f277.up.railway.app/">
    <img src="https://img.shields.io/badge/Live%20Application-Railway-6C63FF?style=for-the-badge" alt="Live Application"/>
  </a>
</p>

---

## Overview

**EventHorizon** is a full-stack web-based event booking system built using **Java, JSP, Servlets, JDBC, and MySQL**. It delivers a complete workflow for both customers and administrators within a single platform, combining event discovery, booking management, and secure administrative control.

The system was designed to simulate a real-world booking environment rather than a basic academic CRUD project. It includes session-based authentication, role-based permissions, event lifecycle management, booking and cancellation workflows, admin request approval, and a structured dashboard experience.

---

## Live Deployment

| Environment | URL | Status |
|---|---|---|
| **Production** | `https://glistening-light-production-f277.up.railway.app/` | Active |
| **Temporary Preview** | `https://phosphate-shrine-iguana.ngrok-free.dev/EventHorizon` | Occasionally used |

---

## Technology Stack

### Backend
- Java
- JSP
- Servlets
- JDBC

### Frontend
- HTML
- CSS
- JavaScript

### Database
- MySQL

### Server & Runtime
- Apache Tomcat

### Build and Development Tools
- Maven
- Git
- GitHub
- XAMPP
- IntelliJ IDEA

### Deployment
- Railway
- ngrok

---

## System Architecture

The application follows a structured layered architecture to separate business logic, presentation, and data access responsibilities.

| Layer | Description |
|---|---|
| **Model Layer** | Java classes such as `User`, `Admin`, `Customer`, `Event`, and `Booking` that represent core system entities |
| **View Layer** | JSP pages responsible for rendering customer and admin interfaces |
| **Controller Layer** | Servlets that handle routing, validation, permissions, and request flow |
| **Service Layer** | Business logic for users, events, bookings, and system operations |
| **Database Layer** | MySQL accessed via JDBC for persistent storage |

This design improves maintainability, readability, and scalability while keeping the project organized for future expansion.

---

## Core Functional Areas

### Customer Module
Customers can interact with the public-facing booking experience and manage their own activity.

**Capabilities**
- Register and log in securely
- Browse active events
- Search events by title and venue
- Filter events by category
- View detailed event information
- Book event tickets
- View booking history
- Cancel bookings
- Update personal profile information

---

### Admin Module
Administrators operate through a dedicated management dashboard with permission-based access.

**Capabilities**
- Access a dedicated admin dashboard
- Create new events
- Edit event details
- Cancel or delete events
- Upload and manage event images
- View and manage bookings
- Manage registered users
- Review and process admin access requests
- Operate under categorized permission levels

---

## Permission-Based Admin Access Control

A major system highlight is the introduction of categorized admin permissions.  
This allows the dashboard and accessible modules to adapt based on the assigned permission level.

| Permission Type | Access Scope |
|---|---|
| **Events Only** | Event management features only |
| **Bookings Only** | Booking management features only |
| **Events + Bookings** | Access to both event and booking modules |
| **Full Access** | Full administrative control including users and admin request management |

This permission model improves security, supports responsibility separation, and makes the admin environment more realistic and production-oriented.

---

## Key Features

### Customer Features
- Account registration and login
- Session-based authentication
- Event browsing and filtering
- Detailed event viewing
- Ticket booking workflow
- Booking history management
- Booking cancellation
- Profile update support

### Admin Features
- Professional admin dashboard
- Permission-aware navigation and module visibility
- Event creation, editing, cancellation, and deletion
- Booking viewing and management
- User administration
- Admin request approval workflow
- Dynamic dashboard experience based on assigned access level

---

## Booking and Event Workflow Logic

EventHorizon includes real application logic beyond simple CRUD operations.

### Event Handling
- Events store total seats and available seats separately
- Only active events are visible to customers
- Event images are stored and served through the application

### Booking Handling
- Seat counts are reduced at booking time
- Seats are restored when a booking is cancelled or rejected
- Booking records are stored and linked to users and events
- Customers can track their own booking history

### Admin Workflow
- New admin accounts can be requested through a controlled process
- Requests remain pending until reviewed
- Approval creates a new admin account with the assigned permission type
- Self-approval restrictions improve workflow integrity

---

## Functional Modules

| Module | Responsibilities | Access |
|---|---|---|
| **Authentication Module** | Login, logout, registration, session management, role validation | All Users |
| **Event Browsing Module** | View, search, and filter active events | Customers |
| **Booking Module** | Booking creation, cancellation, history, seat updates | Customers |
| **Event Management Module** | Create, edit, cancel, delete events | Admin |
| **Booking Management Module** | View and manage all customer bookings | Admin |
| **User Management Module** | Manage user accounts and admin permission setup | Full Access Admin |
| **Admin Request Module** | Submit, review, approve, reject admin requests | Full Access Admin |

---

## Project Highlights

- Full-stack Java web application with real booking flow
- Layered architecture with clear separation of concerns
- Role-based and permission-based access control
- Dynamic dashboard and sidebar adaptation by admin type
- Real-time seat availability tracking
- Booking cancellation with seat restoration logic
- Database-integrated event image support
- Railway deployment with MySQL integration
- Modern dark-themed UI with consistent branding
- More realistic business workflow than a standard CRUD academic project

---

## Deployment Details

| Component | Description |
|---|---|
| **Hosting Platform** | Railway |
| **Database** | Railway MySQL |
| **Server** | Apache Tomcat |
| **Backend Runtime** | Java Servlets + JSP |
| **Configuration Management** | Environment variables |
| **Image Handling** | Stored in database and served by the application |
| **Email Service** | Currently disabled due to SMTP limitations |

---

## Project Structure

<p align="center">
  <img src="https://github.com/sub2003/EventHorizon/blob/main/src/Screenshot%202026-04-11%20175107.png?raw=true" width="760" alt="Project Structure"/>
</p>

---

## Development Focus

This project demonstrates practical learning in:

- Java web application development
- MVC-style design thinking
- Servlet-based request handling
- JDBC database interaction
- Access control and permission enforcement
- UI structuring for admin systems
- Deployment and configuration on cloud platforms

---

## Future Enhancements

The project can be extended with more advanced features such as:

- Password hashing using BCrypt
- OTP or email verification
- Payment gateway integration
- QR-based digital ticket generation
- Email notifications for bookings and approvals
- Advanced analytics dashboard
- Event recommendation engine
- Better sorting and filtering controls
- REST API layer for future integrations
- React or modern frontend migration

---

## Author

| Field | Details |
|---|---|
| **Name** | Subhanu Ravisankha Aththanayaka |
| **Institution** | SLIIT |
| **Program** | BSc (Hons) in IT |
| **Focus Areas** | Software Engineering, Web Systems, and AI-Oriented Development |

---

## Conclusion

**EventHorizon** is a practical and professionally structured event booking platform that combines customer operations, event lifecycle control, booking workflows, and permission-based administration in one complete system.

It reflects hands-on experience in building, debugging, deploying, and improving a real-world style Java web application.

<p align="center">
  <sub>Built as a full-stack learning project with a strong focus on practical system design, workflow logic, and professional implementation.</sub>
</p>
