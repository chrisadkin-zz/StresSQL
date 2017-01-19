
CREATE PROCEDURE [dbo].[usp_InsertSpid]
     @TransactionsPerThread int = 500000
    ,@CommitBatchSize       int = 2
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
 
    DECLARE   @i      INTEGER = 0
	         ,@j      INTEGER = 0
             ,@base   BIGINT  = @@SPID * 10000000000;
 
    WHILE @i < @TransactionsPerThread
    BEGIN
        BEGIN TRANSACTION
		    WHILE @j < @CommitBatchSize
			BEGIN
				INSERT INTO dbo.MyBigTable (c1)
				VALUES  (@base + @i); 
				SET @j += 1;
			END;
        COMMIT;

		SET @j = 0;
        SET @i += 1;
    END;
END;









