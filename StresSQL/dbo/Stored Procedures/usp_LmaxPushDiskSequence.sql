
CREATE PROCEDURE [dbo].[usp_LmaxPushDiskSequence] 
AS 
BEGIN 
    DECLARE  @QueueSize     int = 200000
            ,@MessagePushed int
            ,@Slot          int
            ,@i             int = 0;

    SET NOCOUNT ON;

	WHILE @i <= @QueueSize 
	BEGIN
		EXEC dbo.usp_PushMessageDiskSequence @MessagePushed OUTPUT; 
		SET @i += 1;
	END;
END; 



