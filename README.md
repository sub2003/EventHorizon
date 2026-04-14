<h1 align="center">EventHorizon</h1>
<h3 align="center">Event Booking Web Application</h3>

<p align="center">
A full-stack Java web application for discovering events, booking tickets, and managing event operations with role-based access, admin approval workflows, and real-time seat updates.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white"/>
  <img src="https://img.shields.io/badge/JSP-323330?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Servlets-6DB33F?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black"/>
  <img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white"/>
  <img src="https://img.shields.io/badge/JDBC-000000?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Maven-C71A36?style=for-the-badge&logo=apachemaven&logoColor=white"/>
</p>

---

## Live Demo

**Railway Deployment (Primary)**  
https://glistening-light-production-f277.up.railway.app/

**Temporary Demo (ngrok)**  
https://phosphate-shrine-iguana.ngrok-free.dev/EventHorizon  

> Note: ngrok link may not always be active.

---

## Features

### Authentication & Access Control
- Secure login for Admins and Customers
- Session-based authentication
- Role-based access control
- Separate registration flow for customers
- Admin request system with approval workflow

---

### Admin Approval Workflow
- Users can request admin access  
- Existing admins can create admin requests  
- Pending requests can be approved or rejected  
- Admins cannot approve their own requests  
- Approved requests create new admin accounts  

---

### Event Management
- View all active events  
- View event details (date, time, venue, seats)  
- Search events by title or venue  
- Filter events by category  
- Admin capabilities:
  - Add events  
  - Update events  
  - Cancel or delete events  
- Event image upload support  

---

### Booking System
- Book tickets for events  
- Real-time seat availability updates  
- Cancel bookings with seat restoration  
- View personal bookings  

---

### User Management
- Customer profile management  
- Admin user management  
- Role-based dashboards  

---

### UI / UX
- Dark-themed interface  
- Smooth animations and transitions  
- Search and category filtering  
- Responsive layout  

---

## System Architecture

Follows the **MVC (Model-View-Controller)** pattern:

- **Model** → Java classes (Event, User, Booking, Admin)
- **View** → JSP pages  
- **Controller** → Servlets  
- **Database Layer** → JDBC with MySQL  

---

## Technologies Used

- Java (Core + OOP)
- JSP & Servlets
- Apache Tomcat
- MySQL
- JDBC
- HTML / CSS / JavaScript
- Maven

---

## Modules

### Customer
- Register and log in  
- Browse and search events  
- Book tickets  
- Manage bookings  

### Admin
- Manage events  
- Manage users  
- View bookings  
- Approve admin requests  

---

## Notes

- Email verification is disabled in deployment due to SMTP limitations  
- Railway deployment uses environment variables  
- Database hosted on Railway MySQL  
- Designed for learning and real-world practice  

---

## Future Improvements

- Add password hashing (bcrypt)  
- Integrate email API (Resend / SendGrid)  
- Add payment gateway  
- Improve frontend (React / SPA)  
- Add analytics dashboard  

---

## Author

Subhanu Ravisankha Aththanayaka  
SLIIT Undergraduate  
BSc (Hons) in IT  

---

## Final Note

EventHorizon demonstrates a complete **full-stack Java web application**, including authentication, admin workflows, booking systems, and database integration in a real-world project.

---

<p align="center">
Built for learning, innovation, and real-world application development.
</p>
