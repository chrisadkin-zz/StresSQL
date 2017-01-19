﻿/*
Deployment script for StressTest

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "StressTest"
:setvar DefaultFilePrefix "StressTest"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Altering [dbo].[usp_InsertBitReverse]...';


GO

ALTER PROCEDURE [dbo].[usp_InsertBitReverse]
     @TransactionsPerThread int = 500000
    ,@CommitBatchSize       int = 2
 AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
 
    DECLARE   @i      INTEGER = 0
	         ,@j      INTEGER = 0
             ,@base   BIGINT  = @@SPID * @TransactionsPerThread
			 ,@PartId INTEGER;
 
    WHILE @i < @TransactionsPerThread
    BEGIN
        BEGIN TRANSACTION
		    WHILE @j < @CommitBatchSize
			BEGIN		 
				INSERT INTO dbo.MyBigTable (c1)
				VALUES  (dbo.BitReverse(@base + @i)); 
				SET @j += 1;
			END;
        COMMIT;

		set @j = 0;
        SET @i += 1;
    END;
END;
GO
PRINT N'Altering [dbo].[usp_InsertGuid]...';


GO


ALTER PROCEDURE [dbo].[usp_InsertGuid]
     @TransactionsPerThread int = 250000
    ,@CommitBatchSize       int = 2
 AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
 
    DECLARE  @i INTEGER = 0
	        ,@j INTEGER = 0;
 
    WHILE @i < @TransactionsPerThread
    BEGIN
        BEGIN TRANSACTION
			WHILE @j < @CommitBatchSize
			BEGIN
				INSERT INTO dbo.MyBigTableGuid DEFAULT VALUES;
				SET @j += 1;
			END;
        COMMIT;
		
		SET @j = 0;
        SET @i += 1;
    END;
END;
GO
PRINT N'Altering [dbo].[usp_InsertHashPart]...';


GO



ALTER PROCEDURE [dbo].[usp_InsertHashPart]
     @TransactionsPerThread int = 500000
    ,@CommitBatchSize       int = 2
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
 
    DECLARE  @i           INTEGER = 0
	        ,@j           INTEGER = 0 
	        ,@PartitionId BIGINT;
 
    WHILE @i < @TransactionsPerThread
    BEGIN
	    SET @PartitionId = ( ( CAST(RAND() * 1000000 AS bigint ) ) % 40 ) + 1;

        BEGIN TRANSACTION
		    WHILE @j < @CommitBatchSize
			BEGIN
				INSERT INTO dbo.MyBigTableHash( PartId ) VALUES ( @PartitionId );
				SET @j += 1;
			END
		COMMIT;

		SET @j = 0;
        SET @i += 1;
    END;
END;
GO
PRINT N'Altering [dbo].[usp_LmaxPopDiskNoSequence]...';


GO

ALTER PROCEDURE [dbo].[usp_LmaxPopDiskNoSequence] @TransactionsPerThread int = 200000
AS 
BEGIN 
    DECLARE  @MessagePopped int
            ,@i             int = 0;

    SET NOCOUNT ON;

	WHILE @i <= @TransactionsPerThread 
	BEGIN
		EXEC dbo.usp_PopMessageNoSequence @MessagePopped OUTPUT; 
		SET @i += 1;
	END;
END;
GO
PRINT N'Altering [dbo].[usp_LmaxPopDiskNumaNoSequence]...';


GO
 

ALTER PROCEDURE [dbo].[usp_LmaxPopDiskNumaNoSequence] @TransactionsPerThread int = 200000
AS 
BEGIN 
    DECLARE  @MessagePopped int
            ,@Slot          int
            ,@i             int = 0;

    SET NOCOUNT ON;

	IF EXISTS (SELECT 1
               FROM   sys.dm_exec_requests r
               JOIN   sys.dm_os_workers    w
               ON     r.task_address = w.task_address
               JOIN   sys.dm_os_schedulers s
               ON     s.scheduler_address = w.scheduler_address
               WHERE  r.session_id     = @@SPID
			   AND    s.parent_node_id = 0)
	BEGIN
		WHILE @i <= @TransactionsPerThread 
		BEGIN
			EXEC dbo.usp_PopMessageDiskNode0V4 @MessagePopped OUTPUT; 
			SET @i += 1;
		END;
	END
	ELSE
	BEGIN
		WHILE @i <= @TransactionsPerThread
		BEGIN
			EXEC dbo.usp_PopMessageDiskNode1V4 @MessagePopped OUTPUT; 
			SET @i += 1;
		END;
	END
END;
GO
PRINT N'Altering [dbo].[usp_LmaxPopDiskNumaSequence]...';


GO


ALTER PROCEDURE [dbo].[usp_LmaxPopDiskNumaSequence] @TransactionsPerThread int = 200000
AS 
BEGIN 
    DECLARE  @MessagePopped int
            ,@Slot          int
            ,@i             int = 0;

    SET NOCOUNT ON;

	IF EXISTS (SELECT 1
               FROM   sys.dm_exec_requests r
               JOIN   sys.dm_os_workers    w
               ON     r.task_address = w.task_address
               JOIN   sys.dm_os_schedulers s
               ON     s.scheduler_address = w.scheduler_address
               WHERE  r.session_id     = @@SPID
			   AND    s.parent_node_id = 0)
	BEGIN
		WHILE @i <= @TransactionsPerThread 
		BEGIN
			EXEC dbo.usp_PopMessageDiskNode0V3 @MessagePopped OUTPUT; 
			SET @i += 1;
		END;
	END
	ELSE
	BEGIN
		WHILE @i <= @TransactionsPerThread 
		BEGIN
			EXEC dbo.usp_PopMessageDiskNode1V3 @MessagePopped OUTPUT; 
			SET @i += 1;
		END;
	END
END;
GO
PRINT N'Altering [dbo].[usp_LmaxPopDiskSequence]...';


GO

ALTER PROCEDURE [dbo].[usp_LmaxPopDiskSequence] @TransactionsPerThread int = 200000
AS 
BEGIN 
    DECLARE  @MessagePopped int
            ,@Slot          int
            ,@i             int = 0;

    SET NOCOUNT ON;

	WHILE @i <= @TransactionsPerThread
	BEGIN
		EXEC dbo.usp_PopMessageDiskSequence @MessagePopped OUTPUT; 
		SET @i += 1;
	END;
END;
GO
PRINT N'Altering [dbo].[usp_StressTestHarness]...';


GO





ALTER PROCEDURE [dbo].[usp_StressTestHarness] 
     @Test                  VARCHAR(256)
	,@StartThread           INT            = 1
	,@EndThread             INT            = 20
    ,@Procedure1            VARCHAR(256)   = 'LmaxPushV3Wrapper'
    ,@Procedure2            VARCHAR(256)   = 'NO POP PROCEDURE'
	,@InitProcedure         NVARCHAR(256)  = N'NO INIT PROCEDURE'
	,@DatabaseName          VARCHAR(256)   = ''
	,@PurgeTableBeforeTest  BIT            = 0
    ,@TableName             VARCHAR(256)   = ''
	,@TransactionsPerThread BIGINT         = 200000
	,@CommitBatchSize       INT            = 1
	,@Server                VARCHAR(256)   = 'WIN-9K68K80GG9D\SQL2016'
AS
BEGIN
    DECLARE  @StartTime DATETIME
            ,@PshCmd    VARCHAR(512)
            ,@InitCmd   NVARCHAR(512)
			,@i         BIGINT;

    DECLARE @WaitStats TABLE (
	     [Rank]       [bigint]         NULL
		,[WaitType]   [nvarchar](60)   NULL
		,[Wait_S]     [decimal](16, 2) NULL
		,[WaitCount]  [bigint]         NULL
		,[Percentage] [decimal](5, 2)  NULL
		,[AvgWait_S]  [decimal](16, 4) NULL
	);

	DECLARE @SpinlockStats TABLE (
         [Rank]                [tinyint]      NULL
		,[name]                [varchar](256) NULL
		,[collisions]          [bigint]       NULL
		,[spins]               [bigint]       NULL
		,[spins_per_collision] [real]         NULL
		,[sleep_time]          [bigint]       NULL
		,[backoffs]            [bigint]       NULL
	);

	SET NOCOUNT ON;

	SET @i = @StartThread;

	SELECT @DatabaseName = DB_NAME();

	WHILE @i <= @EndThread
	BEGIN		
		IF @PurgeTableBeforeTest = 1
		BEGIN
			EXEC ('TRUNCATE TABLE ' + @TableName)
		END;

		UPDATE [dbo].[MyQLmax] SET reference_count = 0;
		UPDATE [dbo].[MyQLmaxNode0] SET reference_count = 0;
		UPDATE [dbo].[MyQLmaxNode1] SET reference_count = 0;

		IF @InitProcedure <> 'NO INIT PROCEDURE'
		BEGIN
		    SET @InitCmd = 'EXECUTE ' + @InitProcedure;
			EXECUTE sp_executesql @InitCmd;
		END;

		EXEC ('ALTER DATABASE ' + @DatabaseName + ' SET RECOVERY SIMPLE');
		EXEC ('ALTER DATABASE ' + @DatabaseName + ' SET RECOVERY FULL');

		INSERT INTO [dbo].[StressTestStats] ( Test
					                         ,Threads
					                         ,StartTime )
		VALUES ( @test
				,@i
				,GETDATE());
		
		SET @PshCmd = 'PowerShell.exe -noprofile -command ' + '"' +
						'for($i=1; $i -le ' + CAST(@i AS char(2)) + '; $i++) { ' +
							'Start-Job { Invoke-sqlcmd -Database ' + @DatabaseName +
							' -ServerInstance ' + @server + 
							' -Query \"EXECUTE ' + @Procedure1 + ' @TransactionsPerThread = ' + CAST(@TransactionsPerThread AS VARCHAR);

	    IF @CommitBatchSize > 1
		BEGIN
		    SET @PshCmd += ', @CommitBatchSize = ' + CAST(@CommitBatchSize AS VARCHAR) + '\" }'
		END
		ELSE
		BEGIN
		    SET @PshCmd += '\" }'
		END;
						   
		IF @Procedure2 <> 'NO POP PROCEDURE'
		BEGIN						   
			SET @PshCmd += '; ' +
	                       'Start-Job { Invoke-sqlcmd -Database ' + @DatabaseName + 
						   ' -ServerInstance ' + @server + 
						   ' -Query \"EXECUTE ' + ' @TransactionsPerThread = ' + CAST(@TransactionsPerThread AS VARCHAR);  
		END;

		IF @CommitBatchSize > 1
		BEGIN
		    SET @PshCmd += ', @CommitBatchSize = ' + CAST(@CommitBatchSize AS VARCHAR) + '\" }'
		END
		ELSE
		BEGIN
		    SET @PshCmd += @PshCmd + '\" } '
		END;

		SET @PshCmd += '}; while (Get-Job -state running) { Start-Sleep -Seconds 1 }"';

		SELECT @PshCmd AS [@PshCmd];

		DBCC SQLPERF("sys.dm_os_spinlock_stats", clear)
		DBCC SQLPERF("sys.dm_os_latch_stats"   , clear)
		DBCC SQLPERF("sys.dm_os_wait_stats"    , clear)

		SET @StartTime = GETDATE();	

		EXECUTE xp_cmdshell @PshCmd;

		IF DATEDIFF(ms, @StartTime, GETDATE()) > 0
		BEGIN
			UPDATE  [dbo].[StressTestStats]
			SET     [TransactionRate] = ((@i * @TransactionsPerThread) * CAST(1000 AS bigint)
										 / CAST(DATEDIFF(ms, @StartTime, GETDATE()) AS bigint))
				   ,[EndTime]         = GETDATE()
			WHERE  Threads = @i
			AND    Test    = @test;

			DELETE FROM @WaitStats;

			WITH [Waits] AS (SELECT  [wait_type]
									,[wait_time_ms] / 1000.0                              AS [WaitS]
									,([wait_time_ms] - [signal_wait_time_ms]) / 1000.0    AS [ResourceS]
									,[signal_wait_time_ms] / 1000.0                       AS [SignalS]
									,[waiting_tasks_count]                                AS [WaitCount]
									,100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage]
									,ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC)      AS [RowNum]
							 FROM    sys.dm_os_wait_stats
							 WHERE   [wait_type] NOT IN ( N'BROKER_EVENTHANDLER', N'BROKER_RECEIVE_WAITFOR',
														  N'BROKER_TASK_STOP', N'BROKER_TO_FLUSH',
														  N'BROKER_TRANSMITTER', N'CHECKPOINT_QUEUE',
														  N'CHKPT', N'CLR_AUTO_EVENT',
														  N'CLR_MANUAL_EVENT', N'CLR_SEMAPHORE',
														  -- Maybe uncomment these four if you have mirroring issues
														  N'DBMIRROR_DBM_EVENT', N'DBMIRROR_EVENTS_QUEUE',
														  N'DBMIRROR_WORKER_QUEUE', N'DBMIRRORING_CMD',
														  N'DIRTY_PAGE_POLL', N'DISPATCHER_QUEUE_SEMAPHORE',
														  N'EXECSYNC', N'FSAGENT',
														  N'FT_IFTS_SCHEDULER_IDLE_WAIT', N'FT_IFTSHC_MUTEX',
														  -- Maybe uncomment these six if you have AG issues
														  N'HADR_CLUSAPI_CALL', N'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
														  N'HADR_LOGCAPTURE_WAIT', N'HADR_NOTIFICATION_DEQUEUE',
														  N'HADR_TIMER_TASK', N'HADR_WORK_QUEUE',
														  N'KSOURCE_WAKEUP', N'LAZYWRITER_SLEEP',
														  N'LOGMGR_QUEUE', N'MEMORY_ALLOCATION_EXT',
														  N'ONDEMAND_TASK_QUEUE',
														  N'PREEMPTIVE_XE_GETTARGETSTATE',
														  N'PWAIT_ALL_COMPONENTS_INITIALIZED',
														  N'PWAIT_DIRECTLOGCONSUMER_GETNEXT',
														  N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP', N'QDS_ASYNC_QUEUE',
														  N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP',
														  N'QDS_SHUTDOWN_QUEUE', N'REDO_THREAD_PENDING_WORK',
														  N'REQUEST_FOR_DEADLOCK_SEARCH', N'RESOURCE_QUEUE',
														  N'SERVER_IDLE_CHECK', N'SLEEP_BPOOL_FLUSH',
														  N'SLEEP_DBSTARTUP', N'SLEEP_DCOMSTARTUP',
														  N'SLEEP_MASTERDBREADY', N'SLEEP_MASTERMDREADY',
														  N'SLEEP_MASTERUPGRADED', N'SLEEP_MSDBSTARTUP',
														  N'SLEEP_SYSTEMTASK', N'SLEEP_TASK',
														  N'SLEEP_TEMPDBSTARTUP', N'SNI_HTTP_ACCEPT',
														  N'SP_SERVER_DIAGNOSTICS_SLEEP', N'SQLTRACE_BUFFER_FLUSH',
														  N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
														  N'SQLTRACE_WAIT_ENTRIES', N'WAIT_FOR_RESULTS',
														  N'WAITFOR', N'WAITFOR_TASKSHUTDOWN',
														  N'WAIT_XTP_RECOVERY',
														  N'WAIT_XTP_HOST_WAIT', N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG',
														  N'WAIT_XTP_CKPT_CLOSE', N'XE_DISPATCHER_JOIN',
														  N'XE_DISPATCHER_WAIT', N'XE_TIMER_EVENT',
														  N'PREEMPTIVE_XE_DISPATCHER', N'CXPACKET',
														  N'PREEMPTIVE_OS_PIPEOPS', N'PREEMPTIVE_XE_CALLBACKEXECUTE')
							 AND     [waiting_tasks_count] > 0
							)
			INSERT INTO @WaitStats (
					  [Rank]       
					 ,[WaitType]   
					 ,[Wait_S]     
					 ,[WaitCount]  
					 ,[Percentage] 
					 ,[AvgWait_S]  
			)
			SELECT TOP 5 W1.RowNum                                                        AS [Rank]
				  ,MAX ([W1].[wait_type])                                                 AS [WaitType]
				  ,CAST (MAX ([W1].[WaitS]) AS DECIMAL (16,2))                            AS [Wait_S]
				  ,MAX ([W1].[WaitCount])                                                 AS [WaitCount]
				  ,CAST (MAX ([W1].[Percentage]) AS DECIMAL (5,2))                        AS [Percentage]
				  ,CAST ((MAX ([W1].[WaitS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgWait_S]
			FROM   [Waits] AS [W1]
			JOIN   [Waits] AS [W2]
			ON     [W2].[RowNum] <= [W1].[RowNum]
			GROUP  BY [W1].[RowNum]
			HAVING SUM ([W2].[Percentage]) - MAX( [W1].[Percentage] ) < 95 -- percentage threshold
			ORDER  BY CAST (MAX ([W1].[WaitS]) AS DECIMAL (16,2)) DESC;

			UPDATE      ists
			SET         ists.[WaitType_1]   = wsts.[WaitType]
					   ,ists.[Wait_S_1]     = wsts.[Wait_S]
					   ,ists.[WaitCount_1]  = wsts.[WaitCount]
					   ,ists.[Percentage_1] = wsts.[Percentage]
					   ,ists.[AvgWait_S_1]  = wsts.[AvgWait_S]
			FROM        StressTestStats AS ists
			CROSS JOIN  @WaitStats      AS wsts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         wsts.[Rank]  = 1;

			UPDATE      ists
			SET         ists.[WaitType_2]   = wsts.[WaitType]
					   ,ists.[Wait_S_2]     = wsts.[Wait_S]
					   ,ists.[WaitCount_2]  = wsts.[WaitCount]
					   ,ists.[Percentage_2] = wsts.[Percentage]
					   ,ists.[AvgWait_S_2]  = wsts.[AvgWait_S]
			FROM        StressTestStats AS ists
			CROSS JOIN  @WaitStats      AS wsts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         wsts.[Rank]  = 2;

 			UPDATE      ists
			SET         ists.[WaitType_3]   = wsts.[WaitType]
					   ,ists.[Wait_S_3]     = wsts.[Wait_S]
					   ,ists.[WaitCount_3]  = wsts.[WaitCount]
					   ,ists.[Percentage_3] = wsts.[Percentage]
					   ,ists.[AvgWait_S_3]  = wsts.[AvgWait_S]
			FROM        StressTestStats AS ists
			CROSS JOIN  @WaitStats      AS wsts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         wsts.[Rank]  = 3;

 			UPDATE      ists
			SET         ists.[WaitType_4]   = wsts.[WaitType]
					   ,ists.[Wait_S_4]     = wsts.[Wait_S]
					   ,ists.[WaitCount_4]  = wsts.[WaitCount]
					   ,ists.[Percentage_4] = wsts.[Percentage]
					   ,ists.[AvgWait_S_4]  = wsts.[AvgWait_S]
			FROM        StressTestStats AS ists
			CROSS JOIN  @WaitStats      AS wsts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         wsts.[Rank]  = 4;

 			UPDATE      ists
			SET         ists.[WaitType_5]   = wsts.[WaitType]
					   ,ists.[Wait_S_5]     = wsts.[Wait_S]
					   ,ists.[WaitCount_5]  = wsts.[WaitCount]
					   ,ists.[Percentage_5] = wsts.[Percentage]
					   ,ists.[AvgWait_S_5]  = wsts.[AvgWait_S]
			FROM        StressTestStats AS ists
			CROSS JOIN  @WaitStats  AS wsts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         wsts.[Rank]  = 5;

			WITH Latch_CTE AS (
				SELECT    TOP 5 ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [Rank]
						 ,latch_class
						 ,wait_time_ms 
				FROM      sys.dm_os_latch_stats
				WHERE     latch_class <> 'BUFFER'
				ORDER BY  wait_time_ms DESC)
			UPDATE      ists
			SET         ists.[latch_class_1]   = lsts.[latch_class]
					   ,ists.[wait_time_ms_1]  = lsts.[wait_time_ms]
			FROM        StressTestStats AS ists
			CROSS JOIN  Latch_CTE   AS lsts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         lsts.[Rank]  = 1;

			WITH Latch_CTE AS (
				SELECT    TOP 5 ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [Rank]
						 ,latch_class
						 ,wait_time_ms 
				FROM      sys.dm_os_latch_stats
				WHERE     latch_class <> 'BUFFER'
				ORDER BY  wait_time_ms DESC)
			UPDATE      ists
			SET         ists.[latch_class_2]   = lsts.[latch_class]
					   ,ists.[wait_time_ms_2]  = lsts.[wait_time_ms]
			FROM        StressTestStats AS ists
			CROSS JOIN  Latch_CTE   AS lsts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         lsts.[Rank]  = 2;

			WITH Latch_CTE AS (
				SELECT    TOP 5 ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [Rank]
						 ,latch_class
						 ,wait_time_ms 
				FROM      sys.dm_os_latch_stats
				WHERE     latch_class <> 'BUFFER'
				ORDER BY  wait_time_ms DESC)
			UPDATE      ists
			SET         ists.[latch_class_3]   = lsts.[latch_class]
					   ,ists.[wait_time_ms_3]  = lsts.[wait_time_ms]
			FROM        StressTestStats AS ists
			CROSS JOIN  Latch_CTE   AS lsts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         lsts.[Rank]  = 3;

			WITH Latch_CTE AS (
				SELECT    TOP 5 ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [Rank]
						 ,latch_class
						 ,wait_time_ms 
				FROM      sys.dm_os_latch_stats
				WHERE     latch_class <> 'BUFFER'
				ORDER BY  wait_time_ms DESC)
			UPDATE      ists
			SET         ists.[latch_class_4]   = lsts.[latch_class]
					   ,ists.[wait_time_ms_4]  = lsts.[wait_time_ms]
			FROM        StressTestStats AS ists
			CROSS JOIN  Latch_CTE   AS lsts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         lsts.[Rank]  = 4;

			WITH Latch_CTE AS (
				SELECT    TOP 5 ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [Rank]
						 ,latch_class
						 ,wait_time_ms 
				FROM      sys.dm_os_latch_stats
				WHERE     latch_class <> 'BUFFER'
				ORDER BY  wait_time_ms DESC)
			UPDATE      ists
			SET         ists.[latch_class_5]   = lsts.[latch_class]
					   ,ists.[wait_time_ms_5]  = lsts.[wait_time_ms]
			FROM        StressTestStats AS ists
			CROSS JOIN  Latch_CTE   AS lsts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         lsts.[Rank]  = 5;

			DELETE FROM @SpinlockStats;

			INSERT INTO @SpinlockStats (
					  [Rank]                
					 ,[name]                
					 ,[collisions]          
					 ,[spins]               
					 ,[spins_per_collision] 
					 ,[sleep_time]          
					 ,[backoffs]            
			)
			SELECT    TOP 5 ROW_NUMBER() OVER(ORDER BY [spins] DESC) AS [Rank]
					 ,name
					 ,collisions
					 ,spins
					 ,spins_per_collision
					 ,sleep_time
					 ,backoffs
			FROM     sys.dm_os_spinlock_stats
			ORDER BY spins DESC;
		
			UPDATE      ists
			SET          [spinlock_name_1]       = ssts.name
						,[spins_1]               = ssts.spins
						,[collisions_1]          = ssts.collisions
						,[backoffs_1]            = ssts.backoffs
						,[sleep_time_1]          = ssts.sleep_time		
						,[spins_per_collision_1] = ssts.spins_per_collision
			FROM        StressTestStats           AS ists
			CROSS JOIN  @SpinlockStats AS ssts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         ssts.[Rank]  = 1;

			UPDATE      ists
			SET          [spinlock_name_2]       = ssts.name
						,[spins_2]               = ssts.spins
						,[collisions_2]          = ssts.collisions
						,[backoffs_2]            = ssts.backoffs
						,[sleep_time_2]          = ssts.sleep_time		
						,[spins_per_collision_2] = ssts.spins_per_collision
			FROM        StressTestStats           AS ists
			CROSS JOIN  @SpinlockStats AS ssts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         ssts.[Rank]  = 2;

			UPDATE      ists
			SET          [spinlock_name_3]       = ssts.name
						,[spins_3]               = ssts.spins
						,[collisions_3]          = ssts.collisions
						,[backoffs_3]            = ssts.backoffs
						,[sleep_time_3]          = ssts.sleep_time		
						,[spins_per_collision_3] = ssts.spins_per_collision
			FROM        StressTestStats           AS ists
			CROSS JOIN  @SpinlockStats AS ssts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         ssts.[Rank]  = 3;

			UPDATE      ists
			SET          [spinlock_name_4]       = ssts.name
						,[spins_4]               = ssts.spins
						,[collisions_4]          = ssts.collisions
						,[backoffs_4]            = ssts.backoffs
						,[sleep_time_4]          = ssts.sleep_time		
						,[spins_per_collision_4] = ssts.spins_per_collision
			FROM        StressTestStats           AS ists
			CROSS JOIN  @SpinlockStats AS ssts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         ssts.[Rank]  = 4;

			UPDATE      ists
			SET          [spinlock_name_5]       = ssts.name
						,[spins_5]               = ssts.spins
						,[collisions_5]          = ssts.collisions
						,[backoffs_5]            = ssts.backoffs
						,[sleep_time_5]          = ssts.sleep_time		
						,[spins_per_collision_5] = ssts.spins_per_collision
			FROM        StressTestStats           AS ists
			CROSS JOIN  @SpinlockStats AS ssts
			WHERE       ists.Threads = @i
			AND         ists.Test    = @test
			AND         ssts.[Rank]  = 5;
		END;
		
		SET @i += 1;
	END;
END;
GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
EXECUTE [dbo].[usp_LMaxDiskQSlotInit];
GO

GO
PRINT N'Update complete.';


GO
