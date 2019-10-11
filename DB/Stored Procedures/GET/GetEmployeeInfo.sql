CREATE PROCEDURE [dbo].[GetEmployeeInfo]
	@MANR VARCHAR(8),
	@Stabsnummer NVARCHAR(20) OUTPUT,
	@Name NVARCHAR(100) OUTPUT
AS
	SELECT @Stabsnummer = [Stabsnummer], @Name = [Name] FROM [Employees] WHERE [MANR] = @MANR
RETURN 0