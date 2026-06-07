CREATE NONCLUSTERED INDEX IX_Enrollments_Student_Course
ON Enrollments (StudentID, SectionID);
GO