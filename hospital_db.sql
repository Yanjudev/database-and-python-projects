-- Hospital Database System
-- Author: Adeboye Adeyanju Oluwaferanmi
-- Written for MySQL (run in MySQL Workbench)

-- 1. Create the database
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- 2. Create the tables
CREATE TABLE Patient (
    Patient_ID INT PRIMARY KEY,
    Name       VARCHAR(100) NOT NULL,
    Age        INT CHECK (Age >= 0),
    Gender     VARCHAR(10) CHECK (Gender IN ('Male', 'Female')),
    Address    VARCHAR(200)
);

CREATE TABLE Doctor (
    Doctor_ID    INT PRIMARY KEY,
    Name         VARCHAR(100) NOT NULL,
    Specialty    VARCHAR(100),
    Phone_Number VARCHAR(15)
);

-- Appointment resolves the many-to-many relationship between Doctor and Patient
CREATE TABLE Appointment (
    Appointment_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID       INT NOT NULL,
    Doctor_ID        INT NOT NULL,
    Appointment_Date DATE NOT NULL,
    Reason           VARCHAR(200),
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Doctor_ID)  REFERENCES Doctor(Doctor_ID)
);

-- Each treatment is given during an appointment (so it is tied to a patient and a doctor)
CREATE TABLE Treatment (
    Treatment_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Appointment_ID INT NOT NULL,
    Treatment_Name VARCHAR(100) NOT NULL,
    Treatment_Cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID)
);

-- 3. Populate the tables
INSERT INTO Patient (Patient_ID, Name, Age, Gender, Address) VALUES
(1, 'Emeka Nwosu', 34, 'Male', '14 Herbert Macaulay Way, Yaba, Lagos'),
(2, 'Aisha Mohammed', 27, 'Female', '9 Murtala Muhammed Road, Kano'),
(3, 'Bola Ajayi', 45, 'Female', '22 Adeola Odeku Street, Victoria Island, Lagos'),
(4, 'Samuel Okon', 8, 'Male', '5 Aka Road, Uyo'),
(5, 'Grace Eze', 61, 'Female', '31 Independence Layout, Enugu');

INSERT INTO Doctor (Doctor_ID, Name, Specialty, Phone_Number) VALUES
(1, 'Dr. Ifeanyi Obi', 'Cardiology', '08011112222'),
(2, 'Dr. Halima Sani', 'Paediatrics', '08033334444'),
(3, 'Dr. Kunle Balogun', 'General Medicine', '08055556666'),
(4, 'Dr. Ada Okeke', 'Orthopaedics', '08077778888');

INSERT INTO Appointment (Patient_ID, Doctor_ID, Appointment_Date, Reason) VALUES
(1, 1, '2025-11-03', 'Chest pain and palpitations'),
(2, 3, '2025-11-04', 'Persistent fever and headache'),
(3, 1, '2025-11-05', 'High blood pressure check-up'),
(4, 2, '2025-11-06', 'Routine immunisation'),
(5, 4, '2025-11-07', 'Knee joint pain'),
(1, 3, '2025-11-10', 'Follow-up consultation'),
(3, 3, '2025-11-12', 'Malaria symptoms'),
(5, 1, '2025-11-14', 'Heart rhythm monitoring');

INSERT INTO Treatment (Appointment_ID, Treatment_Name, Treatment_Cost) VALUES
(1, 'ECG Test', 15000.00),
(2, 'Malaria Treatment', 8500.00),
(3, 'Blood Pressure Medication', 12000.00),
(4, 'Measles Vaccination', 5000.00),
(5, 'Physiotherapy Session', 20000.00),
(7, 'Malaria Treatment', 8500.00),
(8, 'Holter Monitoring', 25000.00);

-- 4. Example SELECT queries

-- 1. Display all patients
SELECT * FROM Patient;

-- 2. Display all doctors
SELECT Doctor_ID, Name, Specialty FROM Doctor;

-- 3. Join tables to list every appointment with the patient and doctor involved
SELECT a.Appointment_ID, p.Name AS Patient, d.Name AS Doctor,
       a.Appointment_Date, a.Reason
FROM Appointment a
JOIN Patient p ON a.Patient_ID = p.Patient_ID
JOIN Doctor d  ON a.Doctor_ID  = d.Doctor_ID
ORDER BY a.Appointment_Date;

-- 4. Appointments for a particular doctor (WHERE condition)
SELECT p.Name AS Patient, a.Appointment_Date, a.Reason
FROM Appointment a
JOIN Patient p ON a.Patient_ID = p.Patient_ID
JOIN Doctor d  ON a.Doctor_ID  = d.Doctor_ID
WHERE d.Name = 'Dr. Ifeanyi Obi'
ORDER BY a.Appointment_Date;

-- 5. Treatments given to each patient with their cost
SELECT p.Name AS Patient, t.Treatment_Name, t.Treatment_Cost, a.Appointment_Date
FROM Treatment t
JOIN Appointment a ON t.Appointment_ID = a.Appointment_ID
JOIN Patient p     ON a.Patient_ID     = p.Patient_ID
ORDER BY p.Name, a.Appointment_Date;

-- 6. Total treatment cost per patient (SUM with GROUP BY)
SELECT p.Name AS Patient, SUM(t.Treatment_Cost) AS Total_Cost
FROM Patient p
JOIN Appointment a ON p.Patient_ID     = a.Patient_ID
JOIN Treatment t   ON a.Appointment_ID = t.Appointment_ID
GROUP BY p.Patient_ID, p.Name
ORDER BY Total_Cost DESC;

-- 7. Number of different patients attended by each doctor
SELECT d.Name AS Doctor, d.Specialty, COUNT(DISTINCT a.Patient_ID) AS Patients_Attended
FROM Doctor d
LEFT JOIN Appointment a ON d.Doctor_ID = a.Doctor_ID
GROUP BY d.Doctor_ID, d.Name, d.Specialty
ORDER BY Patients_Attended DESC, d.Name;
