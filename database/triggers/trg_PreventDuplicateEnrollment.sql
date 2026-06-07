CREATE OR ALTER TRIGGER trg_PreventDuplicateEnrollment
ON Enrollments
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Enrollments (StudentID, SectionID, EnrollmentDate, Status)
    SELECT i.StudentID, i.SectionID, i.EnrollmentDate, i.Status
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM Enrollments e
        WHERE e.StudentID = i.StudentID AND e.SectionID = i.SectionID
    );
    
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Duplicate enrollment prevented - student already enrolled in this section';
    END
END
GO