CREATE OR ALTER VIEW vw_AttendanceShortfall
AS
SELECT 
    s.StudentID,
    s.Name,
    c.CourseCode,
    c.CourseName,
    (SELECT COUNT(*) FROM AttendanceRecords ar WHERE ar.StudentID = s.StudentID AND ar.SectionID = sec.SectionID AND ar.Status = 'Present') AS PresentDays,
    (SELECT COUNT(*) FROM AttendanceRecords ar WHERE ar.StudentID = s.StudentID AND ar.SectionID = sec.SectionID) AS TotalDays
FROM Students s
JOIN AttendanceRecords ar ON s.StudentID = ar.StudentID
JOIN Sections sec ON ar.SectionID = sec.SectionID
JOIN Courses c ON sec.CourseID = c.CourseID
GROUP BY s.StudentID, s.Name, c.CourseCode, c.CourseName, sec.SectionID;
GO