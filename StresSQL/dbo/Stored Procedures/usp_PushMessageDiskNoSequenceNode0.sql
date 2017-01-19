
CREATE PROCEDURE [dbo].[usp_PushMessageDiskNoSequenceNode0]  @MessagePushed int OUTPUT
                                                            ,@QueueSize     int = 4000000
AS
BEGIN 
    DECLARE @Slot bigint;

    SET NOCOUNT ON;

    SET @MessagePushed = 0;

	WHILE @MessagePushed = 0
	BEGIN
		EXEC usp_GetPushSlotIdNode0 @Slot;

		UPDATE [dbo].[MyQLmaxNode0]	WITH (ROWLOCK)
		SET     time            = GETDATE()
			   ,message         = 'Hello world'
			   ,message_id      = @Slot
			   ,reference_count = reference_count + 1
		WHERE   Slot            = @Slot
		AND     reference_count = 0
		OPTION  (MAXDOP 1);

		SET    @MessagePushed = @@ROWCOUNT;
	END
END;



