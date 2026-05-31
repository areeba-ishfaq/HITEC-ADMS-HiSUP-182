USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE GetStudentReport
    @StudentID INT
AS
BEGIN
    BEGIN TRY
        -- Check if student exists
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student not found', 16, 1);
            RETURN;
        END
        
        -- Student Information
        SELECT 
            s.StudentID,
            s.Name,
            s.Email,
            s.Phone,
            s.EnrollmentDate,
            s.Status,
            d.DepartmentName,
            p.ProgramName
        FROM Students s
        JOIN Departments d ON s.DepartmentID = d.DepartmentID
        JOIN Programs p ON s.ProgramID = p.ProgramID
        WHERE s.StudentID = @StudentID;
        
        -- Fee Summary
        SELECT 
            SUM(fp.AmountPaid) AS TotalFeesPaid,
            COUNT(fp.PaymentID) AS NumberOfPayments
        FROM FeePayments fp
        WHERE fp.StudentID = @StudentID;
        
        -- Attendance Summary
        SELECT 
            COUNT(CASE WHEN ar.Status = 'Present' THEN 1 END) AS PresentDays,
            COUNT(CASE WHEN ar.Status = 'Absent' THEN 1 END) AS AbsentDays,
            COUNT(CASE WHEN ar.Status = 'Late' THEN 1 END) AS LateDays,
            COUNT(*) AS TotalDays,
            CAST(ROUND(100.0 * COUNT(CASE WHEN ar.Status = 'Present' THEN 1 END) / COUNT(*), 2) AS DECIMAL(5,2)) AS AttendancePercentage
        FROM AttendanceRecords ar
        WHERE ar.StudentID = @StudentID;
        
        -- Library Books Currently Issued
        SELECT 
            li.IssueID,
            li.BookID,
            li.IssueDate,
            li.DueDate
        FROM LibraryIssues li
        WHERE li.StudentID = @StudentID AND li.Status = 'Issued';
        
        -- Academic Summary (Enrolled Courses)
        SELECT 
            c.CourseCode,
            c.CourseName,
            sec.Semester,
            sec.Year,
            g.Grade,
            g.GradeLetter
        FROM Students s
        JOIN Enrollments e ON s.StudentID = e.StudentID
        JOIN Sections sec ON e.SectionID = sec.SectionID
        JOIN Courses c ON sec.CourseID = c.CourseID
        LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID
        WHERE s.StudentID = @StudentID
        ORDER BY sec.Year DESC, sec.Semester, c.CourseCode;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO