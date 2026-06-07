CREATE OR ALTER VIEW vw_ExamTimetable
AS
SELECT 
    es.ExamID,
    c.CourseCode,
    c.CourseName,
    sec.SectionCode,
    es.ExamDate,
    es.StartTime,
    es.EndTime,
    es.ExamType,
    es.RoomNo
FROM ExamSchedule es
JOIN Sections sec ON es.SectionID = sec.SectionID
JOIN Courses c ON sec.CourseID = c.CourseID
WHERE es.ExamDate >= GETDATE();
GO
