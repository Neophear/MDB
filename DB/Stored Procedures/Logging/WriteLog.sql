CREATE PROCEDURE [dbo].[WriteLog]
	@Action INT,
	@Executor NVARCHAR(8),
	@ObjectType INT,
	@ObjectId INT,
	@Properties VARCHAR(200) = NULL,
	@Values NVARCHAR(2000) = NULL
AS
	INSERT INTO [Log] ([ActionRefId], [Executor], [ObjectTypeRefId], [ObjectRefId], [Properties], [Values])
		VALUES(@Action, @Executor, @ObjectType, @ObjectId, @Properties, @Values)
RETURN 0