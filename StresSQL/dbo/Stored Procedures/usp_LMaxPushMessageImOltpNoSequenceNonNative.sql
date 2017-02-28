CREATE PROCEDURE [dbo].[usp_LMaxPushMessageImOltpNoSequenceNonNative] @TransactionsPerThread int = 200000 
AS
BEGIN
    DECLARE  @MessagePushed int = 0
	        ,@QueueSize     int = 4000000
			,@Slot          bigint
			,@i             int = 0;

	WHILE @i < @TransactionsPerThread
	BEGIN
		WHILE @MessagePushed = 0
		BEGIN
			INSERT INTO [dbo].[NonBlockingPushSequence]
				DEFAULT VALUES;

			SELECT @Slot = SCOPE_IDENTITY();
	
			DELETE FROM [dbo].[NonBlockingPushSequence] WHERE ID = @Slot;
		
			UPDATE [dbo].[MyQLmaxImOltp]
			SET     time            = GETDATE()
				   ,message         = 'Hello world'
				   ,message_id      = @Slot
				   ,reference_count = reference_count + 1
			WHERE   Slot            = @Slot % @QueueSize
			AND     reference_count = 0;

			SET @MessagePushed = @@ROWCOUNT;
		END;

	    SET @MessagePushed = 0;
		SET @i = @i + 1;
	END;
END;