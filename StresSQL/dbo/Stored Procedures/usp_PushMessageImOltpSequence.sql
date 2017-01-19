

CREATE PROCEDURE [dbo].[usp_PushMessageImOltpSequence] @Slot int, @MessagePushed int OUTPUT
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC
WITH ( TRANSACTION ISOLATION LEVEL = SNAPSHOT
      ,LANGUAGE                    = N'us_english')

    UPDATE [dbo].[MyQLmaxImOltp]
	SET     [message]         = 'Hello world'
	       ,[reference_count] = 1
	WHERE  Slot               = @Slot
	AND    reference_count    = 0;

	SET @MessagePushed = @@ROWCOUNT;
END;
