
CREATE PROCEDURE [dbo].[usp_LMaxInit] 
AS
BEGIN
		UPDATE [dbo].[MyQLmax] SET reference_count = 0;
END;












