CREATE PROCEDURE [dbo].[SetOrderToStorage]
	@OrderId INT,
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		DECLARE @ObjectTypeId INT
		DECLARE @ObjectId INT
		DECLARE @CurrentStatus INT
		DECLARE @StatusStorageId INT

		SELECT @ObjectTypeId = [ObjectTypeRefId], @ObjectId = [ObjectRefId], @CurrentStatus = [StatusRefId] FROM [CurrentOrdersView] WHERE [OrderId] = @OrderId
		
		IF @ObjectId IS NOT NULL
		BEGIN
			SET @StatusStorageId = IIF(@ObjectTypeId = 3, 1, 7)
			EXEC dbo.OrderInsert @ObjectTypeId, @ObjectId, NULL, NULL, NULL, NULL, @StatusStorageId, NULL, @Executor
		END
	END
RETURN 0