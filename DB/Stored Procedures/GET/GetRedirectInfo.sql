CREATE PROCEDURE [dbo].[GetRedirectInfo]
	@InputTypeId INT,
	@InputObjectId INT,
	@ObjectType INT OUTPUT,
	@ObjectId INT OUTPUT
AS
	IF @InputTypeId = 5
		SELECT @ObjectType = [ObjectTypeRefId], @ObjectId = [ObjectRefId] FROM [Orders] WHERE [Id] = @InputObjectId
	ELSE IF @InputTypeId = 10
		SELECT @ObjectType = [ObjectTypeRefId], @ObjectId = [ObjectRefId] FROM [Comments] WHERE [Id] = @InputObjectId
RETURN 0