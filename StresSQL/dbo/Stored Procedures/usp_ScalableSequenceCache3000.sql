CREATE PROCEDURE [dbo].[usp_ScalableSequenceCache3000] @TransactionPerThread int = 200000
AS
BEGIN 
    DECLARE  @Sequence bigint 
	        ,@i        int = 0;

	WHILE @i < @TransactionPerThread
	BEGIN
	    SELECT @Sequence = NEXT VALUE FOR [dbo].[SequenceCache3000];
		SET @i += 1;
	END;
END;
GO


