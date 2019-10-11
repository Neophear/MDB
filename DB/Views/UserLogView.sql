CREATE VIEW [dbo].[UserLogView]
AS
SELECT
	LU.[TimeStamp],
	LU.Executor,
	(EUI.Firstname + ' ' + EUI.Lastname) AS ExecutorFullname,
	LU.AffectedUsername,
	(UI.Firstname + ' ' + UI.Lastname) AS AffectedFullname,
	LU.Properties,
	LU.[Values],
	A.Name AS [Action]
FROM
	[LogUser] LU
INNER JOIN
	[Actions] A ON LU.ActionRefId = A.Id
LEFT OUTER JOIN
	[UserInfo] UI ON LU.AffectedUsername = UI.Username
LEFT OUTER JOIN
	[UserInfo] EUI ON LU.Executor = EUI.Username