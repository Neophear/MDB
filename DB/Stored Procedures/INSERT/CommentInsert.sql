CREATE PROCEDURE [dbo].[CommentInsert]
	@ObjectTypeRefId INT,
	@ObjectRefId INT,
	@Text NVARCHAR(MAX),
	@Executor NVARCHAR(8)
AS
	INSERT INTO [Comments] ([ObjectTypeRefId], [ObjectRefId], [Executor], [Text]) VALUES(@ObjectTypeRefId, @ObjectRefId, @Executor, @Text)
	DECLARE @LastId INT = SCOPE_IDENTITY()
	EXEC dbo.WriteLog 1, @Executor, 10, @LastId
RETURN 0