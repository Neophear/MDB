CREATE PROCEDURE [dbo].[InsertEmployeeIfNotExistFromSQL]
	@MANR VARCHAR(8),
	@Stabsnummer NVARCHAR(12),
	@Name NVARCHAR(100)
AS
	DECLARE @Id INT

	IF NOT EXISTS(SELECT [Id] FROM [Employees] WHERE [MANR] = @MANR)
		EXEC dbo.EmployeeInsert @MANR, @Stabsnummer, @Name, 0, '', '370929', @Id OUTPUT
RETURN 0