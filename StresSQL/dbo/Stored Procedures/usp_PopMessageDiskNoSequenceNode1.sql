CREATE PROCEDURE [dbo].[usp_PopMessageDiskNoSequenceNode1]  @MessagePopped int OUTPUT
                                                           ,@QueueSize     int = 4000000
AS
BEGIN 
    DECLARE  @Message  char(300)
	        ,@Slot     bigint;

    SET NOCOUNT ON;

    SET @MessagePopped = 0;

	WHILE @MessagePopped = 0
	BEGIN
	    EXEC [dbo].[usp_GetPopSlotIdNode1] @Slot;

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


