USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE AllocateHostelRoom
    @StudentID INT,
    @HostelID INT,
    @RoomNumber VARCHAR(10),
    @AllocationID INT = NULL OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Check if student exists
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student not found', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Check if hostel exists
        IF NOT EXISTS (SELECT 1 FROM Hostels WHERE HostelID = @HostelID)
        BEGIN
            RAISERROR('Hostel not found', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Check if student already has an active allocation
        IF EXISTS (SELECT 1 FROM HostelAllotments WHERE StudentID = @StudentID AND Status = 'Active')
        BEGIN
            RAISERROR('Student already has an active hostel allocation', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Check if room is available
        IF EXISTS (SELECT 1 FROM HostelAllotments WHERE HostelID = @HostelID AND RoomNumber = @RoomNumber AND Status = 'Active')
        BEGIN
            RAISERROR('Room is already occupied', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Insert allocation
        INSERT INTO HostelAllotments (StudentID, HostelID, RoomNumber, AllotmentDate, Status)
        VALUES (@StudentID, @HostelID, @RoomNumber, GETDATE(), 'Active');
        
        SET @AllocationID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        
        SELECT 'Hostel room allocated successfully! Allocation ID: ' + CAST(@AllocationID AS VARCHAR) AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO