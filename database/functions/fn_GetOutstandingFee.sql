CREATE OR ALTER FUNCTION fn_GetOutstandingFee (@StudentID INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @Outstanding DECIMAL(12,2);
    
    SELECT @Outstanding = SUM(fs.TotalAmount) - ISNULL(SUM(fp.AmountPaid), 0)
    FROM FeeStructure fs
    LEFT JOIN FeePayments fp ON fs.FeeID = fp.FeeID AND fp.StudentID = @StudentID
    WHERE fs.ProgramID = (SELECT ProgramID FROM Students WHERE StudentID = @StudentID);
    
    RETURN ISNULL(@Outstanding, 0);
END
GO