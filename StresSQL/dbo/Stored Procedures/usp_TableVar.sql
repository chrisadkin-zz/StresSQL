CREATE PROCEDURE [dbo].[usp_TableVar] @TransactionsPerThread int = 200000
AS
BEGIN
    DECLARE @i int = 0

    DECLARE @t TABLE  (
	     [name]                [sysname]      NOT NULL
	    ,[object_id]           [int]          NOT NULL
	    ,[principal_id]        [int]          NULL
	    ,[schema_id]           [int]          NOT NULL
	    ,[parent_object_id]    [int]          NOT NULL
	    ,[type]                [char](2)      NULL
	    ,[type_desc]           [nvarchar](60) NULL
	    ,[create_date]         [datetime]     NOT NULL
	    ,[modify_date]         [datetime]     NOT NULL
	    ,[is_ms_shipped]       [bit]          NULL
  	    ,[is_published]        [bit]          NULL
	    ,[is_schema_published] [bit]          NULL
         INDEX ix NONCLUSTERED (object_id)
     );

	WHILE @i < @TransactionsPerThread
	BEGIN
        INSERT @t
        SELECT *
	    FROM   sys.all_objects;
		
		DELETE FROM @t;

        SET @i += 1;
	END;
END;
GO


