USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE ReturnLibraryBook
    @IssueID INT,
    @FineAmount DECIMAL(10,2) = 0 OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Check if issue exists and is still issued
        DECLARE @StudentID INT, @BookID INT, @IssueDate DATE, @DueDate DATE, @Status VARCHAR(20);
        
        SELECT @StudentID = StudentID, @BookID = BookID, @IssueDate = IssueDate, @DueDate = DueDate, @Status = Status
        FROM LibraryIssues
        WHERE IssueID = @IssueID;
        
        IF @Status IS NULL
        BEGIN
            RAISERROR('Issue record not found', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        IF @Status = 'Returned'
        BEGIN
            RAISERROR('Book already returned', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Calculate fine if overdue
        IF GETDATE() > @DueDate
        BEGIN
            DECLARE @DaysOverdue INT = DATEDIFF(day, @DueDate, GETDATE());
            SET @FineAmount = @DaysOverdue * 50; -- Rs. 50 per day fine
        END
        ELSE
        BEGIN
            SET @FineAmount = 0;
        END
        
        -- Update the issue record
        UPDATE LibraryIssues
        SET ReturnDate = GETDATE(), Status = 'Returned', FineAmount = @FineAmount
        WHERE IssueID = @IssueID;
        
        -- Make book available again
        UPDATE LibraryItems
        SET IsAvailable = 1
        WHERE BookID = @BookID;
        
        COMMIT TRANSACTION;
        
        IF @FineAmount > 0
            SELECT 'Book returned successfully! Fine amount: Rs. ' + CAST(@FineAmount AS VARCHAR) AS Message;
        ELSE
            SELECT 'Book returned successfully! No fine.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO