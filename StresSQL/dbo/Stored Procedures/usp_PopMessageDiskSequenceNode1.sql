CREATE PROCEDURE [dbo].[usp_PopMessageDiskSequenceNode1]  @MessagePopped int OUTPUT
                                                         ,@QueueSize     int = 4000000
AS
BEGIN 
    DECLARE  @Message char(300)
	        ,@Slot    bigint;

    SET NOCOUNT ON;

    SET @MessagePopped = 0;

	WHILE @MessagePopped = 0
	BEGIN
		SELECT @Slot = NEXT VALUE FOR [dbo].[PopSequenceNode1] % @QueueSize

		SET @Slot = (CASE RIGHT(@Slot, 1)
						 WHEN 1
							 THEN @Slot + 5000000000
						 WHEN 2
							 THEN @Slot + 1000000000
						 WHEN 3
							 THEN @Slot + 8000000000
						 WHEN 4
							 THEN @Slot + 2000000000
						 WHEN 5
							 THEN @Slot + 7000000000
						 WHEN 6
							 THEN @Slot + 3000000000
						 WHEN 7
							 THEN @Slot + 6000000000
						 WHEN 8
							 THEN @Slot + 4000000000
						 WHEN 9
							 THEN @Slot + 9000000000
						 ELSE
							 @Slot
					 END );					   

		UPDATE [dbo].[MyQLmaxNode1] WITH (ROWLOCK)
		SET     time            = GETDATE()
			   ,@Message        = [message]
			   ,message_id      = @Slot
			   ,reference_count = reference_count - 1
		WHERE   Slot            = @Slot
		AND     reference_count = 1
		OPTION  (MAXDOP 1);

		SET    @MessagePopped = @@ROWCOUNT;
	END
END;


