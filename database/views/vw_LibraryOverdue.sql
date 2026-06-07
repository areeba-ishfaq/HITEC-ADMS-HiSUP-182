CREATE OR ALTER VIEW vw_LibraryOverdue
AS
SELECT 
    li.IssueID,
    s.StudentID,
    s.Name,
    s.Email,
    lb.Title AS BookTitle,
    li.IssueDate,
    li.DueDate,
    DATEDIFF(day, li.DueDate, GETDATE()) AS DaysOverdue,
    DATEDIFF(day, li.DueDate, GETDATE()) * 50 AS FineAmount
FROM LibraryIssues li
JOIN Students s ON li.StudentID = s.StudentID
JOIN LibraryItems lb ON li.BookID = lb.BookID
WHERE li.Status = 'Issued' AND li.DueDate < GETDATE();
GO