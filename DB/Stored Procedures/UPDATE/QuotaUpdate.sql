CREATE PROCEDURE [dbo].[QuotaUpdate]
	@Id INT,
	@Name NVARCHAR(50),
	@Executor NVARCHAR(8),
	@Result INT OUTPUT
AS
	IF EXISTS(SELECT [Id] FROM [Quotas] WHERE [Id] = @Id)
	BEGIN
		IF EXISTS(SELECT [Id] FROM [Quotas] WHERE [Name] = @Name AND [Id] <> @Id)
			SET @Result = 1
		ELSE
		BEGIN
			DECLARE @oldName NVARCHAR(50) = (SELECT [Name] FROM [Quotas] WHERE [Id] = @Id)

			--Update name if changed
			IF @oldName <> @Name COLLATE Latin1_General_CS_AS
			BEGIN
				UPDATE [Quotas] SET [Name] = @Name WHERE [Id] = @Id
				EXEC dbo.WriteLog 2, @Executor, 6, @Id, 'Name', @Name
			END

			SET @Result = 0
		END
	END
RETURN 0