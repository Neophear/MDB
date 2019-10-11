CREATE PROCEDURE [dbo].[GetSQLPresetQuery]
	@Id INT,
	@Role VARCHAR(10),
	@Username VARCHAR(8),
	@Query NVARCHAR(4000) OUTPUT
AS
	SELECT	@Query = [Query]
	FROM	[SQLPresets]
	WHERE	[Id] = @Id
	AND		(@Role = 'Admin'
			OR		(@Role = 'Read' AND [VisibleToRead] = 1)
			OR		(@Role = 'Write' AND [VisibleToWrite] = 1)
			OR		[VisibleToUsers] LIKE CONCAT('%',@Username,'%'))
RETURN 0
