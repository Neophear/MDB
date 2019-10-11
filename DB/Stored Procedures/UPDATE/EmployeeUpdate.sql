CREATE PROCEDURE [dbo].[EmployeeUpdate]
	@Id INT,
	@MANR NVARCHAR(8),
	@Stabsnummer NVARCHAR(12),
	@Name NVARCHAR(100),
	@SignedSolemnDeclaration BIT,
	@Notes NVARCHAR(1000),
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF EXISTS(SELECT [Id] FROM [Employees] WHERE [Id] = @Id) AND NOT EXISTS(SELECT [Id] FROM [Employees] WHERE [MANR] = @MANR AND [Id] <> @Id)
		BEGIN
			DECLARE @oldMANR NVARCHAR(8)
			DECLARE @oldStabsnummer NVARCHAR(12)
			DECLARE @oldName NVARCHAR(100)
			DECLARE @oldSignedSolemnDeclaration BIT
			DECLARE @oldNotes NVARCHAR(1000)
			DECLARE @Properties VARCHAR(1000)
			DECLARE @Values NVARCHAR(2000)

			SELECT @oldMANR = [MANR], @oldStabsnummer = [Stabsnummer], @oldName = [Name], @oldSignedSolemnDeclaration = [SignedSolemnDeclaration], @oldNotes = [Notes] FROM [Employees] WHERE [Id] = @Id

			--Update MANR
			IF @oldMANR <> @MANR
			BEGIN
				SET @Properties = 'MANR'
				SET @Values = @MANR
			END

			--Update Stabsnummer
			IF @oldStabsnummer <> UPPER(@Stabsnummer)
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Stabsnummer')
				SET @Values = CONCAT(@Values, '|', UPPER(@Stabsnummer))

				UPDATE [Orders] SET [Approved] = 0 WHERE [Id] IN (SELECT [Id] FROM [CurrentOrdersView] WHERE [EmployeeRefId] = @Id)
			END

			--Update Name
			IF @oldName <> @Name COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Name')
				SET @Values = CONCAT(@Values, '|', @Name)
			END

			--Update SignedSolemnDeclaration
			IF @oldSignedSolemnDeclaration <> @SignedSolemnDeclaration
			BEGIN
				SET @Properties = CONCAT(@Properties, '|SignedSolemnDeclaration')
				SET @Values = CONCAT(@Values, '|', @SignedSolemnDeclaration)
			END

			--Update Notes
			IF @oldNotes <> @Notes COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Notes')
				SET @Values = CONCAT(@Values, '|', @Notes)
			END

			--Update employee and write to log if anything changed
			IF @Properties <> ''
			BEGIN
				UPDATE [Employees] SET [MANR] = @MANR, [Stabsnummer] = UPPER(@Stabsnummer), [Name] = @Name, [SignedSolemnDeclaration] = @SignedSolemnDeclaration, [Notes] = @Notes WHERE [Id] = @Id
			
				SET @Properties = dbo.Trim(@Properties, '|')
				SET @Values = dbo.Trim(@Values, '|')

				EXEC dbo.WriteLog 2, @Executor, 2, @Id, @Properties, @Values
			END
		END
	END
RETURN 0