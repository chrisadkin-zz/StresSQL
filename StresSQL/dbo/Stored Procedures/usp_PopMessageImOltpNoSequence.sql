CREATE PROCEDURE [dbo].[usp_PopMessageImOltpNoSequence]  
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC
    WITH ( TRANSACTION ISOLATION LEVEL = SNAPSHOT
          ,LANGUAGE                    = N'us_english')

    DECLARE  @MessagePopped int
	        ,@QueueSize     int = 4000000
			,@Slot          bigint;

	SET @MessagePopped = 0;

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
END;