CREATE PROCEDURE [dbo].[OrderInsertFromITMat]
	@IsDevice BIT, --Device = 1, SIMcard = 0
	@UniqueNumber NVARCHAR(50),
	@MANR NVARCHAR(8) = NULL,
	@Stabsnummer NVARCHAR(12) = NULL,
	@Name NVARCHAR(100) = NULL,
	@Executor NVARCHAR(8),
	@Successful BIT OUTPUT
AS
	SET @Successful = 0

	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		DECLARE @ObjectTypeRefId INT = IIF(@IsDevice = 1, 3, 4)
		DECLARE @ObjectRefId INT
		DECLARE @TaxTypeRefId INT = IIF(@MANR IS NULL, NULL, 4)

		IF @ObjectTypeRefId = 3
			SELECT @ObjectRefId = [Id] FROM [Devices] WHERE [IMEI] = @UniqueNumber
		ELSE
			SELECT @ObjectRefId = [Id] FROM [Simcards] WHERE [Simnumber] = @UniqueNumber

		IF @ObjectRefId IS NOT NULL
		BEGIN
			DECLARE @EmployeeId INT = NULL

			IF @MANR IS NOT NULL
			BEGIN
				DECLARE @EmployeeNotes NVARCHAR(1000) = ''
				DECLARE @EmployeeSignedSolemnDeclaration BIT
				SELECT @EmployeeId = [Id], @EmployeeSignedSolemnDeclaration = [SignedSolemnDeclaration], @EmployeeNotes = [Notes] FROM [Employees] WHERE [MANR] = @MANR

				IF @EmployeeId IS NULL
					EXEC dbo.EmployeeInsert @MANR, @Stabsnummer, @Name, 0, 'ITMat', @Executor, @EmployeeId OUTPUT
				ELSE
					EXEC dbo.EmployeeUpdate @EmployeeId, @MANR, @Stabsnummer, @Name, @EmployeeSignedSolemnDeclaration, @EmployeeNotes, @Executor
			END
			
			DECLARE @StatusRefId INT = IIF(@ObjectTypeRefId = 3, IIF(@MANR IS NULL, 1, 4), IIF(@MANR IS NULL, 7, 9))

			EXEC dbo.OrderInsert @ObjectTypeRefId, @ObjectRefId, @TaxTypeRefId, @MANR, @Stabsnummer, @Name, @StatusRefId, 'ITMat', @Executor
			SET @Successful = 1
		END
	END
RETURN 0