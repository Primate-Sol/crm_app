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

# In Progress / Future Features
- Client Profile Enhancements
Tags for segmentation

- Activity logs / internal notes
Last contacted date

- Project Management
Create and organize projects
Link tasks to projects

- Role-Based Access Control (RBAC)
Admin, standard user, and guest roles
Access restrictions based on user role

- Invoicing & Billing
Generate, store, and email invoices
Track payment status

- Ticketing System
Track support requests linked to clients
Assign tickets to users

- Workflow Automation
Triggers and actions (e.g. auto-assign task when client added)

- Document Management
Upload, tag, and associate documents with clients/tasks

- Calendar & Scheduling
Integrated calendar view
Schedule reminders and task due dates

- Email Integration
Send/receive emails from within the app
Associate communications with client records

- Proposal & Contract Tools
Generate editable templates
Client e-signature support (future goal)

# Tech Stack
- Ruby on Rails (with ERB for frontend)
- JSON-based storage (no database required)
- Hosted on DigitalOcean (Droplet-based deployment)

> This README will continue to evolve as more features are developed and refined.
