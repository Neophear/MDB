CREATE PROCEDURE [dbo].[ObjectExists]
	@UniqueIdentifier NVARCHAR(100),
	@ObjectType INT,
	@Exists BIT OUTPUT
AS
	SET @Exists = 0

	IF @ObjectType = 2
		SET @Exists = IIF(EXISTS(SELECT * FROM [Employees] WHERE [MANR] = @UniqueIdentifier), 1, 0)
	ELSE IF @ObjectType = 3
		SET @Exists = IIF(EXISTS(SELECT * FROM [Devices] WHERE [IMEI] = @UniqueIdentifier), 1, 0)
	ELSE IF @ObjectType = 4
		SET @Exists = IIF(EXISTS(SELECT * FROM [Simcards] WHERE [Simnumber] = @UniqueIdentifier), 1, 0)
RETURN 0