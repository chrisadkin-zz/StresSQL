
CREATE PROCEDURE [dbo].[usp_InsertBitReverse]
     @TransactionsPerThread int = 500000
    ,@CommitBatchSize       int = 2
 AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
 
    DECLARE   @i      INTEGER = 0
	         ,@j      INTEGER = 0
             ,@base   BIGINT  = @@SPID * @TransactionsPerThread
			 ,@PartId INTEGER;
 
    WHILE @i < @TransactionsPerThread
    BEGIN
        BEGIN TRANSACTION
		    WHILE @j < @CommitBatchSize
			BEGIN		 
				INSERT INTO dbo.MyBigTable (c1)
				VALUES  (dbo.BitReverse(@base + @i)); 
				SET @j += 1;
			END;
        COMMIT;

		set @j = 0;
        SET @i += 1;
    END;
END;









