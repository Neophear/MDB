CREATE PROCEDURE [dbo].[ImportDevice]
	@IMEI NVARCHAR(50),
	@Model NVARCHAR(50),
	@Provider NVARCHAR(50),
	@BuyDate DATE,
	@TypeRefId INT,
	@Notes NVARCHAR(1000),
	@MANR NVARCHAR(8),
	@Stabsnummer NVARCHAR(12),
	@Name NVARCHAR(100),
	@TaxTypeRefId INT,
	@StatusRefId INT
AS
	DECLARE @DeviceId INT = -1

	SELECT TOP 1 @DeviceId = [Id] FROM [Devices] WHERE [IMEI] = @IMEI
	IF @DeviceId = -1
		EXEC dbo.DeviceInsert @IMEI, @Model, @Provider, '', @BuyDate, 1, @TypeRefId, @Notes, '370929', @DeviceId OUTPUT, NULL, NULL

	IF NOT @MANR = ''
		EXEC dbo.OrderInsert 3, @DeviceId, @TaxTypeRefId, @MANR, @Stabsnummer, @Name, @StatusRefId, '', '370929'
RETURN 0