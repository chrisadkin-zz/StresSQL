﻿CREATE TABLE [dbo].[StresSQLStats] (
    [Test]                  VARCHAR (256)   NOT NULL,
    [Threads]               INT             NOT NULL,
    [StartTime]             DATETIME        NULL,
    [EndTime]               DATETIME        NULL,
    [TransactionRate]       BIGINT          NULL,
    [WaitType_1]            NVARCHAR (60)   NULL,
    [Wait_S_1]              DECIMAL (16, 2) NULL,
    [WaitCount_1]           BIGINT          NULL,
    [Percentage_1]          DECIMAL (5, 2)  NULL,
    [AvgWait_S_1]           DECIMAL (16, 4) NULL,
    [WaitType_2]            NVARCHAR (60)   NULL,
    [Wait_S_2]              DECIMAL (16, 2) NULL,
    [WaitCount_2]           BIGINT          NULL,
    [Percentage_2]          DECIMAL (5, 2)  NULL,
    [AvgWait_S_2]           DECIMAL (16, 4) NULL,
    [WaitType_3]            NVARCHAR (60)   NULL,
    [Wait_S_3]              DECIMAL (16, 2) NULL,
    [WaitCount_3]           BIGINT          NULL,
    [Percentage_3]          DECIMAL (5, 2)  NULL,
    [AvgWait_S_3]           DECIMAL (16, 4) NULL,
    [WaitType_4]            NVARCHAR (60)   NULL,
    [Wait_S_4]              DECIMAL (16, 2) NULL,
    [WaitCount_4]           BIGINT          NULL,
    [Percentage_4]          DECIMAL (5, 2)  NULL,
    [AvgWait_S_4]           DECIMAL (16, 4) NULL,
    [WaitType_5]            NVARCHAR (60)   NULL,
    [Wait_S_5]              DECIMAL (16, 2) NULL,
    [WaitCount_5]           BIGINT          NULL,
    [Percentage_5]          DECIMAL (5, 2)  NULL,
    [AvgWait_S_5]           DECIMAL (16, 4) NULL,
    [latch_class_1]         VARCHAR (60)    NULL,
    [wait_time_ms_1]        BIGINT          NULL,
    [latch_class_2]         VARCHAR (60)    NULL,
    [wait_time_ms_2]        BIGINT          NULL,
    [latch_class_3]         VARCHAR (60)    NULL,
    [wait_time_ms_3]        BIGINT          NULL,
    [latch_class_4]         VARCHAR (60)    NULL,
    [wait_time_ms_4]        BIGINT          NULL,
    [latch_class_5]         VARCHAR (60)    NULL,
    [wait_time_ms_5]        BIGINT          NULL,
    [spinlock_name_1]       VARCHAR (256)   NULL,
    [spins_1]               BIGINT          NULL,
    [collisions_1]          BIGINT          NULL,
    [backoffs_1]            BIGINT          NULL,
    [sleep_time_1]          BIGINT          NULL,
    [spins_per_collision_1] REAL            NULL,
    [spinlock_name_2]       VARCHAR (256)   NULL,
    [spins_2]               BIGINT          NULL,
    [collisions_2]          BIGINT          NULL,
    [backoffs_2]            BIGINT          NULL,
    [sleep_time_2]          BIGINT          NULL,
    [spins_per_collision_2] REAL            NULL,
    [spinlock_name_3]       VARCHAR (256)   NULL,
    [spins_3]               BIGINT          NULL,
    [collisions_3]          BIGINT          NULL,
    [backoffs_3]            BIGINT          NULL,
    [sleep_time_3]          BIGINT          NULL,
    [spins_per_collision_3] REAL            NULL,
    [spinlock_name_4]       VARCHAR (256)   NULL,
    [spins_4]               BIGINT          NULL,
    [collisions_4]          BIGINT          NULL,
    [backoffs_4]            BIGINT          NULL,
    [sleep_time_4]          BIGINT          NULL,
    [spins_per_collision_4] REAL            NULL,
    [spinlock_name_5]       VARCHAR (256)   NULL,
    [spins_5]               BIGINT          NULL,
    [collisions_5]          BIGINT          NULL,
    [backoffs_5]            BIGINT          NULL,
    [sleep_time_5]          BIGINT          NULL,
    [spins_per_collision_5] REAL            NULL,
    CONSTRAINT [PkInsertStats] PRIMARY KEY CLUSTERED ([Test] ASC, [Threads] ASC)
);

