
CREATE PROCEDURE [dbo].[usp_LmaxPopDiskSequence] @TransactionsPerThread int = 200000
AS 
BEGIN 
    DECLARE  @MessagePopped int
            ,@Slot          int
            ,@i             int = 0;

    SET NOCOUNT ON;

	WHILE @i <= @TransactionsPerThread
	BEGIN
		EXEC dbo.usp_PopMessageDiskSequence @MessagePopped OUTPUT; 
		SET @i += 1;
	END;
END; 



