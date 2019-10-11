CREATE PROCEDURE [dbo].[UserInsert]
	@Username NVARCHAR(8),
	@Firstname NVARCHAR(100),
	@Lastname NVARCHAR(50),
	@UserType INT,
	@Executor NVARCHAR(8)
AS
	INSERT INTO [UserInfo] ([Username], [Firstname], [Lastname]) VALUES (@Username, @Firstname, @Lastname)
	DECLARE @GroupName VARCHAR(10) = (CASE @UserType WHEN 1 THEN 'Write' WHEN 2 THEN 'Admin' ELSE 'Read' END)

	DECLARE @Now DATETIME = getdate()
	EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles 'MDB', @Username, @GroupName, @Now

	DECLARE @Values NVARCHAR(200) = CONCAT(@Firstname,'|',@Lastname,'|',@GroupName)
	EXEC dbo.WriteLogUser 1, @Executor, @Username, 'Firstname|Lastname|UserType', @Values
RETURN 0