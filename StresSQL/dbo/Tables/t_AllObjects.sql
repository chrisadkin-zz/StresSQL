CREATE TYPE [dbo].[t_AllObjects] AS TABLE (
	[name] [sysname] COLLATE Latin1_General_CI_AS NOT NULL,
	[object_id] [int] NOT NULL,
	[principal_id] [int] NULL,
	[schema_id] [int] NOT NULL,
	[parent_object_id] [int] NOT NULL,
	[type] [char](2) COLLATE Latin1_General_CI_AS NULL,
	[type_desc] [nvarchar](60) COLLATE Latin1_General_CI_AS NULL,
	[create_date] [datetime] NOT NULL,
	[modify_date] [datetime] NOT NULL,
	[is_ms_shipped] [bit] NULL,
	[is_published] [bit] NULL,
	[is_schema_published] [bit] NULL,
	INDEX [ix] NONCLUSTERED 
(
	[object_id] ASC
)
)
WITH ( MEMORY_OPTIMIZED = ON )
GO


