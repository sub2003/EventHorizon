<h1 align="center">EventHorizon</h1>

<p align="center">
  <strong>Event Booking Web Application</strong><br>
  A full-stack Java web platform for event discovery, ticket booking, and administrative management.
</p>

<p align="center">
  <a href="https://glistening-light-production-f277.up.railway.app/">
    <img src="https://img.shields.io/badge/Live%20App-Railway-6C63FF?style=for-the-badge" alt="Live App on Railway"/>
  </a>
</p>

---

## Overview

**EventHorizon** is a full-stack event booking and management system developed using **Java, JSP, Servlets, JDBC, and MySQL**. It is designed to provide a complete workflow for both customers and administrators within a single platform.

The application enables users to discover events, view event details, make bookings, and manage their own activity. On the administrative side, it provides structured tools for managing events, users, bookings, and system operations through a professional dashboard environment.

---

## Live Deployment

| Environment | Access | Status |
|---|---|---|
| **Railway (Production)** | `https://glistening-light-production-f277.up.railway.app/` | Active |
| **ngrok (Temporary)** | `https://phosphate-shrine-iguana.ngrok-free.dev/EventHorizon` | Occasional |

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

### Server
- Apache Tomcat

### Build & Development Tools
- Maven
- Git
- GitHub
- XAMPP

### Deployment
- Railway
- ngrok

---

## System Architecture

The project follows a layered web application structure:

| Layer | Description |
|---|---|
| **Model** | Java classes such as `Event`, `User`, `Booking`, and `Admin` for representing system entities |
| **View** | JSP pages used to render the user interface |
| **Controller** | Servlets responsible for request handling, business flow, and navigation |
| **Database** | MySQL database accessed through JDBC |

This structure helps separate data handling, interface rendering, and request processing, making the system easier to maintain and extend.

---

## Core Features

### Customer Features
- User registration and login
- Secure session-based access
- Browse available events
- Search events by title or venue
- Filter events by category
- View detailed event information
- Book tickets online
- Cancel bookings
- View personal booking history
- Manage user profile information

### Admin Features
- Access dedicated admin dashboard
- Add new events
- Update existing events
- Cancel or delete events
- Upload and manage event images
- Manage registered users
- View all customer bookings
- Review and approve admin requests
- Monitor overall system activity

---

## Key Functional Modules

| Module | Responsibilities | Access Level |
|---|---|---|
| **Authentication Module** | Login, logout, session handling, role validation | All Users |
| **Event Management Module** | Create, update, cancel, and delete events | Admin |
| **Event Browsing Module** | Display, search, and filter active events | Customer |
| **Booking Module** | Ticket booking, cancellation, booking history, seat updates | Customer |
| **User Management Module** | Manage customer and admin accounts | Admin |
| **Admin Request Module** | Handle admin approval workflow | Admin |

---

## Project Highlights

- Full-stack Java web application with a complete booking workflow
- Role-based system for customers and administrators
- Dynamic event listing with search and category filtering
- Real-time seat availability tracking
- Booking cancellation with seat restoration logic
- Professional admin dashboard for system control
- Database-driven event image storage and retrieval
- Railway deployment with MySQL integration
- Modern dark-themed UI with premium styling and consistent branding

---

## Booking and Event Management Logic

The project is not just a basic CRUD application. It includes important real-world workflow logic such as:

- Managing event availability through total seats and available seats
- Automatically reducing available seats after booking
- Restoring seats after cancellation
- Showing only active events to customers
- Maintaining separate admin controls for event operations
- Supporting image upload and retrieval for event presentation

These features make the system more practical and closer to a real production-style booking application.

---

## Deployment Details

| Component | Configuration |
|---|---|
| **Hosting Platform** | Railway |
| **Database** | Railway MySQL |
| **Backend Runtime** | Java + Servlets |
| **Server** | Apache Tomcat |
| **Configuration** | Environment variables |
| **Image Handling** | Stored and retrieved through the application database |
| **Email Service** | Currently disabled due to SMTP limitations |

---

## Project Structure

<p align="center">
  <img src="https://github.com/sub2003/EventHorizon/blob/main/src/Screenshot%202026-04-11%20175107.png?raw=true" width="700" alt="Project Structure"/>
</p>

---

## Future Improvements

The project can be extended further with the following enhancements:

- Password hashing with bcrypt
- Email API integration
- Payment gateway integration
- Advanced analytics dashboard
- Improved event recommendation system
- React-based frontend upgrade
- Enhanced filtering and sorting options
- QR code ticket generation
- Booking confirmation email support

---

## Author

| Field | Details |
|---|---|
| **Name** | Subhanu Ravisankha Aththanayaka |
| **Education** | SLIIT Undergraduate – BSc (Hons) in IT |
| **Academic Focus** | Software Engineering and AI Systems |

---

<p align="center">
  <sub>Designed as a practical full-stack application for real-world learning and system development.</sub>
</p>
