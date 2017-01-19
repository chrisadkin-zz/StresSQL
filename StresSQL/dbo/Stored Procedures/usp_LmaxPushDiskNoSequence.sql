
CREATE PROCEDURE [dbo].[usp_LmaxPushDiskNoSequence] 
AS 
BEGIN 
    DECLARE  @QueueSize     int = 200000
            ,@MessagePopped int
            ,@i             int = 0;

    SET NOCOUNT ON;

	WHILE @i <= @QueueSize 
	BEGIN
		EXEC dbo.usp_PushMessageDiskNoSequence @MessagePopped OUTPUT; 
		SET @i += 1;
	END;
END; 


