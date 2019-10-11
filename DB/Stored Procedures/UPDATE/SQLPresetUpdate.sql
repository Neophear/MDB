CREATE PROCEDURE [dbo].[SQLPresetUpdate]
	@Id INT,
	@Name NVARCHAR(50),
	@VisibleToRead BIT,
	@VisibleToWrite BIT,
	@VisibleToUsers VARCHAR(1000),
	@Description NVARCHAR(500),
	@Query NVARCHAR(4000),
	@Executor NVARCHAR(8),
	@Result INT OUTPUT
AS
	IF EXISTS(SELECT [Id] FROM [SQLPresets] WHERE [Id] = @Id)
	BEGIN
		IF EXISTS(SELECT [Id] FROM [SQLPresets] WHERE [Name] = @Name AND [Id] <> @Id)
			SET @Result = 1
		ELSE
		BEGIN
			DECLARE @oldName NVARCHAR(50)
			DECLARE @oldVisibleToRead BIT
			DECLARE @oldVisibleToWrite BIT
			DECLARE @oldVisibleToUsers NVARCHAR(1000)
			DECLARE @oldDescription NVARCHAR(500)
			DECLARE @oldQuery NVARCHAR(4000)
			DECLARE @Properties VARCHAR(1000)
			DECLARE @Values NVARCHAR(MAX)

			SELECT @oldName = [Name], @oldVisibleToRead = [VisibleToRead], @oldVisibleToWrite = [VisibleToWrite], @oldVisibleToUsers = [VisibleToUsers], @oldDescription = [Description], @oldQuery = [Query] FROM [SQLPresets] WHERE [Id] = @Id

			--Update Name
			IF @oldName <> @Name COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = 'Name'
				SET @Values = @Name
			END

			--Update VisibleToRead
			IF @oldVisibleToRead <> @VisibleToRead
			BEGIN
				SET @Properties = CONCAT(@Properties, '|VisibleToRead')
				SET @Values = CONCAT(@Values, '|', @VisibleToRead)
			END

			--Update VisibleToWrite
			IF @oldVisibleToWrite <> @VisibleToWrite
			BEGIN
				SET @Properties = CONCAT(@Properties, '|VisibleToWrite')
				SET @Values = CONCAT(@Values, '|', @VisibleToWrite)
			END

			--Update VisibleToUsers
			IF @oldVisibleToUsers <> @VisibleToUsers
			BEGIN
				SET @Properties = CONCAT(@Properties, '|VisibleToUsers')
				SET @Values = CONCAT(@Values, '|', @VisibleToUsers)
			END

			--Update Description
			IF @oldDescription <> @Description COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Description')
				SET @Values = CONCAT(@Values, '|', @Description)
			END
			
			--Update Query
			IF @oldQuery <> @Query COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Query')
				SET @Values = CONCAT(@Values, '|', @Query)
			END

			IF @Properties <> ''
			BEGIN
				UPDATE [SQLPresets] SET [Name] = @Name, [VisibleToRead] = @VisibleToRead, [VisibleToWrite] = @VisibleToWrite, [VisibleToUsers] = @VisibleToUsers, [Description] = @Description, [Query] = @Query WHERE [Id] = @Id

				SET @Properties = dbo.Trim(@Properties, '|')
				SET @Values = dbo.Trim(@Values, '|')

				EXEC dbo.WriteLog 2, @Executor, 11, @Id, @Properties, @Values
			END

			SET @Result = 0
		END
	END
RETURN 0
