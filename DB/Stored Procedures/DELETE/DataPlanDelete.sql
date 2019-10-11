CREATE PROCEDURE [dbo].[DataPlanDelete]
	@Id INT,
	@Executor NVARCHAR(8),
	@Result INT OUTPUT
AS
	IF EXISTS(SELECT TOP 1 [Id] FROM [Simcards] WHERE [DataPlanRefId] = @Id)
		SET @Result = 2
	ELSE
	BEGIN
		DECLARE @Name NVARCHAR(200) = (SELECT [Name] FROM [DataPlans] WHERE [Id] = @Id)
		DELETE FROM [DataPlans] WHERE [Id] = @Id
		EXEC dbo.WriteLog 3, @Executor, 7, @Id, 'Name', @Name
		SET @Result = 0
	END
RETURN 0