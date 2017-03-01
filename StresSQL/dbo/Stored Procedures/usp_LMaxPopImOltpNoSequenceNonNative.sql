CREATE PROCEDURE [dbo].[usp_LMaxPopImOltpNoSequenceNonNative] @TransactionsPerThread int = 200000  
AS
BEGIN 
    DECLARE  @MessagePopped int = 0
	        ,@QueueSize     int = 4000000
			,@Slot          bigint
			,@i             int = 0;

	WHILE @i < @TransactionsPerThread
	BEGIN
		WHILE @MessagePopped = 0
		BEGIN
			INSERT INTO [dbo].[NonBlockingPopSequence]
				DEFAULT VALUES;

			SELECT @Slot = SCOPE_IDENTITY();
	
			DELETE FROM [dbo].[NonBlockingPopSequence] WHERE ID = @Slot;
		
			UPDATE [dbo].[MyQLmaxImOltp]
			SET     time            = GETDATE()
				   ,message         = 'Hello world'
				   ,message_id      = @Slot
				   ,reference_count = reference_count - 1
			WHERE   Slot            = @Slot % @QueueSize
			AND     reference_count = 1;

			SET @MessagePopped = @@ROWCOUNT;
		END;

	    SET @MessagePopped = 0;
		SET @i = @i + 1;
	END;
END;