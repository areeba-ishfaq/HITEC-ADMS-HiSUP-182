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