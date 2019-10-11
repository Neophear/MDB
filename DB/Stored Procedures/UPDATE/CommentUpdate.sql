CREATE PROCEDURE [dbo].[CommentUpdate]
	@Id INT,
	@Text NVARCHAR(MAX),
	@Executor NVARCHAR(8),
	@Result INT OUTPUT
AS
	IF EXISTS(SELECT [Id] FROM [Comments] WHERE [Id] = @Id AND [Executor] = @Executor)
	BEGIN
		IF (SELECT [Text] FROM [Comments] WHERE [Id] = @Id) <> @Text COLLATE Latin1_General_CS_AS
		BEGIN
			UPDATE [Comments] SET [Text] = @Text WHERE [Id] = @Id
			EXEC dbo.WriteLog 2, @Executor, 10, @Id, 'Text', @Text
		END

		SET @Result = 0
	END
RETURN 0