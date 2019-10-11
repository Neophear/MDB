CREATE PROCEDURE [dbo].[SimcardUpdate]
	@Id INT,
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
	@Format NVARCHAR(50) = NULL OUTPUT,
	@Quota NVARCHAR(50) = NULL OUTPUT,
	@DataPlan NVARCHAR(50) = NULL OUTPUT,
	@Unit NVARCHAR(100) = NULL OUTPUT
AS
	DECLARE @CanUserWrite BIT
	EXEC @CanUserWrite = dbo.CanUserWrite @Executor
	IF @CanUserWrite = 1
	BEGIN
		IF EXISTS(SELECT [Id] FROM [Simcards] WHERE [Id] = @Id) AND NOT EXISTS(SELECT [Id] FROM [Simcards] WHERE [Simnumber] = @Simnumber AND [Id] <> @Id)
		BEGIN
			DECLARE @oldSimnumber NVARCHAR(50)
			DECLARE @oldPUK NVARCHAR(50)
			DECLARE @oldNumber NVARCHAR(50)
			DECLARE @oldIsData BIT
			DECLARE @oldFormatRefId INT
			DECLARE @oldQuotaRefId INT
			DECLARE @oldQuotaEndDate DATE
			DECLARE @oldDataPlanRefId INT
			DECLARE @oldProvider NVARCHAR(50)
			DECLARE @oldOrderNumber NVARCHAR(50)
			DECLARE @oldBuyDate DATE
			DECLARE @oldUnitRefId INT
			DECLARE @oldNotes NVARCHAR(1000)
			DECLARE @Properties VARCHAR(1000)
			DECLARE @Values NVARCHAR(2000)

			SELECT	@oldSimnumber = [Simnumber],
					@oldPUK = [PUK],
					@oldNumber = [Number],
					@oldIsData = [IsData],
					@oldFormatRefId = [FormatRefId],
					@oldQuotaRefId = [QuotaRefId],
					@oldQuotaEndDate = [QuotaEndDate],
					@oldDataPlanRefId = [DataPlanRefId],
					@oldProvider = [Provider],
					@oldOrderNumber = [OrderNumber],
					@oldBuyDate = [BuyDate],
					@oldUnitRefId = [UnitRefId],
					@oldNotes = [Notes]
			FROM	[Simcards]
			WHERE	[Id] = @Id

			SET @IsData = @oldIsData

			--Update Simnumber
			IF @oldSimnumber <> @Simnumber
			BEGIN
				SET @Properties = 'Simnumber'
				SET @Values = @Simnumber
			END

			--Update PUK
			IF @oldPUK <> @PUK
			BEGIN
				SET @Properties = CONCAT(@Properties, '|PUK')
				SET @Values = CONCAT(@Values, '|', @PUK)
			END
		
			--Update Number
			IF @oldNumber <> @Number
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Number')
				SET @Values = CONCAT(@Values, '|', @Number)
			END
		
			--Update IsData
			IF @oldIsData <> @IsData
			BEGIN
				SET @Properties = CONCAT(@Properties, '|IsData')
				SET @Values = CONCAT(@Values, '|', @IsData)
			END

			--Update FormatRefId
			IF @oldFormatRefId <> @FormatRefId
			BEGIN
				SET @Properties = CONCAT(@Properties, '|FormatRefId')
				SET @Values = CONCAT(@Values, '|', @FormatRefId)
			END
		
			--Update QuotaRefId
			IF @oldQuotaRefId <> @QuotaRefId
			BEGIN
				SET @Properties = CONCAT(@Properties, '|QuotaRefId')
				SET @Values = CONCAT(@Values, '|', @QuotaRefId)
			END
		
			--Update QuotaEndDate
			IF @oldQuotaEndDate <> @QuotaEndDate OR (@oldQuotaEndDate IS NULL AND @QuotaEndDate IS NOT NULL) OR (@oldQuotaEndDate IS NOT NULL AND @QuotaEndDate IS NULL)
			BEGIN
				SET @Properties = CONCAT(@Properties, '|QuotaEndDate')
				SET @Values = CONCAT(@Values, '|', @QuotaEndDate)
			END
		
			--Update DataPlanRefId
			IF @oldDataPlanRefId <> @DataPlanRefId
			BEGIN
				SET @Properties = CONCAT(@Properties, '|DataPlanRefId')
				SET @Values = CONCAT(@Values, '|', @DataPlanRefId)
			END

			--Update Provider
			IF @oldProvider <> @Provider COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Provider')
				SET @Values = CONCAT(@Values, '|', @Provider)
			END

			--Update OrderNumber
			IF @oldOrderNumber <> @OrderNumber
			BEGIN
				SET @Properties = CONCAT(@Properties, '|OrderNumber')
				SET @Values = CONCAT(@Values, '|', @OrderNumber)
			END

			--Update BuyTime
			IF @oldBuyDate <> @BuyDate OR (@oldBuyDate IS NULL AND @BuyDate IS NOT NULL) OR (@oldBuyDate IS NOT NULL AND @BuyDate IS NULL)
			BEGIN
				SET @Properties = CONCAT(@Properties, '|BuyDate')
				SET @Values = CONCAT(@Values, '|', ISNULL(CONVERT(NVARCHAR(10), @BuyDate), 'null'))
			END

			--Update UnitRefId
			IF @oldUnitRefId <> @UnitRefId
			BEGIN
				SET @Properties = CONCAT(@Properties, '|UnitRefId')
				SET @Values = CONCAT(@Values, '|', @UnitRefId)
			END

			--Update Notes
			IF @oldNotes <> @Notes COLLATE Latin1_General_CS_AS
			BEGIN
				SET @Properties = CONCAT(@Properties, '|Notes')
				SET @Values = CONCAT(@Values, '|', @Notes)
			END

			--Update device and write to log if anything changed
			IF @Properties <> ''
			BEGIN
				UPDATE	[Simcards]
				SET		[Simnumber] = @Simnumber,
						[PUK] = @PUK,
						[Number] = @Number,
						[IsData] = @IsData,
						[FormatRefId] = @FormatRefId,
						[QuotaRefId] = @QuotaRefId,
						[QuotaEndDate] = @QuotaEndDate,
						[DataPlanRefId] = @DataPlanRefId,
						[Provider] = @Provider,
						[OrderNumber] = @OrderNumber,
						[BuyDate] = @BuyDate,
						[UnitRefId] = @UnitRefId,
						[Notes] = @Notes
				WHERE	[Id] = @Id
				
				SET @Format = (SELECT [Name] FROM [SimcardFormats] WHERE [Id] = @FormatRefId)
				SET @Quota = (SELECT [Name] FROM [Quotas] WHERE [Id] = @QuotaRefId)
				SET @DataPlan = (SELECT [Name] FROM [DataPlans] WHERE [Id] = @DataPlanRefId)
				SET @Unit = (SELECT [Name] FROM [Units] WHERE [Id] = @UnitRefId)

				SET @Properties = dbo.Trim(@Properties, '|')
				SET @Values = dbo.Trim(@Values, '|')

				EXEC dbo.WriteLog 2, @Executor, 4, @Id, @Properties, @Values
			END
		END
	END
RETURN 0