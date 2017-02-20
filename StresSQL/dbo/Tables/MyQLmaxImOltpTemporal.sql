CREATE TABLE [dbo].[MyQLmaxImOltpTemporal] (
    [Slot]            BIGINT     IDENTITY (1, 1) NOT NULL,
    [message_id]      BIGINT     NULL,
    [time]            DATETIME   NOT NULL,
    [message]         CHAR (300) NOT NULL,
    [reference_count] TINYINT    NOT NULL,
	[SysStartTime]    DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,  
    [SysEndTime]      DATETIME2 GENERATED ALWAYS AS ROW END   NOT NULL, 
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime),     
    PRIMARY KEY NONCLUSTERED HASH ([Slot]) WITH (BUCKET_COUNT = 4194304)
)
WITH (MEMORY_OPTIMIZED = ON, SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[MyQLmaxImOltpTemporalHist]));

