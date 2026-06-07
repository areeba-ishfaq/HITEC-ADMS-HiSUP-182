CREATE OR ALTER FUNCTION fn_CalculateCGPA (@StudentID INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @CGPA DECIMAL(5,2);
    
    SELECT @CGPA = ROUND(AVG(g.Grade), 2)
    FROM Students s
    JOIN Enrollments e ON s.StudentID = e.StudentID
    JOIN Grades g ON e.EnrollmentID = g.EnrollmentID
    WHERE s.StudentID = @StudentID AND g.Grade IS NOT NULL;
    
    RETURN ISNULL(@CGPA, 0);
END
GO