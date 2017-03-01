CREATE PROCEDURE [dbo].[usp_TableVarImOltp] @TransactionsPerThread int = 200000
AS
BEGIN
    DECLARE @i int = 0

    DECLARE @t t_AllObjects;

	SET NOCOUNT ON;

	WHILE @i < @TransactionsPerThread
	BEGIN
        INSERT @t
        SELECT *
	    FROM   sys.all_objects;
		
		DELETE FROM @t;

        SET @i += 1;
	END;
END;
GO


