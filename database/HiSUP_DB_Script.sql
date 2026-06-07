CREATE DATABASE HiSUP_DB;
GO
USE HiSUP_DB;
GO
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(100),
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO
INSERT INTO Departments (DepartmentName, Location) VALUES 
('Computer Science', 'Block A'),
('Business Administration', 'Block B');
GO
SELECT * FROM Departments;
GO
USE HiSUP_DB;
GO
CREATE TABLE Programs (
    ProgramID INT IDENTITY(1,1) PRIMARY KEY,
    ProgramCode VARCHAR(20) NOT NULL UNIQUE,
    ProgramName VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    DurationYears INT DEFAULT 4,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO
CREATE TABLE Students (
    StudentID INT IDENTITY(1000,1) PRIMARY KEY,
    CNIC VARCHAR(15) NOT NULL UNIQUE,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    BankAccount VARCHAR(30),
    Gender VARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Other')),
    DepartmentID INT NOT NULL,
    ProgramID INT NOT NULL,
    EnrollmentDate DATE NOT NULL,
    Status VARCHAR(20) DEFAULT 'Active',
    CGPA DECIMAL(5,2) DEFAULT 0,              -- ← ADD THIS
    OutstandingBalance DECIMAL(12,2) DEFAULT 0, -- ← ADD THIS
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID)
);
GO
CREATE TABLE Faculty (
    FacultyID INT IDENTITY(500,1) PRIMARY KEY,
    CNIC VARCHAR(15) NOT NULL UNIQUE,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    HireDate DATE NOT NULL,
    DepartmentID INT NOT NULL,
    Designation VARCHAR(50),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO
CREATE TABLE Courses (
    CourseID INT IDENTITY(100,1) PRIMARY KEY,
    CourseCode VARCHAR(20) NOT NULL UNIQUE,
    CourseName VARCHAR(100) NOT NULL,
    CreditHours INT NOT NULL CHECK (CreditHours IN (1,2,3,4)),
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO
CREATE TABLE Sections (
    SectionID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL,
    FacultyID INT NOT NULL,
    SectionCode VARCHAR(10) NOT NULL,
    Semester VARCHAR(20) NOT NULL,
    Year INT NOT NULL,
    Capacity INT NOT NULL DEFAULT 50,
    EnrolledCount INT NOT NULL DEFAULT 0,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID)
);
GO
CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    SectionID INT NOT NULL,
    EnrollmentDate DATE NOT NULL,
    Status VARCHAR(20) DEFAULT 'Enrolled',
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID),
    CONSTRAINT UQ_Student_Section UNIQUE (StudentID, SectionID)
);
GO
CREATE TABLE FeeStructure (
    FeeID INT IDENTITY(1,1) PRIMARY KEY,
    ProgramID INT NOT NULL,
    Semester INT NOT NULL,
    TuitionFee DECIMAL(10,2) NOT NULL,
    AdmissionFee DECIMAL(10,2),
    LibraryFee DECIMAL(10,2),
    SportsFee DECIMAL(10,2),
    TotalAmount AS (TuitionFee + ISNULL(AdmissionFee,0) + ISNULL(LibraryFee,0) + ISNULL(SportsFee,0)),
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID)
);
GO
CREATE TABLE FeePayments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    FeeID INT NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    PaymentMethod VARCHAR(50),
    TransactionID VARCHAR(100),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (FeeID) REFERENCES FeeStructure(FeeID)
);
GO
CREATE TABLE Grades (
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentID INT NOT NULL,
    Grade FLOAT NOT NULL CHECK (Grade >= 0 AND Grade <= 100),
    GradeLetter CHAR(2),
    Remarks VARCHAR(200),
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID),
    CONSTRAINT UQ_Enrollment_Grade UNIQUE (EnrollmentID)
);
GO
CREATE TABLE LibraryItems (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    ISBN VARCHAR(50) UNIQUE,
    Category VARCHAR(50),
    IsAvailable BIT DEFAULT 1,
    AvailableCopies INT DEFAULT 1
);
GO
CREATE TABLE LibraryIssues (
    IssueID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    BookID INT NOT NULL,
    IssueDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE NULL,
    Status VARCHAR(20) DEFAULT 'Issued',
    FineAmount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (BookID) REFERENCES LibraryItems(BookID)
);
GO
INSERT INTO Programs (ProgramCode, ProgramName, DepartmentID, DurationYears) VALUES
('BSCS', 'Bachelor of Science in Computer Science', 1, 4),
('BSAI', 'Bachelor of Science in Artificial Intelligence', 1, 4),
('BBA', 'Bachelor of Business Administration', 2, 4);
GO
INSERT INTO Students (CNIC, Name, Email, Phone, BankAccount, DepartmentID, ProgramID, EnrollmentDate, Status)
VALUES 
('35201-1234567-8', 'Ahmed Raza', 'ahmed.raza@student.hitecuni.edu.pk', '03001234567', 'PK76HBL0123456', 1, 1, '2024-09-01', 'Active'),
('35201-2345678-9', 'Fatima Akhtar', 'fatima.akhtar@student.hitecuni.edu.pk', '03002345678', 'PK76UBL1234567', 1, 2, '2024-09-01', 'Active'),
('35201-3456789-0', 'Hamza Khan', 'hamza.khan@student.hitecuni.edu.pk', '03003456789', 'PK76MCB2345678', 2, 3, '2024-09-01', 'Active');
GO
INSERT INTO Faculty (CNIC, Name, Email, HireDate, DepartmentID, Designation) VALUES
('11111-1111111-1', 'Dr. Ahmed Khan', 'ahmed@university.edu', '2020-08-15', 1, 'Professor'),
('22222-2222222-2', 'Dr. Sara Ali', 'sara@university.edu', '2021-01-10', 1, 'Associate Professor');
GO
INSERT INTO Courses (CourseCode, CourseName, CreditHours, DepartmentID) VALUES
('CS101', 'Programming Fundamentals', 3, 1),
('CS102', 'Database Systems', 3, 1),
('CS103', 'Data Structures', 3, 1);
GO
INSERT INTO Grades (EnrollmentID, Grade, GradeLetter)
SELECT e.EnrollmentID, 85.0, 'A'
FROM Enrollments e
WHERE e.StudentID = 1002;
GO
INSERT INTO LibraryItems (Title, Author, ISBN, Category, IsAvailable, AvailableCopies)
VALUES 
('Database Systems', 'C.J. Date', '978-0321197849', 'Textbook', 1, 3),
('Programming in C#', 'Jeffrey Richter', '978-0735667457', 'Programming', 1, 2),
('Introduction to Algorithms', 'Thomas Cormen', '978-0262033848', 'Textbook', 1, 1);
GO
SELECT COUNT(*) AS DepartmentsCount FROM Departments;
SELECT COUNT(*) AS ProgramsCount FROM Programs;
SELECT COUNT(*) AS StudentsCount FROM Students;
SELECT COUNT(*) AS FacultyCount FROM Faculty;
SELECT COUNT(*) AS CoursesCount FROM Courses;
SELECT COUNT(*) AS SectionsCount FROM Sections;
SELECT COUNT(*) AS EnrollmentsCount FROM Enrollments;
GO
USE HiSUP_DB;
GO

USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE RegisterStudent
    @Name VARCHAR(100),
    @CNIC VARCHAR(15),
    @Email VARCHAR(100),
    @Phone VARCHAR(20),
    @DepartmentID INT,
    @ProgramID INT,
    @StudentID INT = NULL OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Check if email exists
        IF EXISTS (SELECT 1 FROM Students WHERE Email = @Email)
        BEGIN
            RAISERROR('Email already exists', 16, 1);
            RETURN;
        END
        
        -- Check if CNIC exists
        IF EXISTS (SELECT 1 FROM Students WHERE CNIC = @CNIC)
        BEGIN
            RAISERROR('CNIC already registered', 16, 1);
            RETURN;
        END
        
        -- Insert student
        INSERT INTO Students (Name, CNIC, Email, Phone, DepartmentID, ProgramID, EnrollmentDate, Status)
        VALUES (@Name, @CNIC, @Email, @Phone, @DepartmentID, @ProgramID, GETDATE(), 'Active');
        
        SET @StudentID = SCOPE_IDENTITY();
        
        SELECT 'Student registered successfully' AS Message;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

DECLARE @NewID INT;
EXEC RegisterStudent 
    @Name = 'Test Student',
    @CNIC = '99999-9999999-9',
    @Email = 'teststudent@university.edu',
    @Phone = '03009999999',
    @DepartmentID = 1,
    @ProgramID = 1,
    @StudentID = @NewID OUTPUT;
PRINT 'New Student ID: ' + CAST(@NewID AS VARCHAR);
GO

SELECT * FROM Students WHERE Email = 'teststudent@university.edu';
GO