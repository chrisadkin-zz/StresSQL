CREATE TABLE [dbo].[MyQLmaxNode0] (
    [Slot]            BIGINT     NOT NULL,
    [message_id]      BIGINT     NULL,
    [time]            DATETIME   NOT NULL,
    [message]         CHAR (300) NOT NULL,
    [reference_count] TINYINT    NOT NULL
);


GO
CREATE CLUSTERED INDEX [CIX_Node0]
    ON [dbo].[MyQLmaxNode0]([Slot] ASC);

