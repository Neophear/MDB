CREATE PROCEDURE [dbo].[CommentDelete]
	@Id INT,
	@Executor NVARCHAR(8)
AS
	DECLARE @IsAdmin BIT = 0
	EXEC @IsAdmin = dbo.[aspnet_UsersInRoles_IsUserInRole] 'MDB', @Executor, 'Admin'

	IF EXISTS(SELECT [Id] FROM [Comments] WHERE [Id] = @Id AND (@IsAdmin = 1 OR [Executor] = @Executor))
	BEGIN
		DECLARE @Text NVARCHAR(MAX) = (SELECT [Text] FROM [Comments] WHERE [Id] = @Id)
		DELETE FROM [Comments] WHERE [Id] = @Id
		EXEC dbo.WriteLog 3, @Executor, 10, @Id, 'Text', @Text
	END
RETURN 0