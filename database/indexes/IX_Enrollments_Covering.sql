CREATE NONCLUSTERED INDEX IX_Enrollments_Covering
ON Enrollments (StudentID)
INCLUDE (SectionID, EnrollmentDate, Status);
GO