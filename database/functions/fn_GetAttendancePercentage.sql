CREATE OR ALTER FUNCTION fn_GetAttendancePercentage (@StudentID INT, @CourseID INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Percentage DECIMAL(5,2);
    
    SELECT @Percentage = ROUND(100.0 * 
        SUM(CASE WHEN ar.Status = 'Present' THEN 1 ELSE 0 END) / 
        COUNT(*), 2)
    FROM AttendanceRecords ar
    JOIN Sections sec ON ar.SectionID = sec.SectionID
    WHERE ar.StudentID = @StudentID AND sec.CourseID = @CourseID;
    
    RETURN ISNULL(@Percentage, 0);
END
GO