CREATE PROCEDURE [dbo].[SimcardInsert]
	@Simnumber NVARCHAR(50),
	@PUK NVARCHAR(8),
	@Number NVARCHAR(8),
	@IsData BIT,
	@FormatRefId INT,
	@QuotaRefId INT,
	@QuotaEndDate DATE,
	@DataPlanRefId INT,
	@Provider NVARCHAR(50),
	@OrderNumber NVARCHAR(50),
	@BuyDate DATE,
	@UnitRefId INT,
	@Notes NVARCHAR(1000),
	@Executor NVARCHAR(8),
	@LastId INT OUTPUT,
	@Format NVARCHAR(50) = NULL OUTPUT,
	@Quota NVARCHAR(50) = NULL OUTPUT,
	@DataPlan NVARCHAR(50) = NULL OUTPUT,
	@Unit NVARCHAR(100) = NULL OUTPUT
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF NOT EXISTS(SELECT TOP 1 [Id] FROM [Simcards] WHERE [Simnumber] = @Simnumber)
		BEGIN
			IF @IsData IS NULL SET @IsData = 1
			INSERT INTO [Simcards] ([Simnumber], [PUK], [Number], [IsData], [FormatRefId], [QuotaRefId], [QuotaEndDate], [DataPlanRefId], [Provider], [OrderNumber], [BuyDate], [UnitRefId], [Notes])
				VALUES(@Simnumber, @PUK, @Number, @IsData, @FormatRefId, @QuotaRefId, @QuotaEndDate, @DataPlanRefId, @Provider, @OrderNumber, @BuyDate, @UnitRefId, @Notes)
			DECLARE @Values NVARCHAR(2000) = CONCAT(@Simnumber,'|',@PUK,'|',@Number,'|',@IsData,'|',@FormatRefId,'|',@QuotaRefId,'|',ISNULL(CONVERT(NVARCHAR(10), @QuotaEndDate), 'null'),'|',@DataPlanRefId,'|',@Provider,'|',@OrderNumber,'|',ISNULL(CONVERT(NVARCHAR(10), @BuyDate), 'null'),'|',@UnitRefId,'|',@Notes)
			SET @LastId = SCOPE_IDENTITY()
			SET @Format = (SELECT [Name] FROM [SimcardFormats] WHERE [Id] = @FormatRefId)
			SET @Quota = (SELECT [Name] FROM [Quotas] WHERE [Id] = @QuotaRefId)
			SET @DataPlan = (SELECT [Name] FROM [DataPlans] WHERE [Id] = @DataPlanRefId)
			SET @Unit = (SELECT [Name] FROM [Units] WHERE [Id] = @UnitRefId)
			EXEC dbo.WriteLog 1, @Executor, 4, @LastId, 'Simnumber|PUK|Number|IsData|FormatRefId|QuotaRefId||QuotaEndDate|DataPlanRefId|Provider|OrderNumber|BuyDate|UnitRefId|Notes', @Values
		END
	END
RETURN 0