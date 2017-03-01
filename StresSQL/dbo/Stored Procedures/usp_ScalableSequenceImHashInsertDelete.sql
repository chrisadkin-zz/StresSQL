CREATE PROCEDURE [dbo].[usp_ScalableSequenceImHashInsertDelete] 
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC
WITH ( TRANSACTION ISOLATION LEVEL = SNAPSHOT
      ,LANGUAGE                    = N'us_english')

	DECLARE  @SequenceNum   BIGINT
	        ,@RolloverValue INT    = 200000;

    INSERT INTO [dbo].[NonBlockingSequenceHashIndex] DEFAULT VALUES;
	SELECT @SequenceNum = SCOPE_IDENTITY();
	DELETE FROM [dbo].[NonBlockingSequenceHashIndex] WHERE ID = @SequenceNum;
END;

