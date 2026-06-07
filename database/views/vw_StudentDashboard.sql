CREATE OR ALTER VIEW vw_StudentDashboard
AS
SELECT 
    s.StudentID,
    s.Name,
    s.Email,
    ISNULL(s.CGPA, 0) AS CGPA,
    d.DepartmentName,
    p.ProgramName,
    (SELECT COUNT(*) FROM Enrollments e WHERE e.StudentID = s.StudentID) AS TotalCourses,
    ISNULL((SELECT SUM(AmountPaid) FROM FeePayments fp WHERE fp.StudentID = s.StudentID), 0) AS TotalFeesPaid
FROM Students s
JOIN Departments d ON s.DepartmentID = d.DepartmentID
JOIN Programs p ON s.ProgramID = p.ProgramID;
GO