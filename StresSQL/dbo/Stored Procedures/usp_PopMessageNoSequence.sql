
CREATE PROCEDURE [dbo].[usp_PopMessageNoSequence] @MessagePopped int OUTPUT
AS
BEGIN 
    DECLARE  @QueueSize int    = 4000000
	        ,@Message   char(300)
	        ,@Slot      bigint;

	SET @MessagePopped = 0;

	WHILE @MessagePopped = 0
	BEGIN
		EXEC [dbo].[usp_GetPopSlotId] @Slot OUTPUT, @QueueSize;

		UPDATE  q               WITH (ROWLOCK)
		SET     time            = GETDATE()
			   ,@Message        = message
			   ,reference_count = reference_count - 1
		FROM    [dbo].[MyQLmax] AS q 
		WHERE   Slot            = @Slot
		AND     reference_count = 1
		OPTION (MAXDOP 1);

		SET    @MessagePopped   = @@ROWCOUNT;
	END;
END;





