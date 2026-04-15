# EventHorizon

<p align="center">
  <img src="https://img.shields.io/badge/Java-Web%20Application-6C63FF?style=for-the-badge" alt="Java Web Application" />
  <img src="https://img.shields.io/badge/JSP%20%7C%20Servlets%20%7C%20JDBC-0E1530?style=for-the-badge" alt="JSP Servlets JDBC" />
  <img src="https://img.shields.io/badge/MySQL-Database-1D3557?style=for-the-badge" alt="MySQL Database" />
  <img src="https://img.shields.io/badge/Railway-Deployed-6C63FF?style=for-the-badge" alt="Railway Deployment" />
</p>

<p align="center">
  <strong>Full-Stack Event Booking and Administration Platform</strong><br>
  A professionally structured Java web application for event discovery, secure booking, payment approval, digital ticketing, and permission-based administration.
</p>

<p align="center">
  <a href="https://glistening-light-production-f277.up.railway.app/">
    <img src="https://img.shields.io/badge/Live%20Application-Open%20on%20Railway-6C63FF?style=for-the-badge" alt="Live Application"/>
  </a>
</p>

---

## Overview

**EventHorizon** is a full-stack event booking platform built using **Java, JSP, Servlets, JDBC, and MySQL**. It simulates a real-world ticketing system by combining customer-facing event discovery with structured administrative workflows in a single platform.

The project goes beyond a basic CRUD implementation by including:

- session-based authentication
- role-based and permission-based access control
- event lifecycle management
- booking and cancellation workflows
- admin approval processes
- payment confirmation flow
- QR-based digital ticket generation and verification
- cloud deployment using Railway

It was designed as a practical learning project with strong emphasis on clean architecture, realistic system behavior, and production-style workflow design.

---

## Live Deployment

| Environment | URL | Status |
|---|---|---|
| **Production** | `https://glistening-light-production-f277.up.railway.app/` | Active |

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

### Build Tools
- Maven

### Development Tools
- IntelliJ IDEA
- XAMPP
- Git
- GitHub

### Deployment
- Railway
- ngrok

---

## Key Features

### Customer Features
- Secure account registration and login
- Session-based authentication
- Browse active events
- Search events by title and venue
- Filter events by category
- View event details
- Book tickets for events
- Submit payment reference for booking confirmation
- View personal booking history
- Cancel bookings
- Manage profile details
- View approved digital tickets
- Access QR-based ticket verification links

### Admin Features
- Dedicated admin dashboard
- Permission-aware module access
- Create new events
- Edit event information
- Cancel or delete events
- Manage event images
- View and manage all bookings
- Approve or reject payment submissions
- Manage users
- Review and process admin access requests
- Operate under categorized permission levels
- Access QR-based ticket scanning and verification tools

---

## Digital Ticketing and QR Verification

One of the major functional upgrades in **EventHorizon** is the implementation of a secure digital ticketing workflow.

### Ticket Workflow
- Tickets are generated only after booking approval
- Each generated ticket is assigned a unique secure token
- Approved tickets are stored in the database
- Customers can access tickets through the **My Tickets** interface

### QR Verification Workflow
- Each ticket includes a QR code linked to a verification endpoint
- Scanning a valid system-generated QR code checks the database
- Approved tickets display a valid verification result
- Unknown or external QR codes display **Not Approved**
- Ticket verification logic is backed by database validation rather than static QR image trust

This creates a more realistic event-entry flow and adds a strong practical system component to the project.

---

## System Architecture

The application follows a layered architecture that separates presentation, business logic, and persistence responsibilities.

| Layer | Description |
|---|---|
| **Model Layer** | Entity classes such as `User`, `Admin`, `Customer`, `Event`, `Booking`, and `Ticket` |
| **View Layer** | JSP pages used to render customer and admin interfaces |
| **Controller Layer** | Servlets that manage routing, request handling, validation, and workflow control |
| **Service Layer** | Business logic for users, events, bookings, tickets, and administrative operations |
| **Database Layer** | MySQL persistence accessed through JDBC |

This structure improves:
- maintainability
- readability
- modularity
- scalability for future feature additions

---

## Core Functional Modules

