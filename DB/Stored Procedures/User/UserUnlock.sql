CREATE PROCEDURE [dbo].[UserUnlock]
	@Username NVARCHAR(8),
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		EXEC dbo.aspnet_Membership_UnlockUser 'MDB', @Username
		EXEC dbo.WriteLogUser 2, @Executor, @Username, 'Unlocked'
	END
RETURN 0