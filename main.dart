import 'dart:io';

// ClinicQ - Patient Queue and Appointment Management System (simple version)

class Patient {
  int id;
  String name;
  int age;
  String gender;
  String phone;
  Patient(this.id, this.name, this.age, this.gender, this.phone);
}

class Doctor {
  int id;
  String name;
  String specialty;
  bool available = true;
  Doctor(this.id, this.name, this.specialty);
}

class Ticket {
  int number;
  Patient patient;
  String complaint;
  int priority; // 1 = emergency, 2 = special, 3 = normal
  String status = 'waiting'; // waiting, consulting, completed
  Doctor? doctor;
  Ticket(this.number, this.patient, this.complaint, this.priority);

  String priorityName() {
    if (priority == 1) return 'EMERGENCY';
    if (priority == 2) return 'SPECIAL';
    return 'NORMAL';
  }
}

class Appointment {
  int id;
  Patient patient;
  Doctor doctor;
  String date;
  String time;
  Appointment(this.id, this.patient, this.doctor, this.date, this.time);
}

// ---------- Data stored in memory ----------
List<Patient> patients = [];
List<Doctor> doctors = [];
List<Ticket> tickets = [];
List<Appointment> appointments = [];
int nextPatientId = 1;
int nextTicketNumber = 1;
int nextAppointmentId = 1;

// ---------- Input helpers ----------
String readText(String message) {
  while (true) {
    stdout.write(message);
    String? input = stdin.readLineSync();
    if (input != null && input.trim().isNotEmpty) {
      return input.trim();
    }
    print('Input cannot be empty.');
  }
}

int readInt(String message, int min, int max) {
  while (true) {
    stdout.write(message);
    String? input = stdin.readLineSync();
    int? value = int.tryParse(input ?? '');
    if (value != null && value >= min && value <= max) {
      return value;
    }
    print('Enter a number from $min to $max.');
  }
}

bool readYesNo(String message) {
  while (true) {
    stdout.write(message + ' (y/n): ');
    String input = (stdin.readLineSync() ?? '').trim().toLowerCase();
    if (input == 'y') return true;
    if (input == 'n') return false;
    print('Type y or n.');
  }
}

// ---------- Find helpers ----------
Patient? findPatient(int id) {
  for (Patient p in patients) {
    if (p.id == id) return p;
  }
  return null;
}

Doctor? findDoctor(int id) {
  for (Doctor d in doctors) {
    if (d.id == id) return d;
  }
  return null;
}

// Waiting tickets: emergency first, then special, then normal.
// Inside the same priority, the earlier ticket goes first.
List<Ticket> waitingQueue() {
  List<Ticket> waiting = [];
  for (Ticket t in tickets) {
    if (t.status == 'waiting') waiting.add(t);
  }
  waiting.sort((a, b) {
    if (a.priority != b.priority) return a.priority - b.priority;
    return a.number - b.number;
  });
  return waiting;
}

// ---------- Menu actions ----------
void registerPatient() {
  print('\n--- Register Patient ---');
  String name = readText('Full name: ');
  int age = readInt('Age: ', 0, 120);
  String gender = '';
  while (gender == '') {
    String g = readText('Gender (M/F): ').toUpperCase();
    if (g == 'M') gender = 'Male';
    if (g == 'F') gender = 'Female';
  }
  String phone = readText('Phone number: ');
  Patient p = Patient(nextPatientId, name, age, gender, phone);
  nextPatientId++;
  patients.add(p);
  print('Registered. Patient ID is ${p.id}.');
}

void checkIn() {
  print('\n--- Check In ---');
  if (patients.isEmpty) {
    print('No patients yet. Register one first.');
    return;
  }
  int id = readInt('Patient ID: ', 1, 100000);
  Patient? p = findPatient(id);
  if (p == null) {
    print('Patient not found.');
    return;
  }
  String complaint = readText('Main complaint: ');
  bool emergency = readYesNo('Is it an emergency?');
  bool pregnant = false;
  if (p.gender == 'Female' && p.age >= 12) {
    pregnant = readYesNo('Is the patient pregnant?');
  }

  int priority = 3;
  if (emergency) {
    priority = 1;
  } else if (p.age <= 5 || p.age >= 60 || pregnant) {
    priority = 2;
  }

  Ticket t = Ticket(nextTicketNumber, p, complaint, priority);
  nextTicketNumber++;
  tickets.add(t);
  int position = waitingQueue().indexOf(t) + 1;
  print('Ticket ${t.number} issued: ${p.name} (${t.priorityName()}).');
  print('Position in queue: $position');
}

void viewQueue() {
  print('\n--- Waiting Queue ---');
  List<Ticket> queue = waitingQueue();
  if (queue.isEmpty) {
    print('Nobody is waiting.');
    return;
  }
  for (int i = 0; i < queue.length; i++) {
    Ticket t = queue[i];
    print('${i + 1}. Ticket ${t.number} | ${t.patient.name} | ${t.priorityName()} | ${t.complaint}');
  }
}

