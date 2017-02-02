CREATE PROCEDURE [dbo].[usp_PushMessageImOltpNoSequence]  
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC
    WITH ( TRANSACTION ISOLATION LEVEL = SNAPSHOT
          ,LANGUAGE                    = N'us_english')

    DECLARE  @MessagePushed int
	        ,@QueueSize     int = 200000
			,@Slot          bigint;

	SET @MessagePushed = 0;

	WHILE @MessagePushed = 0
	BEGIN
		INSERT INTO [dbo].[NonBlockingSequence]
			DEFAULT VALUES;

		SELECT @Slot = SCOPE_IDENTITY();
	
		DELETE FROM [dbo].[NonBlockingSequence] WHERE ID = @Slot;
		
		UPDATE [dbo].[MyQLmaxImOltp]
		SET     time            = GETDATE()
			   ,message         = 'Hello world'
			   ,message_id      = @Slot
			   ,reference_count = reference_count + 1
		WHERE   Slot            = @Slot % @QueueSize
		AND     reference_count = 0;

		SET @MessagePushed = @@ROWCOUNT;
	END;
END;