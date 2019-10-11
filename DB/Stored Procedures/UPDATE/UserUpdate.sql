CREATE PROCEDURE [dbo].[UserUpdate]
	@Username NVARCHAR(8),
	@Firstname VARCHAR(100),
	@Lastname NVARCHAR(50),
	@UserType INT,
	@Enabled BIT,
	@Unlock BIT,
	@PasswordReset BIT,
	@Executor NVARCHAR(8)
AS
	DECLARE @oldFirstname NVARCHAR(100)
	DECLARE @oldLastname NVARCHAR(50)
	DECLARE @oldEnabled BIT
	DECLARE @Properties VARCHAR(100)
	DECLARE @Values NVARCHAR(1000)

	SELECT @oldFirstname = [Firstname], @oldLastname = [Lastname] FROM [UserInfo] WHERE [Username] = @Username

	--Update firstname
	IF @oldFirstname <> @Firstname COLLATE Latin1_General_CS_AS
	BEGIN
		SET @Properties = CONCAT(@Properties, '|Firstname')
		SET @Values = CONCAT(@Values, '|', @Firstname)
	END

	--Update lastname
	IF @oldLastname <> @Lastname COLLATE Latin1_General_CS_AS
	BEGIN
		SET @Properties = CONCAT(@Properties, '|Lastname')
		SET @Values = CONCAT(@Values, '|', @Lastname)
	END

	--Change type
	DECLARE @Now datetime = getdate()
	DECLARE @GroupName VARCHAR(10) = (CASE @UserType WHEN 1 THEN 'Write' WHEN 2 THEN 'Admin' ELSE 'Read' END)
	DECLARE @AddGroupResult INT

	EXEC @AddGroupResult = dbo.aspnet_UsersInRoles_AddUsersToRoles 'MDB', @Username, @GroupName, @Now

	IF @AddGroupResult = 0
	BEGIN
		SET @Properties = CONCAT(@Properties, '|UserType')
		SET @Values = CONCAT(@Values, '|', @GroupName)
	END

	--Remove user from excess groups
	IF @UserType <> 0 EXEC dbo.aspnet_UsersInRoles_RemoveUsersFromRoles 'MDB', @Username, 'Read'
	IF @UserType <> 1 EXEC dbo.aspnet_UsersInRoles_RemoveUsersFromRoles 'MDB', @Username, 'Write'
	IF @UserType <> 2 EXEC dbo.aspnet_UsersInRoles_RemoveUsersFromRoles 'MDB', @Username, 'Admin'

	--Change Enabled
	DECLARE @UserId UNIQUEIDENTIFIER
	SELECT	@oldEnabled = [IsApproved],
			@UserId = m.UserId
	FROM	dbo.aspnet_Applications a, dbo.aspnet_Users u WITH ( UPDLOCK, ROWLOCK ), dbo.aspnet_Membership m WITH ( UPDLOCK, ROWLOCK )
	WHERE	LOWER('MDB') = a.LoweredApplicationName AND
			u.ApplicationId = a.ApplicationId AND
			u.UserId = m.UserId AND
			LOWER(@Username) = u.LoweredUserName
	
	IF @oldEnabled <> @Enabled
	BEGIN
		UPDATE dbo.aspnet_Membership SET [IsApproved] = @Enabled WHERE [UserId] = @UserId
		SET @Properties = CONCAT(@Properties, '|Enabled')
		SET @Values = CONCAT(@Values, '|', @Enabled)
	END

	--Unlock
	IF @Unlock = 1
	BEGIN
		EXEC dbo.aspnet_Membership_UnlockUser 'MDB', @Username
		SET @Properties = CONCAT(@Properties, '|Unlock')
		SET @Values = CONCAT(@Values, '|True')
	END

	--Was password reset
	IF @PasswordReset = 1
	BEGIN
		SET @Properties = CONCAT(@Properties, '|PasswordReset')
		SET @Values = CONCAT(@Values, '|', 'True')
	END

	--Write to log if anything changed
	IF @Properties <> ''
	BEGIN
		UPDATE [UserInfo] SET [Firstname] = ISNULL(@Firstname, [Firstname]), [Lastname] = ISNULL(@Lastname, [Lastname]) WHERE [Username] = @Username
	
		IF @@ROWCOUNT = 0
			INSERT INTO [UserInfo] ([Username], [Firstname], [Lastname]) VALUES(@Username, ISNULL(@Firstname, ''), ISNULL(@Lastname, ''))
	
		SET @Properties = dbo.Trim(@Properties, '|')
		SET @Values = dbo.Trim(@Values, '|')

		EXEC dbo.WriteLogUser 2, @Executor, @Username, @Properties, @Values
	END
RETURN 0