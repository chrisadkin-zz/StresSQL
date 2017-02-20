CREATE TABLE [dbo].[MyQLmaxImOltpNoLog]
(
	[Slot] [bigint] IDENTITY(1,1) NOT NULL,
	[message_id] [bigint] NULL,
	[time] [datetime] NOT NULL,
	[message] [char](300) COLLATE Latin1_General_CI_AS NOT NULL,
	[reference_count] [tinyint] NOT NULL,

 PRIMARY KEY NONCLUSTERED HASH 
(
	[Slot]
) WITH ( BUCKET_COUNT = 4194304)
) WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_ONLY )