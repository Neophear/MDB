CREATE PROCEDURE [dbo].[DeviceDelete]
	@Id INT,
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		DECLARE @Values NVARCHAR(200)

		SELECT @Values = [IMEI] FROM [Devices] WHERE [Id] = @Id
		DELETE FROM [Orders] WHERE [ObjectRefId] = @Id AND [ObjectTypeRefId] = 3
		DELETE FROM [Devices] WHERE [Id] = @Id
		EXEC dbo.WriteLog 3, @Executor, 3, @Id, 'IMEI', @Values
	END
RETURN 0