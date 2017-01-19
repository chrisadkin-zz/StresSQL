CREATE FUNCTION [dbo].[DistributeKey] 
(
	-- Add the parameters for the function here
	@Slot bigint
)
RETURNS bigint
AS
BEGIN
	RETURN
		CASE RIGHT(@Slot, 1)
			WHEN 1 THEN   @Slot
			WHEN 2 THEN   ( @Slot 
			               + (  CAST(6  AS bigint) 
						      * CAST(1000000000 AS bigint) ) )
			WHEN 3 THEN   ( @Slot 
			               + (  CAST(2  AS bigint) 
						      * CAST(1000000000 AS bigint) ) )
			WHEN 4 THEN   ( @Slot 
			               + (  CAST(8  AS bigint) 
						      * CAST(1000000000 AS bigint) ) )
			WHEN 5 THEN   ( @Slot 
			               + (  CAST(3  AS bigint) 
						      * CAST(1000000000 AS bigint) ) )
			WHEN 6 THEN   ( @Slot 
			               + (  CAST(9  AS bigint) 
						      * CAST(1000000000 AS bigint) ) )
			WHEN 7 THEN   ( @Slot 
			               + (  CAST(4  AS bigint) 
						      * CAST(1000000000 AS bigint) ) )
			WHEN 8 THEN   ( @Slot 
			               + (  CAST(9  AS bigint) 
						      * CAST(1000000000 AS bigint) ) )
			WHEN 9 THEN   ( @Slot 
			               + (  CAST(5  AS bigint) 
						      * CAST(1000000000 AS bigint) ) )
			WHEN 0 THEN   ( @Slot 
			               + (  CAST(10 AS bigint) 
						      * CAST(1000000000 AS bigint) ) )
		END;
END








