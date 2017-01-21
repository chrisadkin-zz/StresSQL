
CREATE PROCEDURE [dbo].[usp_LMaxDiskInit] 
AS
BEGIN
		UPDATE [dbo].[MyQLmax] SET reference_count = 0;
END;












