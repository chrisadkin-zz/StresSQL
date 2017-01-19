CREATE FUNCTION [dbo].[BitReverse]
(@OriginalInt BIGINT NULL)
RETURNS BIGINT
AS
 EXTERNAL NAME [CLRUtils].[Utils.Utils].[BitReverse]

