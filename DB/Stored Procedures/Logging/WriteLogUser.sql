CREATE PROCEDURE [dbo].[WriteLogUser]
	@Action INT,
	@Executor NVARCHAR(8),
	@AffectedUsername NVARCHAR(8),
	@Properties VARCHAR(100) = NULL,
	@Values NVARCHAR(1000) = NULL
AS
	INSERT INTO [LogUser] ([ActionRefId], [Executor], [AffectedUsername], [Properties], [Values])
		VALUES(@Action, @Executor, @AffectedUsername, @Properties, @Values)
RETURN 0