CREATE PROCEDURE [dbo].[GetChangeLog]
	@Role VARCHAR(10)
AS
	SELECT TOP 5 *, dbo.VisibleTo([VisibleToRead],[VisibleToWrite]) AS [VisibleTo] FROM [ChangeLog] WHERE (@Role = 'Read' AND [VisibleToRead] = 1) OR (@Role = 'Write' AND [VisibleToWrite] = 1) OR @Role = 'Admin' ORDER BY [TimeStamp] DESC
RETURN 0