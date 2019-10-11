CREATE PROCEDURE [dbo].[EmployeeInsert]
	@MANR NVARCHAR(8),
	@Stabsnummer NVARCHAR(12),
	@Name NVARCHAR(100),
	@SignedSolemnDeclaration BIT,
	@Notes NVARCHAR(1000),
	@Executor NVARCHAR(8),
	@LastId INT OUTPUT
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF NOT EXISTS(SELECT TOP 1 [Id] FROM [Employees] WHERE [MANR] = @MANR)
		BEGIN
			INSERT INTO [Employees] ([MANR], [Stabsnummer], [Name], [SignedSolemnDeclaration], [Notes])
				VALUES(@MANR, UPPER(@Stabsnummer), @Name, @SignedSolemnDeclaration, @Notes)
			DECLARE @Values NVARCHAR(2000) = CONCAT(@MANR,'|',UPPER(@Stabsnummer),'|',@Name,'|',@SignedSolemnDeclaration,'|',@Notes)
			SET @LastId = SCOPE_IDENTITY()
			EXEC dbo.WriteLog 1, @Executor, 2, @LastId, 'MANR|Stabsnummer|Name|SignedSolemnDeclaration|Notes', @Values
		END
	END
RETURN 0