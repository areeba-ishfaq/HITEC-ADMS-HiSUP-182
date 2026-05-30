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