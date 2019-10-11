CREATE PROCEDURE [dbo].[SetEmployeeSignedSolemnDeclaration]
	@EmployeeId INT,
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF EXISTS(SELECT TOP 1 [SignedSolemnDeclaration] FROM [Employees] WHERE [Id] = @EmployeeId AND [SignedSolemnDeclaration] = 0)
		BEGIN
			UPDATE [Employees] SET [SignedSolemnDeclaration] = 1 WHERE [Id] = @EmployeeId
			EXEC dbo.WriteLog 2, @Executor, 2, @EmployeeId, 'SignedSolemnDeclaration', '1'
		END
	END
RETURN 0