CREATE OR ALTER VIEW vw_DepartmentEnrollmentSummary
AS
SELECT 
    d.DepartmentID,
    d.DepartmentName,
    (SELECT COUNT(*) FROM Students s WHERE s.DepartmentID = d.DepartmentID) AS TotalStudents,
    (SELECT COUNT(*) FROM Programs p WHERE p.DepartmentID = d.DepartmentID) AS TotalPrograms,
    (SELECT COUNT(*) FROM Courses c WHERE c.DepartmentID = d.DepartmentID) AS TotalCourses
FROM Departments d;
GO