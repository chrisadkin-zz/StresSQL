﻿ 

CREATE PROCEDURE [dbo].[usp_LmaxPopDiskNumaNoSequence] @TransactionsPerThread int = 200000
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
			EXEC dbo.usp_PopMessageDiskNoSequenceNode0 @MessagePopped OUTPUT; 
			SET @i += 1;
		END;
	END
	ELSE
	BEGIN
		WHILE @i <= @TransactionsPerThread
		BEGIN
			EXEC dbo.usp_PopMessageDiskNoSequenceNode1 @MessagePopped OUTPUT; 
			SET @i += 1;
		END;
	END
END; 




