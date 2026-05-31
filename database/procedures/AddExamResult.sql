USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE AddExamResult
    @EnrollmentID INT,
    @MarksObtained FLOAT,
    @TotalMarks FLOAT,
    @GradeID INT = NULL OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Check if enrollment exists
        IF NOT EXISTS (SELECT 1 FROM Enrollments WHERE EnrollmentID = @EnrollmentID)
        BEGIN
            RAISERROR('Enrollment record not found', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Calculate percentage and grade
        DECLARE @Percentage FLOAT = (@MarksObtained / @TotalMarks) * 100;
        DECLARE @GradeLetter CHAR(2);
        
        SET @GradeLetter = CASE
            WHEN @Percentage >= 85 THEN 'A'
            WHEN @Percentage >= 75 THEN 'B'
            WHEN @Percentage >= 65 THEN 'C'
            WHEN @Percentage >= 50 THEN 'D'
            ELSE 'F'
        END;
        
        -- Check if grade already exists for this enrollment
        IF EXISTS (SELECT 1 FROM Grades WHERE EnrollmentID = @EnrollmentID)
        BEGIN
            -- Update existing grade
            UPDATE Grades
            SET Grade = @Percentage, GradeLetter = @GradeLetter
            WHERE EnrollmentID = @EnrollmentID;
            
            SELECT @GradeID = GradeID FROM Grades WHERE EnrollmentID = @EnrollmentID;
            SELECT 'Exam result updated successfully' AS Message;
        END
        ELSE
        BEGIN
            -- Insert new grade
            INSERT INTO Grades (EnrollmentID, Grade, GradeLetter)
            VALUES (@EnrollmentID, @Percentage, @GradeLetter);
            
            SET @GradeID = SCOPE_IDENTITY();
            SELECT 'Exam result added successfully' AS Message;
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO