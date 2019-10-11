CREATE PROCEDURE [dbo].[ImportSimcard]
	@Simnumber NVARCHAR(50),
	@PUK NVARCHAR(8),
	@Number NVARCHAR(8),
	@IsData BIT,
	@Provider NVARCHAR(50),
	@BuyDate DATE,
	@Notes NVARCHAR(1000),
	@MANR NVARCHAR(8),
	@Stabsnummer NVARCHAR(12),
	@Name NVARCHAR(100),
	@TaxTypeRefId INT,
	@StatusRefId INT
AS
	DECLARE @SimcardId INT = -1

	SELECT TOP 1 @SimcardId = [Id] FROM [Simcards] WHERE [Simnumber] = @Simnumber
	IF @SimcardId = -1
		EXEC dbo.SimcardInsert @Simnumber, @PUK, @Number, @IsData, 1, 1, null, 1, @Provider, '', @BuyDate, 1, @Notes, '370929', @SimcardId OUTPUT, NULL, NULL, NULL, NULL

	IF NOT @MANR = ''
		EXEC dbo.OrderInsert 4, @SimcardId, @TaxTypeRefId, @MANR, @Stabsnummer, @Name, @StatusRefId, '', '370929'
RETURN 0