Doctor? chooseDoctor() {
  print('\nDoctors:');
  for (Doctor d in doctors) {
    String state = d.available ? 'Available' : 'Busy';
    print('${d.id}. Dr. ${d.name} (${d.specialty}) - $state');
  }
  int id = readInt('Choose doctor number: ', 1, 100000);
  Doctor? d = findDoctor(id);
  if (d == null) print('Doctor not found.');
  return d;
}

void callNext() {
  print('\n--- Call Next Patient ---');
  Doctor? d = chooseDoctor();
  if (d == null) return;
  if (!d.available) {
    print('Dr. ${d.name} is busy. Complete the consultation first.');
    return;
  }
  List<Ticket> queue = waitingQueue();
  if (queue.isEmpty) {
    print('Nobody is waiting.');
    return;
  }
  Ticket t = queue.first;
  t.status = 'consulting';
  t.doctor = d;
  d.available = false;
  print('Now serving ticket ${t.number}: ${t.patient.name} (${t.priorityName()}).');
  print('Please go to Dr. ${d.name}.');
}

void completeConsultation() {
  print('\n--- Complete Consultation ---');
  Doctor? d = chooseDoctor();
  if (d == null) return;
  for (Ticket t in tickets) {
    if (t.status == 'consulting' && t.doctor == d) {
      t.status = 'completed';
      d.available = true;
      print('Done. Dr. ${d.name} is now available.');
      return;
    }
  }
  print('Dr. ${d.name} has no active consultation.');
}

void bookAppointment() {
  print('\n--- Book Appointment ---');
  if (patients.isEmpty) {
    print('No patients yet. Register one first.');
    return;
  }
  int id = readInt('Patient ID: ', 1, 100000);
  Patient? p = findPatient(id);
  if (p == null) {
    print('Patient not found.');
    return;
  }
  Doctor? d = chooseDoctor();
  if (d == null) return;
  String date = readText('Date (YYYY-MM-DD): ');
  String time = readText('Time (HH:MM): ');

  for (Appointment a in appointments) {
    if (a.doctor == d && a.date == date && a.time == time) {
      print('That time is already booked for Dr. ${d.name}. Choose another time.');
      return;
    }
  }
  Appointment a = Appointment(nextAppointmentId, p, d, date, time);
  nextAppointmentId++;
  appointments.add(a);
  print('Appointment ${a.id} booked: ${p.name} with Dr. ${d.name} on $date at $time.');
}

void viewAppointments() {
  print('\n--- Appointments ---');
  if (appointments.isEmpty) {
    print('No appointments booked.');
    return;
  }
  for (Appointment a in appointments) {
    print('${a.id}. ${a.patient.name} | Dr. ${a.doctor.name} | ${a.date} ${a.time}');
  }
}

void dailyReport() {
  int completed = 0;
  int consulting = 0;
  int emergencies = 0;
  for (Ticket t in tickets) {
    if (t.status == 'completed') completed++;
    if (t.status == 'consulting') consulting++;
    if (t.priority == 1) emergencies++;
  }
  print('\n===== DAILY REPORT =====');
  print('Registered patients : ${patients.length}');
  print('Tickets issued      : ${tickets.length}');
  print('Emergency cases     : $emergencies');
  print('Completed           : $completed');
  print('In consultation     : $consulting');
  print('Still waiting       : ${waitingQueue().length}');
  print('Appointments booked : ${appointments.length}');
  print('========================');
}

// ---------- Main ----------
void main() {
  doctors.add(Doctor(1, 'Aminata Conteh', 'General Medicine'));
  doctors.add(Doctor(2, 'Mohamed Sesay', 'Paediatrics'));
  doctors.add(Doctor(3, 'Fatmata Bangura', 'Maternal Health'));

  print('=====================================');
  print('  ClinicQ - Clinic Queue Management');
  print('=====================================');

  bool running = true;
  while (running) {
    print('\n1. Register patient');
    print('2. Check in patient');
    print('3. View waiting queue');
    print('4. Call next patient');
    print('5. Complete consultation');
    print('6. Book appointment');
    print('7. View appointments');
    print('8. Daily report');
    print('0. Exit');
    int choice = readInt('Choose an option: ', 0, 8);

    if (choice == 1) {
      registerPatient();
    } else if (choice == 2) {
      checkIn();
    } else if (choice == 3) {
      viewQueue();
    } else if (choice == 4) {
      callNext();
    } else if (choice == 5) {
      completeConsultation();
    } else if (choice == 6) {
      bookAppointment();
    } else if (choice == 7) {
      viewAppointments();
    } else if (choice == 8) {
      dailyReport();
    } else if (choice == 0) {
      print('Goodbye.');
      running = false;
    }
  }
}