CREATE OR ALTER TRIGGER trg_AfterGradeInsert
ON Grades
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE s
    SET s.CGPA = (
        SELECT ROUND(AVG(g.Grade), 2)
        FROM Grades g
        JOIN Enrollments e ON g.EnrollmentID = e.EnrollmentID
        WHERE e.StudentID = s.StudentID
    )
    FROM Students s
    WHERE s.StudentID IN (
        SELECT DISTINCT e.StudentID
        FROM inserted i
        JOIN Enrollments e ON i.EnrollmentID = e.EnrollmentID
    );
END
GO