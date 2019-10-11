CREATE FUNCTION [dbo].[VisibleTo]
(
	@VisibleToRead BIT,
	@VisibleToWrite BIT
)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @returnVariable VARCHAR(20)
	IF @VisibleToRead = 0 AND @VisibleToWrite = 0
		SET @returnVariable = 'Kun Admin'
	ELSE
	BEGIN
		IF @VisibleToRead = 1
			SET @returnVariable = 'Read,'

		IF @VisibleToWrite = 1
			SET @returnVariable = CONCAT(@returnVariable,'Write')
	END

	RETURN dbo.Trim(@returnVariable,',')
END