CREATE OR ALTER VIEW vw_FeeDefaulters
AS
SELECT 
    s.StudentID,
    s.Name,
    s.Email,
    d.DepartmentName,
    p.ProgramName,
    ISNULL((SELECT SUM(AmountPaid) FROM FeePayments fp WHERE fp.StudentID = s.StudentID), 0) AS TotalPaid,
    fs.TotalAmount AS ExpectedFee,
    fs.TotalAmount - ISNULL((SELECT SUM(AmountPaid) FROM FeePayments fp WHERE fp.StudentID = s.StudentID), 0) AS OutstandingAmount
FROM Students s
JOIN Departments d ON s.DepartmentID = d.DepartmentID
JOIN Programs p ON s.ProgramID = p.ProgramID
JOIN FeeStructure fs ON p.ProgramID = fs.ProgramID
WHERE fs.TotalAmount - ISNULL((SELECT SUM(AmountPaid) FROM FeePayments fp WHERE fp.StudentID = s.StudentID), 0) > 0;
GO