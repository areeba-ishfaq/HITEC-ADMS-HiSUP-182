USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE GetDepartmentEnrollment
    @DepartmentID INT,
    @Year INT = NULL
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = @DepartmentID)
        BEGIN
            RAISERROR('Department not found', 16, 1);
            RETURN;
        END
        
        IF @Year IS NULL
            SET @Year = YEAR(GETDATE());
        
        -- Department Information
        SELECT DepartmentID, DepartmentName, Location
        FROM Departments WHERE DepartmentID = @DepartmentID;
        
        -- Enrollment by Program
        SELECT 
            p.ProgramName,
            COUNT(DISTINCT s.StudentID) AS TotalStudents,
            COUNT(DISTINCT e.EnrollmentID) AS TotalEnrollments
        FROM Departments d
        JOIN Programs p ON d.DepartmentID = p.DepartmentID
        LEFT JOIN Students s ON p.ProgramID = s.ProgramID
        LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
        WHERE d.DepartmentID = @DepartmentID
        GROUP BY p.ProgramName
        ORDER BY TotalStudents DESC;
        
        -- Enrollment by Semester
        SELECT 
            sec.Semester,
            sec.Year,
            COUNT(DISTINCT e.EnrollmentID) AS EnrollmentsCount,
            COUNT(DISTINCT e.StudentID) AS UniqueStudents
        FROM Departments d
        JOIN Courses c ON d.DepartmentID = c.DepartmentID
        JOIN Sections sec ON c.CourseID = sec.CourseID
        LEFT JOIN Enrollments e ON sec.SectionID = e.SectionID
        WHERE d.DepartmentID = @DepartmentID AND sec.Year = @Year
        GROUP BY sec.Semester, sec.Year
        ORDER BY sec.Year, 
            CASE sec.Semester
                WHEN 'Spring' THEN 1
                WHEN 'Summer' THEN 2
                WHEN 'Fall' THEN 3
                ELSE 4
            END;
        
        -- Gender Distribution (Now works because Gender column exists!)
        SELECT 
            s.Gender,
            COUNT(*) AS Count,
            CAST(ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS DECIMAL(5,2)) AS Percentage
        FROM Departments d
        JOIN Students s ON d.DepartmentID = s.DepartmentID
        WHERE d.DepartmentID = @DepartmentID
        GROUP BY s.Gender;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO