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
			   ([message_id]
			   ,[time]
			   ,[message]
			   ,[reference_count])
		 VALUES
			   (0
			   ,GETDATE()
			   ,''
			   ,0);
		INSERT INTO [dbo].[MyQLmaxImOltpNoLog]
			   ([message_id]
			   ,[time]
			   ,[message]
			   ,[reference_count])
		 VALUES
			   (0
			   ,GETDATE()
			   ,''
			   ,0);
		INSERT INTO [dbo].[MyQLmaxImOltpTemporal]
			   ([message_id]
			   ,[time]
			   ,[message]
			   ,[reference_count])
		 VALUES
			   (0
			   ,GETDATE()
			   ,''
			   ,0);
		SET @i += 1;
	END;
END;
