<h1 align="center">EventHorizon</h1>

<p align="center">
  <b>Event Booking Web Application</b><br>
  Full-stack Java system for event discovery, booking, and admin management
</p>

<p align="center">
  <a href="https://glistening-light-production-f277.up.railway.app/">
    <img src="https://img.shields.io/badge/Live%20App-Railway-6C63FF?style=for-the-badge"/>
  </a>
</p>

---

## Overview

<table>
<tr>
<td width="50%">

EventHorizon is a complete event booking platform built using Java (JSP & Servlets).  
It enables users to browse events, book tickets, and manage their activity.

</td>
<td width="50%">

The system also provides powerful admin tools for managing events, users, and bookings with structured workflows.

</td>
</tr>
</table>

---

## Live Deployment

<table>
<tr>
<th>Environment</th>
<th>Access</th>
<th>Status</th>
</tr>

<tr>
<td><b>Railway (Production)</b></td>
<td>https://glistening-light-production-f277.up.railway.app/</td>
<td>Active</td>
</tr>

<tr>
<td><b>ngrok (Temporary)</b></td>
<td>https://phosphate-shrine-iguana.ngrok-free.dev/EventHorizon</td>
<td>Occasional</td>
</tr>
</table>

---

## Technology Stack

<table>
<tr>
<th>Category</th>
<th>Technologies</th>
</tr>

<tr>
<td><b>Backend</b></td>
<td>

<img src="https://img.shields.io/badge/Java-ED8B00?style=flat-square"/>
<img src="https://img.shields.io/badge/Servlets-6DB33F?style=flat-square"/>
<img src="https://img.shields.io/badge/JSP-323330?style=flat-square"/>

</td>
</tr>

<tr>
<td><b>Frontend</b></td>
<td>

<img src="https://img.shields.io/badge/HTML-000000?style=flat-square"/>
<img src="https://img.shields.io/badge/CSS-1572B6?style=flat-square"/>
<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square"/>

</td>
</tr>

<tr>
<td><b>Server</b></td>
<td>

<img src="https://img.shields.io/badge/Tomcat-F8DC75?style=flat-square"/>

</td>
</tr>

<tr>
<td><b>Database</b></td>
<td>

<img src="https://img.shields.io/badge/MySQL-4479A1?style=flat-square"/>
<img src="https://img.shields.io/badge/JDBC-000000?style=flat-square"/>

</td>
</tr>

<tr>
<td><b>Tools & Environment</b></td>
<td>

<img src="https://img.shields.io/badge/Maven-C71A36?style=flat-square"/>
<img src="https://img.shields.io/badge/XAMPP-FB7A24?style=flat-square"/>
<img src="https://img.shields.io/badge/Git-181717?style=flat-square"/>
<img src="https://img.shields.io/badge/GitHub-000000?style=flat-square"/>

</td>
</tr>

<tr>
<td><b>Deployment</b></td>
<td>

<img src="https://img.shields.io/badge/Railway-0B0D0E?style=flat-square"/>
<img src="https://img.shields.io/badge/ngrok-1F1F1F?style=flat-square"/>

</td>
</tr>

</table>

---

## Architecture

<table>
<tr>
<th width="25%">Layer</th>
<th width="75%">Description</th>
</tr>

<tr>
<td><b>Model</b></td>
<td>Java classes such as Event, User, Booking, Admin</td>
</tr>

<tr>
<td><b>View</b></td>
<td>JSP pages for frontend rendering</td>
</tr>

<tr>
<td><b>Controller</b></td>
<td>Servlets handling request/response logic</td>
</tr>

<tr>
<td><b>Database</b></td>
<td>MySQL using JDBC</td>
</tr>
</table>

---

## Core Features

<table>
<tr>
<th width="50%">User Side</th>
<th width="50%">Admin Side</th>
</tr>

<tr>
<td>

- User registration and login  
- Browse and search events  
- Filter by category  
- Book tickets  
- Cancel bookings  
- View personal bookings  

</td>

<td>

- Manage events (CRUD)  
- Manage users  
- View all bookings  
- Approve admin requests  
- Control system operations  

</td>
</tr>
</table>

---

## System Modules

<table>
<tr>
<th width="33%">Module</th>
<th width="33%">Responsibilities</th>
<th width="34%">Access Level</th>
</tr>

<tr>
<td>Authentication</td>
<td>Login, session handling, role validation</td>
<td>All Users</td>
</tr>

<tr>
<td>Event Management</td>
<td>Create, update, delete events</td>
<td>Admin</td>
</tr>

<tr>
<td>Booking System</td>
<td>Ticket booking, cancellation, seat tracking</td>
<td>Customer</td>
</tr>

<tr>
<td>User Management</td>
<td>Manage accounts and roles</td>
<td>Admin</td>
</tr>
</table>

---

## Project Structure

<p align="center">
  <img src="https://github.com/sub2003/EventHorizon/blob/main/src/Screenshot%202026-04-11%20175107.png?raw=true" width="700"/>
</p>

---

## Deployment Details

<table>
<tr>
<th>Component</th>
<th>Configuration</th>
</tr>

<tr>
<td>Hosting</td>
<td>Railway</td>
</tr>

<tr>
<td>Database</td>
<td>Railway MySQL</td>
</tr>

<tr>
<td>Backend</td>
<td>Java (Servlets)</td>
</tr>

<tr>
<td>Environment</td>
<td>Configured using environment variables</td>
</tr>

<tr>
<td>Email</td>
<td>Disabled (SMTP limitation)</td>
</tr>
</table>

---

## Future Improvements

<table>
<tr>
<td width="50%">

- Password hashing (bcrypt)  
- Email API integration  
- Payment gateway  

</td>
<td width="50%">

- React frontend upgrade  
- Analytics dashboard  
- Advanced filtering  

</td>
</tr>
</table>

---

## Author

<table>
<tr>
<td width="30%"><b>Name</b></td>
<td width="70%">Subhanu Ravisankha Aththanayaka</td>
</tr>

<tr>
<td><b>Education</b></td>
<td>SLIIT Undergraduate – BSc (Hons) IT</td>
</tr>

<tr>
<td><b>Focus</b></td>
<td>Software Engineering & AI Systems</td>
</tr>
</table>

---

<p align="center">
  <sub>Designed for real-world application development and learning</sub>
</p>
