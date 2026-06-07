CREATE OR ALTER VIEW vw_FacultyCourseLoad
AS
SELECT 
    f.FacultyID,
    f.Name AS FacultyName,
    d.DepartmentName,
    (SELECT COUNT(*) FROM Sections sec WHERE sec.FacultyID = f.FacultyID) AS TotalSections,
    ISNULL((SELECT SUM(c.CreditHours) FROM Sections sec JOIN Courses c ON sec.CourseID = c.CourseID WHERE sec.FacultyID = f.FacultyID), 0) AS TotalCreditHours
FROM Faculty f
JOIN Departments d ON f.DepartmentID = d.DepartmentID;
GO