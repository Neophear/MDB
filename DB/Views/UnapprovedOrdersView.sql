CREATE VIEW [dbo].[UnapprovedOrdersView]
	AS
SELECT		O.[OrderId],
			L.[TimeStamp],
			O.[ObjectNumber],
			O.[Info],
			O.[ObjectTypeRefId],
			O.[ObjectRefId],
			O.[EmployeeId],
			O.[MANR],
			O.[Stabsnummer],
			O.[Name],
			dbo.GetUserFull(L.[Executor]) AS [ExecutorFull],
			dbo.GetUserShort(L.[Executor]) AS [ExecutorShort]
FROM		[CurrentOrdersView] O
INNER JOIN	[Log] L ON L.Id = (
				SELECT		TOP 1 L2.Id
				FROM		[Log] L2
				WHERE		L2.ObjectRefId = [EmployeeId]
				AND			L2.ObjectTypeRefId = 2
				AND			L2.Properties LIKE '%Stabsnummer%'
				ORDER BY	L2.[TimeStamp] DESC)
WHERE		[Approved] = 0