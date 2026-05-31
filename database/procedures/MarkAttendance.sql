USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE MarkAttendance
    @StudentID INT,
    @SectionID INT,
    @AttendanceDate DATE,
    @Status VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        -- Check if student exists
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student not found', 16, 1);
            RETURN;
        END
        
        -- Check if section exists
        IF NOT EXISTS (SELECT 1 FROM Sections WHERE SectionID = @SectionID)
        BEGIN
            RAISERROR('Section not found', 16, 1);
            RETURN;
        END
        
        -- Check if student is enrolled in this section
        IF NOT EXISTS (SELECT 1 FROM Enrollments WHERE StudentID = @StudentID AND SectionID = @SectionID)
        BEGIN
            RAISERROR('Student is not enrolled in this section', 16, 1);
            RETURN;
        END
        
        -- Insert or update attendance
        IF EXISTS (SELECT 1 FROM AttendanceRecords WHERE StudentID = @StudentID AND SectionID = @SectionID AND AttendanceDate = @AttendanceDate)
        BEGIN
            UPDATE AttendanceRecords
            SET Status = @Status
            WHERE StudentID = @StudentID AND SectionID = @SectionID AND AttendanceDate = @AttendanceDate;
            SELECT 'Attendance updated successfully' AS Message;
        END
        ELSE
        BEGIN
            INSERT INTO AttendanceRecords (StudentID, SectionID, AttendanceDate, Status)
            VALUES (@StudentID, @SectionID, @AttendanceDate, @Status);
            SELECT 'Attendance marked successfully' AS Message;
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO