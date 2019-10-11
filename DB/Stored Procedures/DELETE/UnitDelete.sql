CREATE PROCEDURE [dbo].[UnitDelete]
	@Id INT,
	@Executor NVARCHAR(8),
	@Result INT OUTPUT
AS
	IF EXISTS(SELECT TOP 1 [Id] FROM [Devices] WHERE [UnitRefId] = @Id) OR EXISTS(SELECT TOP 1 [Id] FROM [Simcards] WHERE [UnitRefId] = @Id)
		SET @Result = 2
	ELSE
	BEGIN
		DECLARE @Values NVARCHAR(200)

		SELECT @Values = CONCAT([Short], '|', [Name]) FROM [Units] WHERE [Id] = @Id
		DELETE FROM [Units] WHERE [Id] = @Id
		EXEC dbo.WriteLog 3, @Executor, 1, @Id, 'Short|Name', @Values
		SET @Result = 0
	END
RETURN 0