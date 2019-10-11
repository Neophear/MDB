CREATE PROCEDURE [dbo].[GetUserLog]
	@DateFrom DATE = NULL,
	@DateTo DATE = NULL,
	@Executor VARCHAR(20) = null,
	@SearchTerm VARCHAR(50) = null
AS
	DECLARE @SearchWithWild VARCHAR(50) = ('%' + @SearchTerm + '%')
	SELECT TOP 200 * FROM [UserLogView] WHERE 
		(@DateFrom IS NULL OR CONVERT(DATE, [TimeStamp]) >= @DateFrom) AND
		(@DateTo IS NULL OR CONVERT(DATE, [TimeStamp]) <= @DateTo) AND
		(@Executor IS NULL OR [Executor] = @Executor) AND
		(@SearchTerm IS NULL OR [AffectedUsername] LIKE @SearchWithWild OR [Values] LIKE @SearchWithWild)
	ORDER BY [TimeStamp] DESC
RETURN 0