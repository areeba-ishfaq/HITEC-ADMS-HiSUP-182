USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE EnrollInCourse
    @StudentID INT,
    @SectionID INT,
    @EnrollmentID INT = NULL OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Check if student exists
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student not found', 16, 1);
            RETURN;
        END
        
        -- Check if section exists and has capacity
        DECLARE @CurrentEnrolled INT, @Capacity INT;
        
        SELECT @CurrentEnrolled = EnrolledCount, @Capacity = Capacity
        FROM Sections WHERE SectionID = @SectionID;
        
        IF @CurrentEnrolled IS NULL
        BEGIN
            RAISERROR('Section not found', 16, 1);
            RETURN;
        END
        
        IF @CurrentEnrolled >= @Capacity
        BEGIN
            RAISERROR('Section is full', 16, 1);
            RETURN;
        END
        
        -- Check if already enrolled
        IF EXISTS (SELECT 1 FROM Enrollments WHERE StudentID = @StudentID AND SectionID = @SectionID)
        BEGIN
            RAISERROR('Student already enrolled in this section', 16, 1);
            RETURN;
        END
        
        -- Insert enrollment
        INSERT INTO Enrollments (StudentID, SectionID, EnrollmentDate, Status)
        VALUES (@StudentID, @SectionID, GETDATE(), 'Enrolled');
        
        SET @EnrollmentID = SCOPE_IDENTITY();
        
        -- Update section enrolled count
        UPDATE Sections SET EnrolledCount = EnrolledCount + 1
        WHERE SectionID = @SectionID;
        
        SELECT 'Enrollment successful' AS Message;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

-- Check if sections exist
SELECT * FROM Sections;

-- If no sections, create one
INSERT INTO Sections (CourseID, FacultyID, SectionCode, Semester, Year, Capacity, EnrolledCount)
VALUES (101, 500, 'A', 'Fall', 2024, 50, 0);
GO

-- Test enrollment
DECLARE @EnrollID INT;
EXEC EnrollInCourse 
    @StudentID = 1002,
    @SectionID = 1,
    @EnrollmentID = @EnrollID OUTPUT;
PRINT 'Enrollment ID: ' + ISNULL(CAST(@EnrollID AS VARCHAR), 'NULL');
GO

-- Verify
SELECT * FROM Enrollments;
SELECT * FROM Sections;
GO