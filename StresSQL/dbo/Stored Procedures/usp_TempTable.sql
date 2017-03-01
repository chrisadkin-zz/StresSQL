CREATE PROCEDURE [dbo].[usp_TempTable] @TransactionsPerThread int = 200000
AS
BEGIN
    DECLARE @i int = 0

	WHILE @i < @TransactionsPerThread
	BEGIN
	    IF OBJECT_ID('temp..#t') IS NOT NULL
		BEGIN
		    DROP TABLE #t;
		END;

	    CREATE TABLE #t  (
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
		);
    
	    CREATE NONCLUSTERED INDEX ix ON #t(object_id);

        INSERT #t
        SELECT *
	    FROM   sys.all_objects;

        SET @i += 1;
	END;
END;
GO


