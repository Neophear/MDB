CREATE PROCEDURE [dbo].[EmployeeDelete]
	@Id INT,
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF NOT EXISTS(SELECT * FROM [CurrentOrdersView] WHERE [EmployeeId] = @Id)
		BEGIN
			DECLARE @Values NVARCHAR(200)

			SELECT @Values = [MANR] FROM [Employees] WHERE [Id] = @Id
			DELETE FROM [Employees] WHERE [Id] = @Id
			EXEC dbo.WriteLog 3, @Executor, 2, @Id, 'MANR', @Values
		END
	END
RETURN 0
