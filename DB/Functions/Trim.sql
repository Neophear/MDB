CREATE FUNCTION [dbo].[Trim]
(
	@String NVARCHAR(MAX),
	@CharacterToTrim NVARCHAR(1)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	IF SUBSTRING(@String, 1, 1) = @CharacterToTrim
		SET @String = SUBSTRING(@String, 2, LEN(@STRING) - 1)

	IF SUBSTRING(@String, LEN(@String), 1) = @CharacterToTrim
		SET @String = SUBSTRING(@String, 1, LEN(@String) - 1)

	RETURN @String
END