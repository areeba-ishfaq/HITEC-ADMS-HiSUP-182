CREATE OR ALTER FUNCTION fn_GetLetterGrade (@MarksPercentage FLOAT)
RETURNS CHAR(2)
AS
BEGIN
    DECLARE @LetterGrade CHAR(2);
    
    SET @LetterGrade = CASE
        WHEN @MarksPercentage >= 85 THEN 'A'
        WHEN @MarksPercentage >= 75 THEN 'B'
        WHEN @MarksPercentage >= 65 THEN 'C'
        WHEN @MarksPercentage >= 50 THEN 'D'
        ELSE 'F'
    END;
    
    RETURN @LetterGrade;
END
GO