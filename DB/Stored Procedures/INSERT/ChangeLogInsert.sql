CREATE PROCEDURE [dbo].[ChangeLogInsert]
	@Text NVARCHAR(1000),
	@VisibleToRead BIT,
	@VisibleToWrite BIT,
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		INSERT INTO [ChangeLog] ([Text], [VisibleToRead], [VisibleToWrite])
			VALUES(@Text, @VisibleToRead, @VisibleToWrite)

		DECLARE @Values NVARCHAR(MAX) = CONCAT(@Text,'|',@VisibleToRead,'|',@VisibleToWrite)
		DECLARE @LastId INT
		SET @LastId = SCOPE_IDENTITY()
		EXEC dbo.WriteLog 1, @Executor, 9, @LastId, 'Text|VisibleToRead|VisibleToWrite', @Values
	END
RETURN 0
