CREATE PROCEDURE [dbo].[usp_LMaxImOltpQSlotInit]  
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC
    WITH ( TRANSACTION ISOLATION LEVEL = SNAPSHOT
          ,LANGUAGE                    = N'us_english')

    DECLARE  @QueueSize int = 4000000
	        ,@i         int = 0;

	WHILE @i < @QueueSize
	BEGIN
		INSERT INTO [dbo].[MyQLmaxImOltp]
			   ([Slot]
			   ,[message_id]
			   ,[time]
			   ,[message]
			   ,[reference_count])
		 VALUES
			   (@i
			   ,0
			   ,GETDATE()
			   ,''
			   ,0);
		SET @i += 1;
	END;
END;
