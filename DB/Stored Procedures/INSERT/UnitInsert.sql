CREATE PROCEDURE [dbo].[UnitInsert]
	@Short NVARCHAR(5),
	@Name NVARCHAR(100),
	@Executor NVARCHAR(8),
	@Result INT OUTPUT
AS
	IF NOT EXISTS(SELECT [Id] FROM [Units] WHERE [Short] = @Short)
	BEGIN
		DECLARE @Id INT
		DECLARE @Values NVARCHAR(200)

		INSERT INTO [Units] ([Short], [Name]) VALUES (@Short, @Name)

		SET @Id = SCOPE_IDENTITY()
		SET @Values = CONCAT(@Short,'|',@Name)
		EXEC dbo.WriteLog 1, @Executor, 1, @Id, 'Short|Name', @Values
		SET @Result = 0
	END
	ELSE
		SET @Result = 1
RETURN 0
