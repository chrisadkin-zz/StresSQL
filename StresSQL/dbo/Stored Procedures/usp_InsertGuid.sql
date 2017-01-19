

CREATE PROCEDURE [dbo].[usp_InsertGuid]
     @TransactionsPerThread int = 250000
    ,@CommitBatchSize       int = 2
 AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
 
    DECLARE  @i INTEGER = 0
	        ,@j INTEGER = 0;
 
    WHILE @i < @TransactionsPerThread
    BEGIN
        BEGIN TRANSACTION
			WHILE @j < @CommitBatchSize
			BEGIN
				INSERT INTO dbo.MyBigTableGuid DEFAULT VALUES;
				SET @j += 1;
			END;
        COMMIT;
		
		SET @j = 0;
        SET @i += 1;
    END;
END;










