﻿CREATE TABLE [dbo].[NonBlockingPushSequence] (
    [ID] BIGINT IDENTITY (1, 1) NOT NULL,
    PRIMARY KEY NONCLUSTERED HASH ([ID]) WITH (BUCKET_COUNT = 524288)
)
WITH (DURABILITY = SCHEMA_ONLY, MEMORY_OPTIMIZED = ON);
