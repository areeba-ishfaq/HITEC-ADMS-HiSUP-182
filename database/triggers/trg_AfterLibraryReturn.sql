CREATE OR ALTER TRIGGER trg_AfterLibraryReturn
ON LibraryIssues
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE li
    SET li.IsAvailable = 1,
        li.AvailableCopies = li.AvailableCopies + 1
    FROM LibraryItems li
    INNER JOIN inserted i ON li.BookID = i.BookID
    INNER JOIN deleted d ON i.IssueID = d.IssueID
    WHERE d.Status = 'Issued' AND i.Status = 'Returned';
END
GO