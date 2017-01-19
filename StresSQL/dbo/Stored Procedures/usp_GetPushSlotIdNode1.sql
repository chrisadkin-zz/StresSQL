

CREATE PROCEDURE [dbo].[usp_GetPushSlotIdNode1]  @Slot      bigint OUTPUT
                                                ,@QueueSize int = 4000000
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC
WITH ( TRANSACTION ISOLATION LEVEL = SNAPSHOT
      ,LANGUAGE                    = N'us_english')
    INSERT INTO dbo.NonBlockingPushSequenceNode1
        DEFAULT VALUES;

    SELECT @Slot = SCOPE_IDENTITY();

	DELETE FROM dbo.NonBlockingPushSequenceNode1
	WHERE ID = @Slot;

	SET @Slot = @Slot % @QueueSize;

	IF @Slot % 10 = 1
	BEGIN
		SET @Slot += 5000000000;
	END
	ELSE IF @Slot % 10 = 2
    BEGIN	
	    SET @Slot += 1000000000;
	END
	ELSE IF @Slot % 10 = 3
    BEGIN	
	    SET @Slot += 8000000000;
	END
	ELSE IF @Slot % 10 = 4
    BEGIN	
	    SET @Slot += 2000000000;
	END
	ELSE IF @Slot % 10 = 5
    BEGIN	
	    SET @Slot += 7000000000;
	END
	ELSE IF @Slot % 10 = 6
    BEGIN	
	    SET @Slot += 3000000000;
	END
	ELSE IF @Slot % 10 = 7
    BEGIN	
	    SET @Slot += 6000000000;
	END
	ELSE IF @Slot % 10 = 8
    BEGIN	
	    SET @Slot += 4000000000;
	END
	ELSE IF @Slot % 10 = 9
    BEGIN	
	    SET @Slot += 1000000000;
	END;
END;


