CREATE PROCEDURE [dbo].[DataPlanInsert]
	@Name NVARCHAR(50),
	@Executor NVARCHAR(8),
	@Result INT OUTPUT
AS
	IF NOT EXISTS(SELECT [Id] FROM [DataPlans] WHERE [Name] = @Name)
	BEGIN
		DECLARE @Id INT

		INSERT INTO [DataPlans] ([Name]) VALUES (@Name)

		SET @Id = SCOPE_IDENTITY()
		EXEC dbo.WriteLog 1, @Executor, 7, @Id, 'Name', @Name
		SET @Result = 0
	END
	ELSE
		SET @Result = 1
RETURN 0
