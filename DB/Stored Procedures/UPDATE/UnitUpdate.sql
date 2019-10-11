CREATE PROCEDURE [dbo].[UnitUpdate]
	@Id INT,
	@Short NVARCHAR(5),
	@Name NVARCHAR(100),
	@Executor NVARCHAR(8),
	@Result INT OUTPUT
AS
	IF EXISTS(SELECT [Id] FROM [Units] WHERE [Id] = @Id)
	BEGIN
		IF EXISTS(SELECT [Id] FROM [Units] WHERE [Short] = @Short AND [Id] <> @Id)
			SET @Result = 1
		ELSE IF EXISTS(SELECT [Id] FROM [Units] WHERE [Name] = @Name AND [Id] <> @Id)
			SET @Result = 2
		ELSE
		BEGIN
			DECLARE @oldShort NVARCHAR(5)
			DECLARE @oldName NVARCHAR(100)
			DECLARE @Properties VARCHAR(100)
			DECLARE @Values NVARCHAR(1000)

			SELECT @oldShort = [Short], @oldName = [Name] FROM [Units] WHERE [Id] = @Id

			--Update short
			IF @oldShort <> @Short COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = 'Short'
				SET @Values = @Short
			END

			--Update name
			IF @oldName <> @Name COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Name')
				SET @Values = CONCAT(@Values, '|', @Name)
			END

			--Write to log if anything changed
			IF @Properties <> ''
			BEGIN
				UPDATE [Units] SET [Short] = @Short, [Name] = @Name WHERE [Id] = @Id
			
				SET @Properties = dbo.Trim(@Properties, '|')
				SET @Values = dbo.Trim(@Values, '|')

				EXEC dbo.WriteLog 2, @Executor, 1, @Id, @Properties, @Values
			END

			SET @Result = 0
		END
	END
RETURN 0