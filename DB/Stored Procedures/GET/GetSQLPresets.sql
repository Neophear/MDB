CREATE PROCEDURE [dbo].[GetSQLPresets]
	@Role VARCHAR(10),
	@Username VARCHAR(8)
AS
	SELECT	*
	FROM	[SQLPresets]
	WHERE	@Role = 'Admin'
	OR		(@Role = 'Read' AND [VisibleToRead] = 1)
	OR		(@Role = 'Write' AND [VisibleToWrite] = 1)
	OR		[VisibleToUsers] LIKE CONCAT('%',@Username,'%')
RETURN 0