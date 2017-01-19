CREATE PROCEDURE [dbo].[usp_LmaxPushImOltpSequence] @TransactionsPerThread int = 200000
AS 
BEGIN 
    DECLARE  @QueueSize     INT = 4000000
	        ,@MessagePushed INT
            ,@Slot          INT
	        ,@i             INT = 0;

    WHILE @i <= @TransactionsPerThread 
    BEGIN
	    SET @MessagePushed = 0;

		WHILE @MessagePushed = 0
		BEGIN
	        SELECT @Slot = NEXT VALUE FOR [dbo].[PushSequence] % @QueueSize
            EXEC dbo.usp_PushMessageImOltpSequence @Slot, @MessagePushed OUTPUT;
		END;

		SET @i += 1;
    END;
END;
GO