| Module | Responsibilities | Access |
|---|---|---|
| **Authentication Module** | Registration, login, logout, session validation, role enforcement | All Users |
| **Event Browsing Module** | Browse, search, filter, and view active events | Customers |
| **Booking Module** | Create bookings, submit payments, cancel bookings, track history | Customers |
| **Ticket Module** | Generate approved tickets, display QR tickets, verify digital tickets | Customers / Admin |
| **Event Management Module** | Create, update, cancel, and delete events | Admin |
| **Booking Management Module** | Review bookings, approve payments, reject requests | Admin |
| **User Management Module** | Manage user accounts and permission assignments | Full Access Admin |
| **Admin Request Module** | Submit, review, approve, and reject admin access requests | Full Access Admin |

---

## Permission-Based Admin Access Control

A major project highlight is the introduction of **categorized admin permissions**, allowing the dashboard and accessible modules to adapt based on the assigned role scope.

| Permission Type | Access Scope |
|---|---|
| **Events Only** | Event management only |
| **Bookings Only** | Booking and payment management only |
| **Events + Bookings** | Combined access to event and booking modules |
| **Full Access** | Full administrative control including users and admin request handling |

This permission model improves:
- administrative security
- separation of responsibility
- realism of the management workflow
- dashboard flexibility

---

## Booking and Event Workflow Logic

EventHorizon contains workflow logic that reflects real application behavior rather than simple database operations.

### Event Logic
- Events store both **total seats** and **available seats**
- Only active events are visible to customers
- Event details include pricing, category, venue, date, time, and images

### Booking Logic
- Bookings are linked to customers and events
- Seat availability is reduced at booking time
- Seat counts are restored if bookings are cancelled or rejected
- Payment status is tracked separately from booking status
- Approved bookings can generate digital tickets

### Admin Workflow
- Admin access can be requested through a structured request flow
- Requests remain pending until reviewed
- Approval creates a new admin with assigned permission scope
- Permission scope controls available dashboard modules

---

## Project Highlights

- Full-stack Java web application with realistic system workflow
- Layered architecture with clear separation of concerns
- Role-based and permission-based access control
- Professional dark-themed UI with consistent branding
- Real-time seat availability logic
- Booking cancellation with seat restoration
- Payment approval workflow
- QR-based ticket generation and verification
- Database-backed digital ticket validation
- Dynamic admin dashboard behavior based on permission type
- Railway cloud deployment with MySQL integration
- Stronger real-world workflow logic than a standard academic CRUD project

---

## Deployment Details

| Component | Description |
|---|---|
| **Hosting Platform** | Railway |
| **Database** | Railway MySQL |
| **Server** | Apache Tomcat |
| **Runtime** | Java Servlets + JSP |
| **Configuration** | Environment variables |
| **Image Handling** | Stored and served through the application |
| **Ticket Storage** | MySQL-backed digital ticket records |
| **Email Service** | Currently disabled due to SMTP limitations |

---

## Project Structure

<p align="center">
  <img src="https://github.com/sub2003/EventHorizon/blob/main/src/Screenshot%202026-04-11%20175107.png?raw=true" width="760" alt="Project Structure"/>
</p>

---

## Development Focus

This project demonstrates hands-on learning and implementation in:

- Java web application development
- MVC-style design thinking
- Servlet-based request processing
- JDBC-based database integration
- access control and permission management
- workflow-driven system design
- digital ticket verification logic
- UI and dashboard design for administrative systems
- cloud deployment and environment configuration

---

## Future Enhancements

Potential future improvements include:

- Password hashing with BCrypt
- OTP or email verification
- Payment gateway integration
- Downloadable PDF tickets
- Email notifications for bookings and approvals
- Advanced analytics dashboard
- Event recommendation system
- Enhanced sorting and filtering
- REST API layer for external integrations
- React or modern frontend migration
- Multi-event scanning dashboard
- Ticket expiry and entry-time validation

---

## Author

| Field | Details |
|---|---|
| **Name** | Subhanu Ravisankha Aththanayaka |
| **Institution** | SLIIT |
| **Program** | BSc (Hons) in IT |
| **Focus Areas** | Software Engineering, Web Systems, Cybersecurity, and AI-Oriented Development |

---

## Conclusion

**EventHorizon** is a practical, professionally structured event booking platform that combines:

- customer-facing event discovery
- booking and payment workflows
- permission-based administration
- digital ticket generation
- QR-based verification

within a single cohesive system.

It reflects hands-on experience in designing, building, debugging, deploying, and iteratively improving a real-world style Java web application.

<p align="center">
  <sub>Built as a full-stack learning project with a strong focus on workflow logic, structured architecture, and professional implementation.</sub>
</p>
