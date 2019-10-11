CREATE VIEW [dbo].[CommentsView]
	AS
SELECT
	C.Id,
	C.ObjectRefId,
	C.ObjectTypeRefId,
	C.[TimeStamp],
	C.Executor,
	C.[Text],
	(EUI.Firstname + ' ' + LEFT(EUI.Lastname, 1) + '.') AS ExecutorShort,
	(C.Executor + ' ' + EUI.Firstname + ' ' + EUI.Lastname) AS ExecutorFull
FROM
	[Comments] C
LEFT OUTER JOIN
	[UserInfo] EUI ON C.Executor = EUI.Username