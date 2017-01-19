
CREATE PROCEDURE [dbo].[usp_LMaxImOltpInit] 
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC
WITH ( TRANSACTION ISOLATION LEVEL = SNAPSHOT
      ,LANGUAGE                    = N'us_english')
		UPDATE [dbo].[MyQLmaxImOltp] SET reference_count = 0;
END;












