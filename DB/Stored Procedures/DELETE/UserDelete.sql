CREATE PROCEDURE [dbo].[UserDelete]
	@Username NVARCHAR(8),
	@Executor NVARCHAR(8)
AS
	EXEC dbo.aspnet_Users_DeleteUser 'MDB', @Username, 15, 0
	DELETE FROM [UserInfo] WHERE [Username] = @Username

	EXEC dbo.WriteLogUser 3, @Executor, @Username
RETURN 0
