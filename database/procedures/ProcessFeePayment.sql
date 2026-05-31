USE HiSUP_DB;
GO

CREATE OR ALTER PROCEDURE ProcessFeePayment
    @StudentID INT,
    @AmountPaid DECIMAL(10,2),
    @PaymentMethod VARCHAR(50),
    @PaymentID INT = NULL OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student not found', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        DECLARE @FeeID INT, @TotalAmount DECIMAL(10,2);
        
        SELECT TOP 1 @FeeID = FeeID, @TotalAmount = TotalAmount
        FROM FeeStructure fs
        JOIN Students s ON s.ProgramID = fs.ProgramID
        WHERE s.StudentID = @StudentID
        ORDER BY fs.Semester;
        
        IF @FeeID IS NULL
        BEGIN
            RAISERROR('Fee structure not found for this student', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        INSERT INTO FeePayments (StudentID, FeeID, AmountPaid, PaymentDate, PaymentMethod)
        VALUES (@StudentID, @FeeID, @AmountPaid, GETDATE(), @PaymentMethod);
        
        SET @PaymentID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        
        SELECT 'Payment processed successfully! Payment ID: ' + CAST(@PaymentID AS VARCHAR) AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO