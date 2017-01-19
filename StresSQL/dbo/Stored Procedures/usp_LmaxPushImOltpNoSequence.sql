CREATE PROCEDURE [dbo].[usp_LmaxPushImOltpNoSequence] @TransactionsPerThread int = 200000 
AS 
BEGIN 
    DECLARE @i int = 0;

    WHILE @i <= @TransactionsPerThread 
    BEGIN
        EXEC dbo.usp_PushMessageImOltpNoSequence;
		SET @i += 1;
    END;
END;

