CREATE TABLE [dbo].[MyQLmaxNode1] (
    [Slot]            BIGINT     NOT NULL,
    [message_id]      BIGINT     NULL,
    [time]            DATETIME   NOT NULL,
    [message]         CHAR (300) NOT NULL,
    [reference_count] TINYINT    NOT NULL
);


GO
CREATE CLUSTERED INDEX [CIX_Node1]
    ON [dbo].[MyQLmaxNode1]([Slot] ASC);

