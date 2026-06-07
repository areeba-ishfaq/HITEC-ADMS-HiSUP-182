CREATE OR ALTER PROCEDURE GenerateFeeSlip
    @StudentID INT,
    @Semester INT = NULL
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            RAISERROR('Student not found', 16, 1);
            RETURN;
        END
        
        -- Student Info
        SELECT 
            s.StudentID,
            s.Name,
            s.Email,
            d.DepartmentName,
            p.ProgramName
        FROM Students s
        JOIN Departments d ON s.DepartmentID = d.DepartmentID
        JOIN Programs p ON s.ProgramID = p.ProgramID
        WHERE s.StudentID = @StudentID;
        
        -- Fee Structure
        SELECT 
            fs.Semester,
            fs.TuitionFee,
            fs.AdmissionFee,
            fs.LibraryFee,
            fs.SportsFee,
            fs.TotalAmount
        FROM FeeStructure fs
        WHERE fs.ProgramID = (SELECT ProgramID FROM Students WHERE StudentID = @StudentID)
        ORDER BY fs.Semester;
        
        -- Payment History
        SELECT 
            fp.PaymentID,
            fp.AmountPaid,
            fp.PaymentDate,
            fp.PaymentMethod
        FROM FeePayments fp
        WHERE fp.StudentID = @StudentID
        ORDER BY fp.PaymentDate DESC;
        
        -- Outstanding Balance
        SELECT 
            SUM(fs.TotalAmount) AS TotalFee,
            ISNULL(SUM(fp.AmountPaid), 0) AS TotalPaid,
            SUM(fs.TotalAmount) - ISNULL(SUM(fp.AmountPaid), 0) AS OutstandingBalance
        FROM FeeStructure fs
        LEFT JOIN FeePayments fp ON fs.FeeID = fp.FeeID AND fp.StudentID = @StudentID
        WHERE fs.ProgramID = (SELECT ProgramID FROM Students WHERE StudentID = @StudentID);
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO