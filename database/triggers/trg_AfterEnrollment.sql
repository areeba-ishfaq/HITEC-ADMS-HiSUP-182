CREATE OR ALTER TRIGGER trg_AfterEnrollment
ON Enrollments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE s
    SET s.EnrolledCount = s.EnrolledCount + 1
    FROM Sections s
    INNER JOIN inserted i ON s.SectionID = i.SectionID;
END
GO