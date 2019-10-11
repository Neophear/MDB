CREATE PROCEDURE [dbo].[Search]
	@searchString NVARCHAR(100)
AS
	SELECT TOP 200 * FROM
		(SELECT 2 AS [Type], [Id] FROM [Employees] WHERE [MANR] = @searchString OR [Stabsnummer] = @searchString
		UNION
		SELECT 3 AS [Type], [Id] FROM [Devices] WHERE [IMEI] = @searchString
		UNION
		SELECT 4 AS [Type], [Id] FROM [Simcards] WHERE [Simnumber] = @searchString OR [Number] = @searchString)
	AS tbl
RETURN 0