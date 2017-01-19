CREATE PROCEDURE [dbo].[usp_PushMessageDiskNoSequence]  @MessagePushed int OUTPUT
                                                       ,@QueueSize     int = 4000000
AS
BEGIN 
    DECLARE  @Message  char(300)
	        ,@Slot     bigint;

    SET NOCOUNT ON;

    SET @MessagePushed = 0;

	WHILE @MessagePushed = 0
	BEGIN
	    EXEC dbo.usp_GetPushSlotId @Slot OUTPUT;

		UPDATE  [dbo].[MyQLmax] WITH (ROWLOCK)
		SET      time            = GETDATE()
			    ,@Message        = [message]
			    ,message_id      = @Slot
			    ,reference_count = reference_count + 1
		WHERE   Slot            = @Slot
		AND     reference_count = 0
		OPTION  (MAXDOP 1);

		SET @MessagePushed = @@ROWCOUNT;
	END
END;


