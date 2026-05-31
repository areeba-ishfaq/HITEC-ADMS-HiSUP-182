USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE GenerateTranscript
    @StudentID INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student not found', 16, 1);
            RETURN;
        END
        
        -- Student Info
        SELECT 
            s.StudentID,
            s.Name,
            s.Email,
            s.EnrollmentDate,
            d.DepartmentName,
            p.ProgramName,
            ROUND(AVG(CAST(g.Grade AS DECIMAL(3,2))), 2) AS CGPA,
            SUM(c.CreditHours) AS TotalCredits
        FROM Students s
        JOIN Departments d ON s.DepartmentID = d.DepartmentID
        JOIN Programs p ON s.ProgramID = p.ProgramID
        LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
        LEFT JOIN Sections sec ON e.SectionID = sec.SectionID
        LEFT JOIN Courses c ON sec.CourseID = c.CourseID
        LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID
        WHERE s.StudentID = @StudentID
        GROUP BY s.StudentID, s.Name, s.Email, s.EnrollmentDate, d.DepartmentName, p.ProgramName;
        
        -- Course Grades
        SELECT 
            c.CourseCode,
            c.CourseName,
            c.CreditHours,
            sec.Semester,
            sec.Year,
            g.Grade,
            CASE 
                WHEN g.Grade >= 85 THEN 'A'
                WHEN g.Grade >= 75 THEN 'B'
                WHEN g.Grade >= 65 THEN 'C'
                WHEN g.Grade >= 50 THEN 'D'
                ELSE 'F'
            END AS LetterGrade
        FROM Students s
        JOIN Enrollments e ON s.StudentID = e.StudentID
        JOIN Sections sec ON e.SectionID = sec.SectionID
        JOIN Courses c ON sec.CourseID = c.CourseID
        LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID
        WHERE s.StudentID = @StudentID AND e.Status = 'Enrolled'
        ORDER BY sec.Year, sec.Semester, c.CourseCode;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO