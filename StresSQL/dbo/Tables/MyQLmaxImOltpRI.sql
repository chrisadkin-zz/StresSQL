CREATE TABLE [dbo].[MyQLmaxImOltpRI] (
    [Slot]            BIGINT     IDENTITY (1, 1) NOT NULL,
    [message_id]      BIGINT     NULL,
    [time]            DATETIME   NOT NULL,
    [message]         CHAR (300) NOT NULL,
    [reference_count] TINYINT    NOT NULL,
    PRIMARY KEY NONCLUSTERED ([Slot] ASC)
)
WITH (MEMORY_OPTIMIZED = ON);

