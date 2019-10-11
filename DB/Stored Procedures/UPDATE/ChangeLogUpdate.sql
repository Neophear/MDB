CREATE PROCEDURE [dbo].[ChangeLogUpdate]
	@Id INT,
	@Text NVARCHAR(1000),
	@VisibleToRead BIT,
	@VisibleToWrite BIT,
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF EXISTS(SELECT [Id] FROM [ChangeLog] WHERE [Id] = @Id)
		BEGIN
			DECLARE @oldText NVARCHAR(1000)
			DECLARE @oldVisibleToRead BIT
			DECLARE @oldVisibleToWrite BIT
			DECLARE @Properties NVARCHAR(1000)
			DECLARE @Values NVARCHAR(MAX)

			SELECT @oldText = [Text], @oldVisibleToRead = [VisibleToRead], @oldVisibleToWrite = [VisibleToWrite] FROM [ChangeLog]

			--Update Text if changed
			IF @oldText <> @Text COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties,'|Text')
				SET @Values = CONCAT(@Values,'|',@Text)
			END

			--Update VisibleToRead if changed
			IF @oldVisibleToRead <> @VisibleToRead
			BEGIN
				SET @Properties = CONCAT(@Properties,'|VisibleToRead')
				SET @Values = CONCAT(@Values,'|',@VisibleToRead)
			END

			--Update VisibleToWrite if changed
			IF @oldVisibleToWrite <> @VisibleToWrite
			BEGIN
				SET @Properties = CONCAT(@Properties,'|VisibleToWrite')
				SET @Values = CONCAT(@Values,'|',@VisibleToWrite)
			END

			--Update changelog and write to log if anything changed
			IF @Properties <> ''
			BEGIN
				UPDATE [ChangeLog] SET [Text] = @Text, [VisibleToRead] = @VisibleToRead, [VisibleToWrite] = @VisibleToWrite WHERE [Id] = @Id
			
				SET @Properties = dbo.Trim(@Properties, '|')
				SET @Values = dbo.Trim(@Values, '|')

				EXEC dbo.WriteLog 2, @Executor, 9, @Id, @Properties, @Values
			END
		END
	END
RETURN 0