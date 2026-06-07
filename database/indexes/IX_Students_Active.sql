CREATE NONCLUSTERED INDEX IX_Students_Active
ON Students (Status)
WHERE Status = 'Active';
GO