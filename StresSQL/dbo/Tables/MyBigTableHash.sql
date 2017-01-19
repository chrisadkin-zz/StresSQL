CREATE TABLE [dbo].[MyBigTableHash] (
    [PartId] BIGINT           NOT NULL,
    [c1]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [c2]     DATETIME         NULL,
    [c3]     CHAR (111)       NULL,
    [c4]     INT              NULL,
    [c5]     INT              NULL,
    [c6]     BIGINT           NULL,
    CONSTRAINT [PK_BigTableHash] PRIMARY KEY CLUSTERED ([PartId] ASC, [c1] ASC) ON [HashPartition_SC] ([PartId])
);

