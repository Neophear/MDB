CREATE PROCEDURE [dbo].[UserChangedPassword]
	@Username NVARCHAR(8),
	@Executor NVARCHAR(8),
	@Unlock BIT
AS
	DECLARE @Properties VARCHAR(50) = 'PasswordChanged'

	IF @Unlock = 1
	BEGIN
		EXEC dbo.aspnet_Membership_UnlockUser 'MDB', @Username
		SET @Properties = CONCAT(@Properties,'|Unlocked')
	END

	EXEC dbo.WriteLogUser 2, @Executor, @Username, @Properties
RETURN 0
