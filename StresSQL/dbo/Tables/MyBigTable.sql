CREATE TABLE [dbo].[MyBigTable] (
    [c1] BIGINT     NOT NULL,
    [c2] DATETIME   CONSTRAINT [DF_BigTable_c2] DEFAULT (getdate()) NULL,
    [c3] CHAR (111) CONSTRAINT [DF_BigTable_c3] DEFAULT ('a') NULL,
    [c4] INT        CONSTRAINT [DF_BigTable_c4] DEFAULT ((1)) NULL,
    [c5] INT        CONSTRAINT [DF_BigTable_c5] DEFAULT ((2)) NULL,
    [c6] BIGINT     CONSTRAINT [DF_BigTable_c6] DEFAULT ((42)) NULL,
    CONSTRAINT [PK_BigTable] PRIMARY KEY CLUSTERED ([c1] ASC)
);

