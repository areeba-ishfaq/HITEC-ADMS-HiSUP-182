CREATE OR ALTER FUNCTION fn_IsLibraryItemAvailable (@BookID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @Available BIT;
    
    SELECT @Available = IsAvailable
    FROM LibraryItems
    WHERE BookID = @BookID;
    
    RETURN ISNULL(@Available, 0);
END
GO