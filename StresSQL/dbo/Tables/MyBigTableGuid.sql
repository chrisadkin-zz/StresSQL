CREATE TABLE [dbo].[MyBigTableGuid] (
    [c1] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [c2] DATETIME         NULL,
    [c3] CHAR (111)       NULL,
    [c4] INT              NULL,
    [c5] INT              NULL,
    [c6] BIGINT           NULL,
    CONSTRAINT [PK_BigTableGuid] PRIMARY KEY CLUSTERED ([c1] ASC)
);

