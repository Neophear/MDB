CREATE PROCEDURE [dbo].[SQLPresetDelete]
	@Id INT,
	@Executor NVARCHAR(8)
AS
	IF EXISTS(SELECT TOP 1 [Id] FROM [SQLPresets] WHERE [Id] = @Id)
	BEGIN
		DECLARE @Name NVARCHAR(200) = (SELECT [Name] FROM [SQLPresets] WHERE [Id] = @Id)
		DELETE FROM [SQLPresets] WHERE [Id] = @Id
		EXEC dbo.WriteLog 3, @Executor, 11, @Id, 'Name', @Name
	END
RETURN 0
