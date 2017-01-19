CREATE PROCEDURE [dbo].[usp_PushMessageDiskInitV1]
AS
BEGIN 
    DECLARE  @1billion  bigint = 1000000000
	        ,@2billion  bigint = 2000000000
	        ,@3billion  bigint = 3000000000
	        ,@4billion  bigint = 4000000000
	        ,@5billion  bigint = 5000000000
	        ,@6billion  bigint = 6000000000
	        ,@7billion  bigint = 7000000000
	        ,@8billion  bigint = 8000000000
	        ,@9billion  bigint = 9000000000
            ,@QueueSize int    = 4000000           
	        ,@Slot      bigint
			,@i         int    = 0

    SET NOCOUNT ON;

    DELETE FROM [dbo].[MyQLmax];

	WHILE @i < @QueueSize
	BEGIN
		SELECT @Slot = NEXT VALUE FOR [dbo].[PushSequence] % @QueueSize

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
	END
END;
