USE HiSUP_DB;
GO
CREATE OR ALTER PROCEDURE CalculateSemesterGPA
    @StudentID INT,
    @Semester VARCHAR(20),
    @Year INT,
    @GPA FLOAT = NULL OUTPUT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student not found', 16, 1);
            RETURN;
        END
        
        SELECT @GPA = ROUND(AVG(g.Grade), 2)
        FROM Students s
        JOIN Enrollments e ON s.StudentID = e.StudentID
        JOIN Sections sec ON e.SectionID = sec.SectionID
        JOIN Grades g ON e.EnrollmentID = g.EnrollmentID
        WHERE s.StudentID = @StudentID 
          AND sec.Semester = @Semester 
          AND sec.Year = @Year
          AND g.Grade IS NOT NULL;
        
        IF @GPA IS NULL
        BEGIN
            SET @GPA = 0;
            SELECT 'No grades found for this semester' AS Message;
            RETURN;
        END
        
        SELECT 'Semester GPA calculated: ' + CAST(ROUND(@GPA, 2) AS VARCHAR) AS Message;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO
DECLARE @GPA FLOAT;
EXEC CalculateSemesterGPA @StudentID = 1002, @Semester = 'Fall', @Year = 2024, @GPA = @GPA OUTPUT;
PRINT 'GPA: ' + CAST(ROUND(@GPA, 2) AS VARCHAR);
GO
