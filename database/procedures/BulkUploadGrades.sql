CREATE OR ALTER PROCEDURE BulkUploadGrades
    @StudentID INT,
    @CourseCode VARCHAR(20),
    @Grade DECIMAL(5,2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Create savepoint for partial rollback
        SAVE TRANSACTION GradeSavepoint;
        
        DECLARE @EnrollmentID INT;
        
        -- Validate grade range
        IF @Grade < 0 OR @Grade > 100
        BEGIN
            SELECT 'Error: Grade must be between 0 and 100' AS Message;
            ROLLBACK TRANSACTION GradeSavepoint;
            COMMIT TRANSACTION;
            RETURN;
        END
        
        -- Get EnrollmentID for the student and course
        SELECT @EnrollmentID = e.EnrollmentID
        FROM Enrollments e
        JOIN Sections sec ON e.SectionID = sec.SectionID
        JOIN Courses c ON sec.CourseID = c.CourseID
        WHERE e.StudentID = @StudentID AND c.CourseCode = @CourseCode;
        
        -- Check if student is enrolled
        IF @EnrollmentID IS NULL
        BEGIN
            SELECT 'Error: Student not enrolled in this course' AS Message;
            ROLLBACK TRANSACTION GradeSavepoint;
            COMMIT TRANSACTION;
            RETURN;
        END
        
        -- Insert or update the grade
        IF EXISTS (SELECT 1 FROM Grades WHERE EnrollmentID = @EnrollmentID)
        BEGIN
            UPDATE Grades SET Grade = @Grade WHERE EnrollmentID = @EnrollmentID;
            SELECT 'Success: Grade updated' AS Message;
        END
        ELSE
        BEGIN
            INSERT INTO Grades (EnrollmentID, Grade) VALUES (@EnrollmentID, @Grade);
            SELECT 'Success: Grade inserted' AS Message;
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        SELECT 'Error: ' + ERROR_MESSAGE() AS Message;
    END CATCH
END
GO