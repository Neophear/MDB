CREATE PROCEDURE [dbo].[OrderInsert]
	@ObjectTypeRefId INT,
	@ObjectRefId INT,
	@TaxTypeRefId INT = NULL,
	@MANR NVARCHAR(8) = NULL,
	@Stabsnummer NVARCHAR(12) = NULL,
	@Name NVARCHAR(100) = NULL,
	@StatusRefId INT,
	@Notes NVARCHAR(1000) = null,
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF @TaxTypeRefId IS NULL OR EXISTS(SELECT TOP 1 [Name] FROM [TaxTypes] WHERE [Id] = @TaxTypeRefId)
		BEGIN
			DECLARE @EmployeeId INT = NULL

			IF @MANR IS NOT NULL
			BEGIN
				DECLARE @EmployeeNotes NVARCHAR(1000) = ''
				DECLARE @EmployeeSignedSolemnDeclaration BIT
				SELECT @EmployeeId = [Id], @EmployeeSignedSolemnDeclaration = [SignedSolemnDeclaration], @EmployeeNotes = [Notes] FROM [Employees] WHERE [MANR] = @MANR

				IF @EmployeeId IS NULL
					EXEC dbo.EmployeeInsert @MANR, @Stabsnummer, @Name, 0, @EmployeeNotes, @Executor, @EmployeeId OUTPUT
				ELSE
					EXEC dbo.EmployeeUpdate @EmployeeId, @MANR, @Stabsnummer, @Name, @EmployeeSignedSolemnDeclaration, @EmployeeNotes, @Executor
			END

			DECLARE @LastTaxTypeRefId INT
			DECLARE @LastEmployeeRefId INT
			DECLARE @LastStatusRefId INT
			DECLARE @LastNotes NVARCHAR(1000)


			SELECT TOP 1 @LastTaxTypeRefId = [TaxTypeRefId], @LastEmployeeRefId = [EmployeeRefId], @LastStatusRefId = [StatusRefId], @LastNotes = [Notes] FROM [Orders] WHERE [ObjectTypeRefId] = @ObjectTypeRefId AND [ObjectRefId] = @ObjectRefId ORDER BY [TimeStamp] DESC

			IF NOT (ISNULL(NULLIF(@TaxTypeRefId, @LastTaxTypeRefId),NULLIF(@LastTaxTypeRefId, @TaxTypeRefId)) IS NULL
				AND ISNULL(NULLIF(@EmployeeId, @LastEmployeeRefId),NULLIF(@LastEmployeeRefId,@EmployeeId)) IS NULL
				AND ISNULL(NULLIF(@StatusRefId,@LastStatusRefId),NULLIF(@LastStatusRefId,@StatusRefId)) IS NULL
				--AND (@Notes IS NULL OR @Notes = @LastNotes))
				AND ISNULL(NULLIF(@Notes,@LastNotes),NULLIF(@LastNotes,@Notes)) IS NULL)
			BEGIN
				INSERT INTO [Orders] ([ObjectTypeRefId], [ObjectRefId], [TaxTypeRefId], [EmployeeRefId], [StatusRefId], [Notes]) VALUES(@ObjectTypeRefId, @ObjectRefId, @TaxTypeRefId, @EmployeeId, @StatusRefId, @Notes)
				DECLARE @LastId INT = SCOPE_IDENTITY()
				EXEC dbo.WriteLog 1, @Executor, 5, @LastId
			END
		END
	END
RETURN 0