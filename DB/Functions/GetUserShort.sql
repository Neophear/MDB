CREATE FUNCTION [dbo].[GetUserShort]
(
	@MANR VARCHAR(8)
)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @Result NVARCHAR(150)
	EXEC @Result = dbo.GetUserFull @MANR

	IF @Result <> @MANR
		SET @Result = CONCAT(LEFT(@Result, CHARINDEX(' ', @Result)-1),' ',RIGHT(LEFT(REVERSE(@Result), CHARINDEX(' ',REVERSE(@Result))-1),1),'.')

	RETURN @Result
END