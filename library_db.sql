-- Library Management System
-- Author: Adeboye Adeyanju Oluwaferanmi
-- Written for MySQL (run in MySQL Workbench)

-- 1. Create the database
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- 2. Create the tables
CREATE TABLE Book (
    Book_ID          INT PRIMARY KEY,
    Title            VARCHAR(150) NOT NULL,
    Author           VARCHAR(100) NOT NULL,
    Genre            VARCHAR(50),
    Publication_Year INT
);

CREATE TABLE Member (
    Member_ID    INT PRIMARY KEY,
    Name         VARCHAR(100) NOT NULL,
    Address      VARCHAR(200),
    Email        VARCHAR(100) UNIQUE,
    Phone_Number VARCHAR(15)
);

-- Loan resolves the many-to-many relationship between Member and Book
CREATE TABLE Loan (
    Loan_ID     INT PRIMARY KEY AUTO_INCREMENT,
    Member_ID   INT NOT NULL,
    Book_ID     INT NOT NULL,
    Loan_Date   DATE NOT NULL,
    Due_Date    DATE NOT NULL,
    Return_Date DATE NULL,
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID),
    FOREIGN KEY (Book_ID)   REFERENCES Book(Book_ID)
);

-- 3. Populate the tables
INSERT INTO Book (Book_ID, Title, Author, Genre, Publication_Year) VALUES
(1, 'Things Fall Apart', 'Chinua Achebe', 'Fiction', 1958),
(2, 'Half of a Yellow Sun', 'Chimamanda Ngozi Adichie', 'Fiction', 2006),
(3, 'Purple Hibiscus', 'Chimamanda Ngozi Adichie', 'Fiction', 2003),
(4, 'Introduction to Algorithms', 'Thomas H. Cormen', 'Computer Science', 2009),
(5, 'Database System Concepts', 'Abraham Silberschatz', 'Computer Science', 2019),
(6, 'A Brief History of Time', 'Stephen Hawking', 'Science', 1988);

INSERT INTO Member (Member_ID, Name, Address, Email, Phone_Number) VALUES
(1, 'Chinedu Okafor', '12 Allen Avenue, Ikeja, Lagos', 'chinedu.okafor@email.com', '08031234567'),
(2, 'Amina Bello', '5 Ahmadu Bello Way, Abuja', 'amina.bello@email.com', '08029876543'),
(3, 'Tunde Adeyemi', '27 Ring Road, Ibadan', 'tunde.adeyemi@email.com', '08055551234'),
(4, 'Ngozi Eze', '8 Zik Avenue, Enugu', 'ngozi.eze@email.com', '07012345678'),
(5, 'Fatima Yusuf', '3 Sabon Gari Road, Kano', 'fatima.yusuf@email.com', '09087654321'),
(6, 'Ibrahim Musa', '10 Yakubu Gowon Way, Jos', 'ibrahim.musa@email.com', '08123456789');

INSERT INTO Loan (Member_ID, Book_ID, Loan_Date, Due_Date, Return_Date) VALUES
(1, 1, '2025-10-01', '2025-10-15', '2025-10-14'),
(1, 4, '2025-10-20', '2025-11-03', '2025-11-02'),
(2, 1, '2025-10-05', '2025-10-19', '2025-10-25'),
(2, 5, '2025-11-01', '2025-11-15', NULL),
(3, 2, '2025-10-10', '2025-10-24', '2025-10-23'),
(3, 4, '2025-11-05', '2025-11-19', NULL),
(4, 3, '2025-11-08', '2025-11-22', NULL),
(5, 6, '2025-10-15', '2025-10-29', '2025-10-28');

-- 4. Example SELECT queries

-- 1. Display all books
SELECT * FROM Book;

-- 2. Select specific columns with a condition and sorting (all Fiction books)
SELECT Title, Author, Publication_Year
FROM Book
WHERE Genre = 'Fiction'
ORDER BY Publication_Year;

-- 3. Display all members (selected columns)
SELECT Member_ID, Name, Email, Phone_Number
FROM Member;

-- 4. Join the three tables to show which member borrowed which book
SELECT m.Name AS Member, b.Title AS Book, l.Loan_Date, l.Due_Date, l.Return_Date
FROM Loan l
JOIN Member m ON l.Member_ID = m.Member_ID
JOIN Book b   ON l.Book_ID   = b.Book_ID
ORDER BY l.Loan_Date;

-- 5. Books that have not yet been returned (Return_Date is NULL)
SELECT m.Name AS Member, b.Title AS Book, l.Due_Date
FROM Loan l
JOIN Member m ON l.Member_ID = m.Member_ID
JOIN Book b   ON l.Book_ID   = b.Book_ID
WHERE l.Return_Date IS NULL
ORDER BY l.Due_Date;

-- 6. Number of books borrowed by each member (GROUP BY with LEFT JOIN)
SELECT m.Name, COUNT(l.Loan_ID) AS Total_Loans
FROM Member m
LEFT JOIN Loan l ON m.Member_ID = l.Member_ID
GROUP BY m.Member_ID, m.Name
ORDER BY Total_Loans DESC, m.Name;

-- 7. Books that have been borrowed by more than one member (HAVING)
SELECT b.Title, COUNT(DISTINCT l.Member_ID) AS Different_Members
FROM Book b
JOIN Loan l ON b.Book_ID = l.Book_ID
GROUP BY b.Book_ID, b.Title
HAVING COUNT(DISTINCT l.Member_ID) > 1;
