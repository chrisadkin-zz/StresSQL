
CREATE PROCEDURE [dbo].[usp_LmaxPushDiskSequence] @TransactionsPerThread int = 200000
AS 
BEGIN 
    DECLARE  @MessagePushed int
            ,@Slot          int
            ,@i             int = 0;

    SET NOCOUNT ON;

	WHILE @i <= @TransactionsPerThread 
	BEGIN
		EXEC dbo.usp_PushMessageDiskSequence @MessagePushed OUTPUT; 
		SET @i += 1;
	END;
END; 



