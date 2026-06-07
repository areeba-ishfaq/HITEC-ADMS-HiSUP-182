CREATE OR ALTER TRIGGER trg_AfterFeePayment
ON FeePayments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE s
    SET s.OutstandingBalance = ISNULL(s.OutstandingBalance, 0) - i.AmountPaid
    FROM Students s
    INNER JOIN inserted i ON s.StudentID = i.StudentID;
END
GO