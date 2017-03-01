CREATE PROCEDURE [dbo].[usp_ScalableSequenceImHashUpdateSelect] 
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC
WITH ( TRANSACTION ISOLATION LEVEL = SNAPSHOT
      ,LANGUAGE                    = N'us_english')

	DECLARE  @SequenceNum   BIGINT
	        ,@RolloverValue INT    = 200000;

    UPDATE [dbo].[NonBlockingSequenceHashIndex] 
	SET    Val = Val + 1
	SELECT @SequenceNum = Val % @RolloverValue
	FROM   [dbo].[NonBlockingSequenceHashIndex];
END;

