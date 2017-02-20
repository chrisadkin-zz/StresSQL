CREATE PROCEDURE [dbo].[usp_LmaxPopImOltpNoSequence] @TransactionsPerThread int = 200000 
AS 
BEGIN 
    DECLARE @i int = 0;

    WHILE @i <= @TransactionsPerThread 
    BEGIN
        EXEC dbo.usp_PopMessageImOltpNoSequence;
		SET @i += 1;
    END;
END;
