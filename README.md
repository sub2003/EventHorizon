EventHorizon – Event Booking Web Application

EventHorizon is a Java-based web application designed to manage events and ticket bookings. It allows users to browse events, book tickets, and manage their reservations, while administrators can create and control events efficiently.

🚀 Features
🔐 User Authentication
Secure login system for Admin and Customers
🎟️ Event Management
View available events
Search events by category, title, or venue
Admins can add, update, and cancel events
🛒 Booking System
Book tickets for events
View personal bookings
Automatic seat management
👤 Role-Based Access
Admin: Full control over events
Customer: Browse and book events
📁 File-Based Data Storage
Uses .txt files to store users, events, and bookings
Data is stored locally using a custom file handler
Runtime path handled via system directory
(e.g., C:\Users\<username>\eventhorizon_data\)
🛠️ Technologies Used
Java (Servlets & JSP)
Apache Tomcat
HTML, CSS, JavaScript
Maven (for dependency management)
📂 Project Structure
src/
 └─ main/
    ├─ java/com/eventhorizon/
    │   ├─ model/
    │   ├─ service/
    │   ├─ servlet/
    │   └─ util/
    └─ webapp/
        ├─ jsp/
        ├─ css/
        └─ js/
⚙️ How It Works
The application follows MVC architecture:
Servlets → Handle requests
Services → Business logic
FileHandler → Data storage
Data is stored in:
users.txt
events.txt
bookings.txt
Files are loaded from a system directory instead of the project folder.
▶️ Running the Project
Open the project in IntelliJ IDEA
Configure Apache Tomcat server
Run the project
Open in browser:
http://localhost:8080/EventHorizon-1.0/
🌐 Sharing the Application (Temporary)

To share your app with others:

Use tools like Ngrok
Run:
ngrok http 8080
Share the generated public URL
⚠️ Limitations
Uses local .txt files (not suitable for production)
Works only when the host machine is running
Not scalable for multiple concurrent users
🔮 Future Improvements
🔄 Migrate to MySQL database
🌍 Deploy to cloud hosting (AWS / Render)
🔐 Improve security and authentication
📱 Enhance UI/UX
👨‍💻 Author

Developed by Subhanu Ravisankha Aththanayaka
Undergraduate at SLIIT – BSc (Hons) in IT (Cybersecurity)

⭐ Final Note

This project demonstrates a complete full-stack Java web application with authentication, booking logic, and MVC architecture — ideal for learning backend development concepts.
