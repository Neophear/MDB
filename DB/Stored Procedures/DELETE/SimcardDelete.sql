CREATE PROCEDURE [dbo].[SimcardDelete]
	@Id INT,
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		DECLARE @Values NVARCHAR(200)

		SELECT @Values = [Simnumber] FROM [Simcards] WHERE [Id] = @Id
		DELETE FROM [Orders] WHERE [ObjectRefId] = @Id AND [ObjectTypeRefId] = 4
		DELETE FROM [Simcards] WHERE [Id] = @Id
		EXEC dbo.WriteLog 3, @Executor, 4, @Id, 'Simnumber', @Values
	END
RETURN 0