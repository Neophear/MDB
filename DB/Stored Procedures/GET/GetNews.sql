CREATE PROCEDURE [dbo].[GetNews]
	@Role VARCHAR(10)
AS
	SELECT *, dbo.VisibleTo([VisibleToRead],[VisibleToWrite]) AS [VisibleTo] FROM [News] WHERE (@Role = 'Read' AND [VisibleToRead] = 1) OR (@Role = 'Write' AND [VisibleToWrite] = 1) OR @Role = 'Admin' ORDER BY [Sticky] DESC, [TimeStamp] DESC
RETURN 0