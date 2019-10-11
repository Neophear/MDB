CREATE PROCEDURE [dbo].[NewsInsert]
	@Title NVARCHAR(50),
	@Content NVARCHAR(4000),
	@VisibleToRead BIT,
	@VisibleToWrite BIT,
	@Sticky BIT,
	@Executor NVARCHAR(8),
	@LastId INT OUTPUT
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		INSERT INTO [News] ([Title], [Content], [VisibleToRead], [VisibleToWrite], [Sticky])
			VALUES(@Title, @Content, @VisibleToRead, @VisibleToWrite, @Sticky)

		DECLARE @Values NVARCHAR(MAX) = CONCAT(@Title,'|',@Content,'|',@VisibleToRead,'|',@VisibleToWrite,'|',@Sticky)
		SET @LastId = SCOPE_IDENTITY()
		EXEC dbo.WriteLog 1, @Executor, 8, @LastId, 'Title|Content|VisibleToRead|VisibleToWrite|Sticky', @Values
	END
RETURN 0