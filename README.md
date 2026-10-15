# ClinicQ - Patient Queue and Appointment Management System

A Dart console application designed to help a community clinic manage patient registration, queue prioritization, consultation flow, appointments, and daily reporting in a more efficient and structured way.

## Overview

ClinicQ was developed as a simple software engineering prototype for a real-world healthcare challenge: many clinics still rely on manual paper-based systems for handling patient queues and appointment bookings. This often leads to long waiting lines, delays for emergency patients, inconsistent consultation handling, and appointment conflicts.

This project addresses those issues by providing a lightweight command line system that automates the queue process and keeps the clinic workflow more organized.

## Problem Statement

In a busy clinic, patients arrive at different times and with different levels of urgency. Without a proper system, staff may struggle to:

- identify patients quickly,
- prioritize emergency cases,
- maintain a fair queue,
- assign patients to the correct doctors,
- avoid double booking appointments,
- track consultation outcomes and clinic performance.

ClinicQ solves these challenges with a simple console-based solution built in Dart.

## Objectives

The main objectives of this project are to:

- Register patients with relevant details such as name, age, gender, and phone number.
- Check in patients and assign queue priority automatically based on urgency.
- Maintain a waiting queue in a fair and ordered manner.
- Allocate patients to available doctors for consultations.
- Allow doctors to complete consultations and become available again.
- Book appointments while preventing double-booking conflicts.
- Generate a daily summary report for clinic operations.

## Features

The application includes the following major features:

- Patient registration
- Automatic patient check-in and priority assignment
- Emergency, special, and normal patient prioritization
- Waiting queue sorted by priority and initial arrival order
- Doctor selection and consultation management
- Completion of consultations and doctor availability updates
- Appointment booking with conflict detection
- Appointment listing
- Daily operational report for the clinic

## Priority Logic

The system gives queue priority based on patient condition and risk level:

- Emergency patients are placed highest in priority.
- Special category patients include:
  - children aged 5 and under,
  - adults aged 60 and above,
  - pregnant patients.
- Normal cases are placed after emergency and special cases.

This ensures urgent cases are handled first while still keeping the system fair and orderly.

## Application Workflow

The program flow is simple and designed to mimic a real clinic operation:

1. Add doctors to the system.
2. Register new patients.
3. Check in a patient and issue a queue ticket.
4. View the current waiting line.
5. Call the next patient to an available doctor.
6. Complete the consultation when the doctor finishes treatment.
7. Book appointments for future visits.
8. View all booked appointments.
9. Generate a daily report summarizing clinic activity.

## Tech Stack

- Language: Dart
- Runtime: Dart SDK
- Interface: Console-based CLI

## Project Structure

```text
Clinicq-dart-prototype-Group5-main/
├── main.dart                # Core application logic
├── README.md               # Project documentation
├── screenshots/            # Program screenshots and sample outputs
└── .gitignore              # Git ignore rules (if present in your setup)
```

## Main Menu Options

When the program starts, it displays a menu similar to this:

```text
1. Register patient
2. Check in patient
3. View waiting queue
4. Call next patient
5. Complete consultation
6. Book appointment
7. View appointments
8. Daily report
0. Exit
```

Each option allows staff to manage a specific part of the clinic workflow.

## Core Classes

The application uses a number of classes to model the clinic domain:

- Patient
  - Stores patient information such as ID, name, age, gender, and phone number.

- Doctor
  - Stores doctor identity, specialty, and availability status.

- Ticket
  - Represents a patient’s queue entry and includes complaint, priority, current status, and assigned doctor.

- Appointment
  - Stores a scheduled meeting between a patient and a doctor on a particular date and time.

## Data Management

The system stores data in memory while the console program is running. This makes it suitable for a prototype and helps demonstrate the logic clearly without requiring a database.

The application tracks:

- patients,
- doctors,
- waiting tickets,
- active consultations,
- appointments,
- generated reports.

## Validation and Safety Features

The prototype includes basic validation to improve user experience and avoid common errors:

- empty input is rejected,
- only valid numeric values are accepted for IDs and age,
- gender is restricted to male or female selections,
- appointment conflicts are prevented,
- consultation completion is only allowed when a doctor is actively serving a patient.

## Screenshots

The project includes screenshots of the application running in the terminal. These can be viewed in the `screenshots/` folder and demonstrate the system's menu, queue handling, appointment flow, and reporting.

## Use Case

This system is designed for a small to medium-sized clinic where staff need a quick digital way to handle:

- patient intake,
- emergency prioritization,
- queue management,
- doctor assignment,
- appointments,
- reporting.

It is ideal as a learning project, prototype, or demonstration of queue-management logic in healthcare systems.

## Benefits of the Project

This console application helps simplify clinic operations by:

- reducing manual paperwork,
- improving response time for emergency cases,
- organizing waiting queues fairly,
- minimizing confusion when assigning patients to doctors,
- preventing booking conflicts,
- giving staff a quick overview of daily clinic performance.

## Future Improvements

Although the current version is a functional prototype, it could be enhanced in future versions by adding:

- persistent storage with a database,
- patient records editing and deletion,
- login and roles for staff and administrators,
- search and filter functions,
- graphical user interface (GUI),
- export of reports to PDF or CSV,
- appointment reminder notifications,
- more advanced clinic analytics.

## Authors

This project was developed by semester 3 students of BSEM1101 Of the Limkokwing University of Creative Technology, Sierra Leone, as part of the Software Engineering coursework.

Contributors:

- Maria Williams
- Ameynor S. Kamara
- Alpha Abubakarr Leigh
- Ibrahim Sorie Kamara

## Notes

This repository is a console-based prototype intended to demonstrate how a digital queue and appointment system can support healthcare operations. It is designed for educational and demonstration purposes and can be expanded into a more robust real-world clinic management system.
