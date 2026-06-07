CREATE OR ALTER TRIGGER trg_AuditStudentUpdate
ON Students
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO AuditLog (TableName, Action, OldValue, NewValue, UserName, TimeStamp)
    SELECT 
        'Students',
        CASE WHEN d.StudentID IS NOT NULL AND i.StudentID IS NOT NULL THEN 'UPDATE' ELSE 'DELETE' END,
        CONCAT('ID:', ISNULL(d.StudentID,0), '|Name:', ISNULL(d.Name,''), '|Email:', ISNULL(d.Email,'')),
        CONCAT('ID:', ISNULL(i.StudentID,0), '|Name:', ISNULL(i.Name,''), '|Email:', ISNULL(i.Email,'')),
        SYSTEM_USER,
        GETDATE()
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.StudentID = d.StudentID;
END
GO