CREATE FUNCTION [dbo].[CheckIfObjectExist]
(
	@searchQuery NVARCHAR(100),
	@objectType INT,
	@Id INT = NULL
)
RETURNS BIT
AS
BEGIN
	DECLARE @result BIT = 0
	
	IF @objectType = 1 AND EXISTS(SELECT TOP 1 [Id] FROM [Units] WHERE [Name] = @searchQuery AND (@Id IS NULL OR [Id] <> @Id))
		SET @result = 1
	ELSE IF @objectType = 2 AND EXISTS(SELECT TOP 1 [Id] FROM [Employees] WHERE [MANR] = @searchQuery AND (@Id IS NULL OR [Id] <> @Id))
		SET @result = 1
	ELSE IF @objectType = 3 AND EXISTS(SELECT TOP 1 [Id] FROM [Devices] WHERE [IMEI] = @searchQuery AND (@Id IS NULL OR [Id] <> @Id))
		SET @result = 1
	ELSE IF @objectType = 4 AND EXISTS(SELECT TOP 1 [Id] FROM [Simcards] WHERE [Simnumber] = @searchQuery AND (@Id IS NULL OR [Id] <> @Id))
		SET @result = 1
	ELSE IF @objectType = 11 AND EXISTS(SELECT TOP 1 [Id] FROM [SQLPresets] WHERE [Name] = @searchQuery AND (@Id IS NULL OR [Id] <> @Id))
		SET @result = 1

	RETURN @result
END