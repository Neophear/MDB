CREATE PROCEDURE [dbo].[GetFullName]
	@Username NVARCHAR(8),
	@Firstname NVARCHAR(100) OUTPUT,
	@Lastname NVARCHAR(50) OUTPUT
AS
	SELECT @Firstname = [Firstname], @Lastname = [Lastname] FROM [UserInfo] WHERE [Username] = @Username
RETURN 0
