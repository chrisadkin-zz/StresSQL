
CREATE PROCEDURE [dbo].[usp_LmaxPushDiskNoSequence] @TransactionsPerThread int = 200000
AS 
BEGIN 
    DECLARE  @MessagePopped int
            ,@i             int = 0;

    SET NOCOUNT ON;

	WHILE @i <= @TransactionsPerThread 
	BEGIN
		EXEC dbo.usp_PushMessageDiskNoSequence @MessagePopped OUTPUT; 
		SET @i += 1;
	END;
END; 


