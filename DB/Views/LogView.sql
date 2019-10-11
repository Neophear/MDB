CREATE VIEW [dbo].[LogView]
AS
SELECT
	L.[Id],
	L.[TimeStamp],
	L.Executor,
	dbo.GetUserShort(L.Executor) AS ExecutorShort,
	dbo.GetUserFull(L.Executor) AS ExecutorFull,
	L.ObjectRefId AS ObjectId,
	L.ObjectTypeRefId AS ObjectTypeId,
	L.ActionRefId,
	OT.Name AS ObjectType,
	L.Properties,
	L.[Values],
	A.Name AS [Action]
FROM
	[Log] L
INNER JOIN
	[Actions] A ON L.ActionRefId = A.Id
INNER JOIN
	[ObjectTypes] OT ON L.ObjectTypeRefId = OT.Id
LEFT OUTER JOIN
	[UserInfo] EUI ON L.Executor = EUI.Username