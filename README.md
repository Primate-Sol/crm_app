# README

# CRM App
A Ruby-based web CRM application using Ruby on Rails with file-based JSON storage, hosted on DigitalOcean.

# Completed Features
- User Registration & Authentication
Users can register accounts and securely log in with password hashing via bcrypt.

- Session Management
Secure session-based login with user-specific access.

- Client Management
Add, view, and delete clients. Each client record is tied to the logged-in user.

- Task Management
Users can create, edit, and manage tasks associated with their account.

- Basic Dashboard
After login, users are greeted with a dashboard showing counts of clients and tasks.

- Data Persistence via JSON Files
All app data (users, clients, tasks) is stored in JSON files using a JsonFileStore helper with file locking.

- ERB-based UI
Clean and minimal interface using Rails’ embedded Ruby templates.