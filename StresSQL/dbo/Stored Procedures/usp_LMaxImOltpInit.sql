CREATE PROCEDURE [dbo].[usp_LMaxImOltpInit]
AS
BEGIN
    DECLARE @retry INT = 10

    WHILE (@retry > 0)
    BEGIN
        BEGIN TRY
            UPDATE [dbo].[MyQLmaxImOltpTemporal] SET reference_count = 0;
            UPDATE [dbo].[MyQLmaxImOltpNoLog] SET reference_count = 0;
            UPDATE [dbo].[MyQLmaxImOltp] SET reference_count = 0;
            SET @retry = 0
        END TRY
        BEGIN CATCH
            SET @retry -= 1

            IF (@retry > 0 AND error_number() in (41302, 41305, 41325, 41301, 1205))
            BEGIN
                IF XACT_STATE() = -1
                BEGIN
                    ROLLBACK TRANSACTION;
                END;

                WAITFOR DELAY '00:00:00.001'
            END;
        END CATCH;
    END;
END;










