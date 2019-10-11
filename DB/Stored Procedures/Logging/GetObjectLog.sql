CREATE PROCEDURE [dbo].[GetObjectLog]
	@ObjectTypeId INT,
	@ObjectId INT
AS
	SELECT
		*
	FROM
		[LogView] LV
	WHERE
			((@ObjectTypeId IS NULL OR [ObjectTypeId] = @ObjectTypeId)
		AND
			(@ObjectId IS NULL OR [ObjectId] = @ObjectId))
	OR
		(LV.ObjectTypeId = 5 AND LV.ObjectId IN (SELECT O.Id FROM [Orders] O WHERE ((@ObjectTypeId = 2 AND O.EmployeeRefId = @ObjectId) OR (@ObjectTypeId = O.ObjectTypeRefId AND @ObjectId = O.ObjectRefId))))
	ORDER BY [TimeStamp] DESC, [Id] DESC
RETURN 0
