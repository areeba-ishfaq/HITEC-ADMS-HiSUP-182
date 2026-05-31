USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE GetFacultyWorkload
    @FacultyID INT
AS
BEGIN
    BEGIN TRY
        -- Check if faculty exists
        IF NOT EXISTS (SELECT 1 FROM Faculty WHERE FacultyID = @FacultyID)
        BEGIN
            RAISERROR('Faculty not found', 16, 1);
            RETURN;
        END
        
        -- Faculty Information
        SELECT 
            f.FacultyID,
            f.Name,
            f.Email,
            f.Designation,
            d.DepartmentName,
            f.HireDate
        FROM Faculty f
        JOIN Departments d ON f.DepartmentID = d.DepartmentID
        WHERE f.FacultyID = @FacultyID;
        
        -- Current Semester Teaching Load
        SELECT 
            c.CourseCode,
            c.CourseName,
            c.CreditHours,
            sec.SectionCode,
            sec.Semester,
            sec.Year,
            sec.EnrolledCount,
            sec.Capacity,
            CAST(ROUND(100.0 * sec.EnrolledCount / sec.Capacity, 2) AS DECIMAL(5,2)) AS FillPercentage
        FROM Faculty f
        JOIN Sections sec ON f.FacultyID = sec.FacultyID
        JOIN Courses c ON sec.CourseID = c.CourseID
        WHERE f.FacultyID = @FacultyID
        ORDER BY sec.Year DESC, sec.Semester, c.CourseCode;
        
        -- Workload Summary
        SELECT 
            COUNT(sec.SectionID) AS TotalSections,
            SUM(c.CreditHours) AS TotalCreditHours,
            AVG(sec.EnrolledCount) AS AverageClassSize
        FROM Faculty f
        JOIN Sections sec ON f.FacultyID = sec.FacultyID
        JOIN Courses c ON sec.CourseID = c.CourseID
        WHERE f.FacultyID = @FacultyID;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO