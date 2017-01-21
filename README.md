##Overview

This project will  build on all versions  of SQL Server  from 2014 onwards, the aim of this code is  to 
provide a test harness which code me used to execute up to 2 different  user supplied stored procedures
and specify  a starting thread count and an end count,  the harness will then execute the user supplied 
code  for each  thread count between the  start and end thread count  boundaries  supplied. The harness
will gather the following statistics for each execution:

- Start and end times
- Throughput in transactions per second
- Top 5 wait statistics by percentage
- Top 5 latch statistics by latch sleep time
- Top 5 spinlock statistics by spins 

The test harness it self is encapsulated by two objects:

- usp_StresSQL
- StresSQLStats
 
The sample objects include which accompany  the project include memory optimised  tables and, therefore
the project can only be deployed in its entirety to version of SQL Server from 2014 onwards.
 
##What The Project Contains
 
- Core stress test harness objects:

  usp_StresSQL
  StresSQLStats

- Stored  procedures for testing  the  scalability of single  inserts using different  clustered  index 
  clusters keys:

  usp_InsertBitReverse - bit reversed bigint key
  usp_InsertGuid       - guid
  usp_InsertHashPart   - hash partitioned clustered index
  usp_InsertSpid       - key based on @@SPID offset ( @@SPID * 10000000000 )

- Stored  procedures for  pushing  messages  into a  disk based  clustered  index key using  code based
  in  the  "LMax disruptor pattern"
 
- Non-NUMA aware stored procedures for  pushing into a queue using a sequence object to obtain the id 
  of the slot messages are intended to be pushed into:

  usp_LMaxDiskInit                   - procedure  to set reference count to 0 for each queue slot prior
                                       to each test.
  usp_LmaxPushDiskSequence           - main procedure to run the test, it invokes 
                                       usp_PushMessageDiskSequence from within a loop.
  usp_PushMessageDiskSequence        - procedure to push individual messages into the queue.
  
- Non-NUMA aware stored  procedures for pushing  into a queue using an  in-memory table to obtain the
  id of the slot messages are intended to be pushed into:

  usp_LMaxDiskInit                   - procedure to set reference count to 0 for each queue slot prior
                                       to each test.
  usp_LmaxPushDiskNoSequence         - main procedure to run the test, it invokes 
                                       usp_PushMessageDiskNoSequence from within a loop.
  usp_PushMessageDiskNoSequence      - procedure to push individual messages into the queue.
  usp_GetPushSlotId                  - procedure to obtain the id for a slot to push a message into

- NUMA aware push  procedures using  memory optimised  table to  generate the  number of the slot to 
  push the message into

  usp_LMaxDiskNumaInit               - Procedure  to  set  reference  count  to  zero for each slot in 
                                       queues
  usp_LmaxPushDiskNumaNoSequence     - main push procedure
  usp_GetPushSlotIdNode0             - procedure  to  obtain  the  slot  id for pushing  messages into 
                                       queue for NUMA node 0
  usp_GetPushSlotIdNode1             - procedure  to   obtain  the  slot id  forpushing  messages into 
                                       queue for NUMA node 0
  usp_PushMessageDiskNoSequenceNode0 - procedure  to push  messages  into NUMA  node 0 queue clustered
                                       index
  usp_PushMessageDiskNoSequenceNode1 - procedure  to  push  messages into NUMA  node 1 queue clustered
                                       index
 
- NUMA  aware  push procedures using  sequence  objects to generate the number  of the  slot to push
  the message into

  usp_LMaxDiskNumaInit               - Procedure  to  set  reference  count  to  zero for each slot in 
                                       queues
  usp_LmaxPushDiskNumaSequence       - main push procedure
  usp_PushMessageDiskSequenceNode0   - procedure to  push  messages  into  NUMA node 0 queue clustered 
                                       index
  usp_PushMessageDiskSequenceNode1   - procedure  to  push messages into  NUMA  node 1 queue clustered 
                                       index

- Stored procedures  for pushing messages into  a disk based clustered  index key using code  based in 
  the "LMax disruptor pattern"

##How To Deploy The Project

1. A SQL Server 2014 or 2016 instance is required in order to deploy the StresSQL project

2. The StresSQL  harness requires  the ability  to run  xp_cmdshell, note  that for security reasons 
   as thiS provides access to the underlying operating system, this  should not ideally be enabled for
   production instances. 

EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO

3. Enable CLR integration:

sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  
sp_configure 'clr enabled', 1;  
GO  
RECONFIGURE;  
GO  
 
4. Publish  the  project,  on a MacBook Pro  (Intel i7  and 16GB  of memory)  with  Windows 10  running
   under bootcamp and SQL  Server 2016, the project  takes around 17.5 minutes to run,the bulk of  this
   time is that spent  populating the queue  tables (MyQLMax, MyQLMaxNode0 and MyQLMaxNode1) with empty
   slots.

##Using The Test Harness

The stress test harness is invoked by calling the [dbo].[usp_StresSQL] stored procedure:

EXECUTE @RC = [dbo].[usp_StresSQL] 
   @Test
  ,@StartThread
  ,@EndThread
  ,@Procedure1
  ,@Procedure2
  ,@InitProcedure
  ,@TransactionsPerThread
  ,@CommitBatchSize
GO

this procedure inserts rows representing execution stats for a test in the StresSQLStats table which it
assumes to be  in the same database which  it itself resides in,an description  of the input parameters
this stored procedure takes is as follows:

  |                              |                                             |                      |
  | Parameter                    | Description                                 | Mandatory (Y/N)      |
  | ---------------------------- |:-------------------------------------------:|---------------------:|
  |                              |                                             |                      |
  |                              |                                             |                      |
  |  @Test                       | Name of the test to run.                    |           Y          |
  |                              |                                             |                      |
  |                              |                                             |                      |
  |  @StartThread                | Start number of the number of threads to    |           Y          |
  |                              | run the test with.                          |                      |
  |                              |                                             |                      |
  |                              |                                             |                      |                 
  |  @EndThread                  | Start number of the number of threads to    |           Y          |
  |                              | runthe test with.                           |                      | 
  |                              |                                             |                      |
  |                              |                                             |                      |
  |  @Procedure1                 | Name of the first procedure to run.         |           Y          |
  |                              |                                             |                      |
  |                              |                                             |                      |
  |  @Procedure2                 | Name of the second procedure to run         |           N          |
  |                              |                                             |                      |
  |                              |                                             |                      |
  |  @InitProcedure              | Test initialisation procedure               |           N          |
  |                              |                                             |                      |
  |                              |                                             |                      | 
  |  @TransactionsPerThread      | Number of transactions to run per thread,   |           N          |
  |                              | equates to rows to insert for usp_Insert    |                      |
  |                              | procedures and messages for the usp_LMax    |                      |
  |                              | procedures, defaults to 200,000             |                      |
  |                              |                                             |                      |
  |                              |                                             |                      |
  |  @CommitBatchSize            | Number of items to batch together per       |           N          |
  |                              | commit, defaults to 1 and is always 1       |                      |
  |                              | for the LMax procedures.                    |                      |

The test harness assumes:

1. The  objects  and  code  being  tested  reside in the same  database as usp_StresSQL  and the
   StresSQLStats table.

2. Both the buffer pool and plan cache should be cold prior to each test.

3. All log file virtual log files should be in a reusable state prior to each test.

##Examples:

1. Lmax  disk based  table push and pull working at the same time with 1 and then 2 threads, with 1000
   messages pushed and pulled

USE [StresSQL]
GO

DECLARE @RC int

EXECUTE @RC = [dbo].[usp_StresSQL] 
   @Test                  = 'LMax disk no sequence push and pull'
  ,@StartThread           = 1
  ,@EndThread             = 2
  ,@Procedure1            = '[dbo].[usp_LmaxPushDiskNoSequence]'
  ,@Procedure2            = '[dbo].[usp_LmaxPopDiskNoSequence]'
  ,@TransactionsPerThread = 1000
GO

2. Lmax  disk based  table push *only* with 1 and then 2 threads, with 1000 messages pushed per thread

USE [StresSQL]
GO

DECLARE @RC int

EXECUTE @RC = [dbo].[usp_StresSQL] 
   @Test                  = 'LMax disk no sequence push and pull'
  ,@StartThread           = 1
  ,@EndThread             = 2
  ,@Procedure1            = '[dbo].[usp_LmaxPushDiskNoSequence]'
  ,@TransactionsPerThread = 1000
GO

3. Singleton insert with cluster key based on a @@SPID offset

USE [StresSQL]
GO

DECLARE @RC int

EXECUTE @RC = [dbo].[usp_StresSQL] 
   @Test                  = 'Singleton INSERT stress test '
  ,@StartThread           = 1
  ,@EndThread             = 2
  ,@Procedure1            = '[dbo].[usp_InsertSpid]'
  ,@TransactionsPerThread = 1000
GO

##Suggestions For Configuring SQL Server Prior To Tesing

1. Have at least one file in the file group FG_01 per logical processor, or two if your storage is high
   performance flash based.

2. To  investigate spinlocks enable delayed  durability, otherwise all  you  will observe  is  WRITELOG 
   waits, the reasoning behind this is  that with conventional  durability the load on the  engine will
   never move past write log waits, unless you  are using memory mapped  log write IO to an  NVDIMM via
   Windows 2016 DAX.

3. For server  with two  sockets  and more than six physcial cores per sockets,  consider  removing CPU
   0 on socket 0 from the  affinity mask,  this  affinitizes the  rest of the database engine away from
   the log writer, when the instance starts up the log  writer is usually assinged to NUMA node 0,  CPU 
   0.

4. The  SQL  Server scheduler  is not  hyper-threading  aware and  therefore makes  no  any distinction 
   between scheduling a task on  a logical processor on a core that is already in use by a hyper-thread
   as opposed to a CPU core which  has  nothing running on it. A  second hyper-thread running on a core
   may get up 25% of  the total  cores  compute   capacity. To  get cleaner  looking  graphs,  consider
   either  turning  off hyper-threading at the  Bios/EFI  level or disabling all  odd numbered  logical
   processors  in  the  CPU affinity mask.

5. Turn on trace flag 2330, this stops spins on  the OPT_IDX_STATS spinlock,  this serialises access to
   the internal memory structures associated with the missing index feature DMVs.

6. Turn on trace  flag  8008,  this stops  the  SQL OS scheduling  from using scheduler hints  and  can
   result much more even CPU core utilisation.

7. To quantify the overhead of CPU cache coherency on   passing  around the cache line  associated with
   the  LOGCACHE_ACCESS  spinlock,  consider altering  the  CPU  affinity mask  on  a two socket server
   such that the workload runs on NUMA node 0 in one test and then NUMA node 1 in another.

##Disclaimer

This software is   used at the  users  own risk, it is purely  intended  to provide a  means of putting  
the  database engine under stress, as  such it should  not be used  against production envronments. Any
commitment to fix any potential bugs and or make enhancements  is at the sole  discretion of its author
in terms of if and when to carry this work out.