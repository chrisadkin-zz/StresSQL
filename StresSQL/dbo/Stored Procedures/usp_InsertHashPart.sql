


CREATE PROCEDURE [dbo].[usp_InsertHashPart]
     @TransactionsPerThread int = 500000
    ,@CommitBatchSize       int = 2
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
 
    DECLARE  @i           INTEGER = 0
	        ,@j           INTEGER = 0 
	        ,@PartitionId BIGINT;
 
    WHILE @i < @TransactionsPerThread
    BEGIN
	    SET @PartitionId = ( ( CAST(RAND() * 1000000 AS bigint ) ) % 40 ) + 1;

        BEGIN TRANSACTION
		    WHILE @j < @CommitBatchSize
			BEGIN
				INSERT INTO dbo.MyBigTableHash( PartId ) VALUES ( @PartitionId );
				SET @j += 1;
			END
		COMMIT;

		SET @j = 0;
        SET @i += 1;
    END;
END;











