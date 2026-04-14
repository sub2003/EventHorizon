<h1 align="center">EventHorizon</h1>

<p align="center">
  <b>Event Booking Web Application</b><br>
  A full-stack Java web application for event discovery, ticket booking, and admin management.
</p>

<p align="center">
  <a href="https://glistening-light-production-f277.up.railway.app/">
    <img src="https://img.shields.io/badge/Live%20App-Railway-6C63FF?style=for-the-badge"/>
  </a>
</p>

---

## Overview

EventHorizon is a complete web-based event management and booking system built using Java (JSP & Servlets).  
It provides a structured platform for customers to explore and book events, while administrators manage events, users, and system operations.

---

## Live Deployment

| Environment | Link |
|------------|------|
| **Railway (Production)** | https://glistening-light-production-f277.up.railway.app/ |
| **ngrok (Temporary)** | https://phosphate-shrine-iguana.ngrok-free.dev/EventHorizon |

---

## Technology Stack

<p align="center">
  <img src="https://img.shields.io/badge/Java-ED8B00?style=flat-square&logo=java&logoColor=white"/>
  <img src="https://img.shields.io/badge/JSP-323330?style=flat-square"/>
  <img src="https://img.shields.io/badge/Servlets-6DB33F?style=flat-square"/>
  <img src="https://img.shields.io/badge/Tomcat-F8DC75?style=flat-square&logo=apachetomcat&logoColor=black"/>
  <img src="https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white"/>
  <img src="https://img.shields.io/badge/JDBC-000000?style=flat-square"/>
  <img src="https://img.shields.io/badge/Maven-C71A36?style=flat-square&logo=apachemaven&logoColor=white"/>
</p>

---

## Architecture

| Layer        | Description |
|-------------|------------|
| **Model**    | Java classes (Event, User, Booking) |
| **View**     | JSP pages |
| **Controller** | Servlets |
| **Database** | MySQL via JDBC |

Follows the **MVC pattern** for clear separation of concerns.

---

## Core Features

### Authentication & Access
- Session-based login system  
- Role-based authorization (Admin / Customer)  
- Separate registration flows  
- Admin request approval system  

---

### Event Management
- View and explore events  
- Search by title or venue  
- Filter by category  
- Event image upload  
- Admin CRUD operations  

---

### Booking System
- Ticket booking  
- Live seat availability updates  
- Booking cancellation with seat restoration  
- Personal booking history  

---

### Admin Controls
- Manage users  
- Manage events  
- View bookings  
- Approve or reject admin requests  

---

## Modules

### Customer
- Register and login  
- Browse and filter events  
- Book and manage tickets  

### Admin
- Manage events and users  
- Handle bookings  
- Approve admin requests  

---

## Project Structure

<p align="center">
  <img src="https://github.com/sub2003/EventHorizon/blob/main/src/Screenshot%202026-04-11%20175107.png?raw=true" width="700"/>
</p>

---

## Deployment Notes

- Hosted on **Railway (Java + MySQL)**
- Environment variables used for database connection
- Email verification disabled in production environment

---

## Future Enhancements

- Password hashing (bcrypt)  
- Email integration (Resend / SendGrid)  
- Payment gateway integration  
- Frontend modernization (React)  
- Analytics dashboard  

---

## Author

**Subhanu Ravisankha Aththanayaka**  
SLIIT Undergraduate  
BSc (Hons) in IT  

---

<p align="center">
  <sub>Built for learning and real-world application development</sub>
</p>
