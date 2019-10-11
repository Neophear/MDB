CREATE PROCEDURE [dbo].[OrderApprove]
	@OrderId INT,
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1 AND (SELECT [Approved] FROM [Orders] WHERE [Id] = @OrderId) = 0
	BEGIN
		UPDATE [Orders] SET [Approved] = 1 WHERE [Id] = @OrderId
		EXEC dbo.WriteLog 2, @Executor, 5, @OrderId, 'Approved', '1'
	END
RETURN 0
