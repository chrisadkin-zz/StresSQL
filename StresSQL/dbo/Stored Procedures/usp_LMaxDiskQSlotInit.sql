
CREATE PROCEDURE [dbo].[usp_LMaxDiskQSlotInit]  
AS
BEGIN 
    DECLARE  @QueueSize int = 4000000
	        ,@Slot      bigint
	        ,@i         int = 0;

	SET NOCOUNT ON;

	TRUNCATE TABLE [dbo].[MyQLmax];
	TRUNCATE TABLE [dbo].[MyQLmaxNode0];
	TRUNCATE TABLE [dbo].[MyQLmaxNode1];

	WHILE @i < @QueueSize
	BEGIN
		SET @Slot = (CASE RIGHT(@i, 1)
						 WHEN 1
							 THEN @i + 5000000000
						 WHEN 2
							 THEN @i + 1000000000
						 WHEN 3
							 THEN @i + 8000000000
						 WHEN 4
							 THEN @i + 2000000000
						 WHEN 5
							 THEN @i + 7000000000
						 WHEN 6
							 THEN @i + 3000000000
						 WHEN 7
							 THEN @i + 6000000000
						 WHEN 8
							 THEN @i + 4000000000
						 WHEN 9
							 THEN @i + 9000000000
						 ELSE
							 @i
					 END );			

		INSERT INTO [dbo].[MyQLmax]
			   ([Slot]
			   ,[message_id]
			   ,[time]
			   ,[message]
			   ,[reference_count])
		 VALUES
			   (@Slot
			   ,0
			   ,GETDATE()
			   ,''
			   ,0);
		SET @i += 1;
	END;

	INSERT INTO [dbo].[MyQLmaxNode0]
			([Slot]
			,[message_id]
			,[time]
			,[message]
			,[reference_count])
	SELECT   [Slot]
			,[message_id]
			,[time]
			,[message]
			,[reference_count]
	FROM     [dbo].[MyQLmax];

	INSERT INTO [dbo].[MyQLmaxNode1]
			([Slot]
			,[message_id]
			,[time]
			,[message]
			,[reference_count])
	SELECT   [Slot]
			,[message_id]
			,[time]
			,[message]
			,[reference_count]
	FROM     [dbo].[MyQLmax];
END;
