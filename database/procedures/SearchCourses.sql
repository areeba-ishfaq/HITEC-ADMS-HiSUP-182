CREATE OR ALTER PROCEDURE SearchCourses
    @SearchTerm VARCHAR(100),
    @DepartmentID INT = NULL,
    @MinCreditHours INT = NULL,
    @MaxCreditHours INT = NULL
AS
BEGIN
    BEGIN TRY
        SELECT 
            c.CourseID,
            c.CourseCode,
            c.CourseName,
            c.CreditHours,
            d.DepartmentName,
            COUNT(sec.SectionID) AS TotalSections,
            ISNULL(SUM(sec.EnrolledCount), 0) AS TotalEnrollments
        FROM Courses c
        JOIN Departments d ON c.DepartmentID = d.DepartmentID
        LEFT JOIN Sections sec ON c.CourseID = sec.CourseID
        WHERE (c.CourseCode LIKE '%' + @SearchTerm + '%'
            OR c.CourseName LIKE '%' + @SearchTerm + '%')
            AND (@DepartmentID IS NULL OR c.DepartmentID = @DepartmentID)
            AND (@MinCreditHours IS NULL OR c.CreditHours >= @MinCreditHours)
            AND (@MaxCreditHours IS NULL OR c.CreditHours <= @MaxCreditHours)
        GROUP BY c.CourseID, c.CourseCode, c.CourseName, c.CreditHours, d.DepartmentName
        ORDER BY c.CourseCode;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO