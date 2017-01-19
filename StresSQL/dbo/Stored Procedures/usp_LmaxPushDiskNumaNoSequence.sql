
CREATE PROCEDURE [dbo].[usp_LmaxPushDiskNumaNoSequence] 
AS 
BEGIN 
    DECLARE  @QueueSize     int = 200000
            ,@MessagePushed int
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
		WHILE @i <= @QueueSize 
		BEGIN
			EXEC dbo.usp_PushMessageDiskNoSequenceNode0 @MessagePushed OUTPUT; 
			SET @i += 1;
		END;
	END
	ELSE
	BEGIN
		WHILE @i <= @QueueSize 
		BEGIN
			EXEC dbo.usp_PushMessageDiskNoSequenceNode1 @MessagePushed OUTPUT; 
			SET @i += 1;
		END;
	END
END; 



