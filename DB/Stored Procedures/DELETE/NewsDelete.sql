CREATE PROCEDURE [dbo].[NewsDelete]
	@Id INT,
	@Executor NVARCHAR(8)
AS
	IF EXISTS(SELECT TOP 1 [Id] FROM [News] WHERE [Id] = @Id)
	BEGIN
		DECLARE @Title NVARCHAR(200) = (SELECT [Title] FROM [News] WHERE [Id] = @Id)
		DELETE FROM [News] WHERE [Id] = @Id
		EXEC dbo.WriteLog 3, @Executor, 8, @Id, 'Title', @Title
	END
RETURN 0