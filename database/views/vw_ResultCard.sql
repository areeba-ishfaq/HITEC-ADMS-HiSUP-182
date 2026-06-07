CREATE OR ALTER VIEW vw_ResultCard
AS
SELECT 
    s.StudentID,
    s.Name,
    c.CourseCode,
    c.CourseName,
    c.CreditHours,
    g.Grade,
    CASE 
        WHEN g.Grade >= 85 THEN 'A'
        WHEN g.Grade >= 75 THEN 'B'
        WHEN g.Grade >= 65 THEN 'C'
        WHEN g.Grade >= 50 THEN 'D'
        ELSE 'F'
    END AS GradeLetter,
    sec.Semester,
    sec.Year
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Sections sec ON e.SectionID = sec.SectionID
JOIN Courses c ON sec.CourseID = c.CourseID
LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID;
GO