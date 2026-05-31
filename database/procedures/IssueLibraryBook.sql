USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE IssueLibraryBook
    @StudentID INT,
    @BookID INT,
    @IssueID INT = NULL OUTPUT
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
        
        -- Check if book exists and is available
        DECLARE @Available BIT;
        SELECT @Available = IsAvailable FROM LibraryItems WHERE BookID = @BookID;
        
        IF @Available IS NULL
        BEGIN
            RAISERROR('Book not found', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        IF @Available = 0
        BEGIN
            RAISERROR('Book is currently not available', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Check if student has overdue books
        IF EXISTS (SELECT 1 FROM LibraryIssues WHERE StudentID = @StudentID AND Status = 'Issued' AND DueDate < GETDATE())
        BEGIN
            RAISERROR('Student has overdue books. Please return them first.', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Issue the book
        INSERT INTO LibraryIssues (StudentID, BookID, IssueDate, DueDate, Status)
        VALUES (@StudentID, @BookID, GETDATE(), DATEADD(day, 14, GETDATE()), 'Issued');
        
        SET @IssueID = SCOPE_IDENTITY();
        
        -- Update book availability
        UPDATE LibraryItems SET IsAvailable = 0 WHERE BookID = @BookID;
        
        COMMIT TRANSACTION;
        
        SELECT 'Book issued successfully! Issue ID: ' + CAST(@IssueID AS VARCHAR) + '. Due date: ' + CAST(DATEADD(day, 14, GETDATE()) AS VARCHAR) AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO