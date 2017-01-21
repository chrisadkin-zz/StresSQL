
CREATE PROCEDURE [dbo].[usp_LMaxDiskNumaInit] 
AS
BEGIN
		UPDATE [dbo].[MyQLmaxNode0] SET reference_count = 0;
		UPDATE [dbo].[MyQLmaxNode1] SET reference_count = 0;
END;












