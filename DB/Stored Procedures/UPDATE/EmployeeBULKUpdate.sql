CREATE PROCEDURE [dbo].[EmployeeBULKUpdate]
	@MANR NVARCHAR(8),
	@Stabsnummer NVARCHAR(12),
	@Exists BIT OUTPUT,
	@HasOrder BIT OUTPUT,
	@EmployeeId INT OUTPUT,
	@Executor NVARCHAR(8)
AS
	SET @Exists = 0
	SET @HasOrder = 0

	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF EXISTS(SELECT [Id] FROM [Employees] WHERE [MANR] = @MANR)
		BEGIN
			SET @Exists = 1
			SET @Stabsnummer = UPPER(@Stabsnummer)

			DECLARE @oldStabsnummer NVARCHAR(12)
			DECLARE @Properties VARCHAR(1000)
			DECLARE @Values NVARCHAR(2000)

			SELECT @EmployeeId = [Id], @oldStabsnummer = [Stabsnummer] FROM [Employees] WHERE [MANR] = @MANR

			--Set returnparameters
			IF EXISTS(SELECT [OrderId] FROM [CurrentOrdersView] WHERE [MANR] = @MANR)
				SET @HasOrder = 1

			--Update Stabsnummer
			IF @oldStabsnummer <> UPPER(@Stabsnummer)
			BEGIN
				SET @Properties = CONCAT(@Properties, 'Stabsnummer')
				SET @Values = CONCAT(@Values, UPPER(@Stabsnummer))

				UPDATE [Orders] SET [Approved] = 0 WHERE [Id] IN (SELECT [Id] FROM [CurrentOrdersView] WHERE [EmployeeRefId] = @EmployeeId)
			END

			--Update employee and write to log if anything changed
			IF @Properties <> ''
			BEGIN
				UPDATE [Employees] SET [Stabsnummer] = UPPER(@Stabsnummer) WHERE [Id] = @EmployeeId
			
				SET @Properties = @Properties
				SET @Values = @Values

				EXEC dbo.WriteLog 2, @Executor, 2, @EmployeeId, @Properties, @Values
			END
		END
	END
RETURN 0
