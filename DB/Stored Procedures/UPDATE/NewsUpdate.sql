CREATE PROCEDURE [dbo].[NewsUpdate]
	@Id INT,
	@Title NVARCHAR(50),
	@Content NVARCHAR(4000),
	@VisibleToRead BIT,
	@VisibleToWrite BIT,
	@Sticky BIT,
	@Executor NVARCHAR(8)
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF EXISTS(SELECT [Id] FROM [News] WHERE [Id] = @Id)
		BEGIN
			DECLARE @oldTitle NVARCHAR(50)
			DECLARE @oldContent NVARCHAR(4000)
			DECLARE @oldVisibleToRead BIT
			DECLARE @oldVisibleToWrite BIT
			DECLARE @oldSticky BIT
			DECLARE @Properties NVARCHAR(1000)
			DECLARE @Values NVARCHAR(MAX)

			SELECT @oldTitle = [Title], @oldContent = [Content], @oldVisibleToRead = [VisibleToRead], @oldVisibleToWrite = [VisibleToWrite], @oldSticky = [Sticky] FROM [News] WHERE [Id] = @Id

			--Update Title if changed
			IF @oldTitle <> @Title COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = 'Title'
				SET @Values = @Title
			END

			--Update Content if changed
			IF @oldContent <> @Content COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties,'|Content')
				SET @Values = CONCAT(@Values,'|',@Content)
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

			--Update Sticky if changed
			IF @oldSticky <> @Sticky
			BEGIN
				SET @Properties = CONCAT(@Properties,'|Sticky')
				SET @Values = CONCAT(@Values,'|',@Sticky)
			END

			--Update news and write to log if anything changed
			IF @Properties <> ''
			BEGIN
				UPDATE [News] SET [Title] = @Title, [Content] = @Content, [VisibleToRead] = @VisibleToRead, [VisibleToWrite] = @VisibleToWrite, [Sticky] = @Sticky WHERE [Id] = @Id
			
				SET @Properties = dbo.Trim(@Properties, '|')
				SET @Values = dbo.Trim(@Values, '|')

				EXEC dbo.WriteLog 2, @Executor, 8, @Id, @Properties, @Values
			END
		END
	END
RETURN 0