<h1 align="center">🎟️ EventHorizon</h1>
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

## 🌐 Live Demo

👉 **[Open EventHorizon Web App](https://phosphate-shrine-iguana.ngrok-free.dev/EventHorizon)**

> ⚠️ This demo is hosted using ngrok, so availability may be temporary.

---

## 🚀 Features

### 🔐 Authentication & Access Control
- Secure login for Admins and Customers
- Session-based authentication
- Role-based page access
- Separate registration flow for customers
- Admin request system with approval workflow

### 👑 Admin Approval Workflow
- Users can request admin access
- Existing admins can create admin requests
- Pending admin requests can be reviewed from the admin panel
- An admin cannot approve their own request
- Approved requests automatically create a new admin account

### 🎫 Event Management
- Browse all active events
- View event details with pricing, venue, date, and seat availability
- Search events by title or venue
- Filter events by category
- Admins can add, update, cancel, and delete events
- Event image upload support

### 🛒 Booking System
- Book tickets for available events
- Real-time seat availability updates
- Cancel bookings with seat restoration
- View personal bookings
- Admin-side booking visibility and management

### 👤 User Management
- Customer profile management
- Admin user listing and management
- Separate admin and customer experiences

### 🎨 UI / UX
- Dark-themed modern interface
- Animated event browsing experience
- Search and category filtering
- Responsive layouts for core pages

---

## 🧱 System Architecture

This project follows the **MVC (Model-View-Controller)** pattern:

- **Model** → Java classes such as `Event`, `User`, `Booking`, `Admin`, and `Customer`
- **View** → JSP pages
- **Controller** → Java Servlets
- **Database Layer** → JDBC with MySQL

---

## 🛠️ Technologies Used

- Java (Core Java + OOP)
- JSP
- Servlets
- Apache Tomcat
- MySQL
- JDBC
- HTML / CSS / JavaScript
- Maven

---

## 📂 Project Structure

<p align="center">
  <img src="https://github.com/sub2003/EventHorizon/blob/main/src/Screenshot%202026-04-11%20175107.png?raw=true" width="700"/>
</p>

---

## 📌 Core Modules

### Customer Module
- Register and log in
- Browse events
- Search and filter events
- View event details
- Book tickets
- View and cancel bookings
- Manage profile

### Admin Module
- Log in to admin dashboard
- Manage events
- Manage users
- View bookings
- Create admin requests
- Approve or reject pending admin requests

---

## ⚠️ Current Notes

- Built as a Java web application using JSP/Servlet architecture
- Requires MySQL database configuration
- Best run using Apache Tomcat
- Live demo link may change because it uses ngrok
- SMTP-based email verification was removed from the hosted workflow due to deployment environment limitations

---

## 🔮 Future Improvements

- Deploy permanently to a cloud platform
- Add password hashing with bcrypt
- Add email service using API-based provider
- Improve frontend with a richer component-based UI
- Add payment gateway integration
- Add analytics and reporting for admins
- Add event recommendation and advanced filtering

---

## 👨‍💻 Author

**Subhanu Ravisankha Aththanayaka**  
SLIIT Undergraduate  
BSc (Hons) in IT

---

## ⭐ Final Note

EventHorizon is a complete full-stack Java web application that demonstrates authentication, event management, ticket booking, admin workflows, and database integration in a practical real-world project.

<p align="center">
💡 Built for learning, creativity, and real-world software development.
</p>
