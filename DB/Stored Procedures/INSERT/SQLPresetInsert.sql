CREATE PROCEDURE [dbo].[SQLPresetInsert]
	@Name NVARCHAR(50),
	@VisibleToRead BIT,
	@VisibleToWrite BIT,
	@VisibleToUsers VARCHAR(1000),
	@Description NVARCHAR(500),
	@Query NVARCHAR(4000),
	@Executor NVARCHAR(8),
	@Result INT OUTPUT
AS
	IF NOT EXISTS(SELECT [Id] FROM [SQLPresets] WHERE [Name] = @Name)
	BEGIN
		DECLARE @Id INT

		INSERT INTO [SQLPresets] ([Name], [VisibleToRead], [VisibleToWrite], [VisibleToUsers], [Description], [Query]) VALUES (@Name, @VisibleToRead, @VisibleToWrite, @VisibleToUsers, @Description, @Query)

		SET @Id = SCOPE_IDENTITY()
		DECLARE @Values NVARCHAR(MAX) = CONCAT(@Name,'|',@VisibleToRead,'|',@VisibleToWrite,'|',@VisibleToUsers,'|',@Description,'|',@Query)
		EXEC dbo.WriteLog 1, @Executor, 11, @Id, 'Name|VisibleToRead|VisibleToWrite|VisibleToUsers|Description|Query', @Values
		SET @Result = 0
	END
	ELSE
		SET @Result = 1
RETURN 0