CREATE PROCEDURE [dbo].[CanUserWrite]
	@User NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT = 0
	EXEC @CanUserWrite = dbo.[aspnet_UsersInRoles_IsUserInRole] 'MDB', @User, 'Write'
	
	IF @CanUserWrite = 0
		EXEC @CanUserWrite = dbo.[aspnet_UsersInRoles_IsUserInRole] 'MDB', @User, 'Admin'

	RETURN @CanUserWrite
RETURN 0