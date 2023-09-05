"""
    ColType

The definition of the column type conversion.

# Fields
- `name::Symbol`: The column name.
- `original::Union{DataType,Union}`: The original type of the column.
- `target::Union{DataType,Union}`: The target type of the column.
- `convert::Union{Function,Nothing}`: The function to convert the column to the target type.

"""
struct ColType
    name::Symbol
    original::Union{DataType,Union}
    target::Union{DataType,Union}
    convert::Union{Function,Nothing}
end

ColType(name, original, target) = ColType(name, original, target, nothing)

"""
    DataScheme

The definition of the data scheme.
"""
const DataScheme = Vector{ColType}

const NULL_STR = ["", "－"]

"""
    convert(scheme::DataScheme, df::DataFrame)

Convert the DataFrame's columns to the target types defined in `scheme`.

# Arguments
- `scheme::DataScheme`: The data scheme of the DataFrame.
- `df::DataFrame`: The DataFrame to be converted.

# Returns
- `df_conv::DataFrame`: The converted DataFrame.
"""
function Base.convert(scheme::DataScheme, df)
    df_conv = copy(df)
    isempty(df) && return df_conv  # Return empty DataFrame if the input DataFrame is empty

    for coltype in scheme
        string(coltype.name) ∈ names(df_conv) || continue  # Skip if the column is not in the DataFrame

        if coltype.original != coltype.target

            # Convert Nothing to Missing
            if coltype.original >: Nothing && coltype.target >: Missing
                df_conv[!, coltype.name] = map(x -> isnothing(x) ? missing : x, df_conv[!, coltype.name])
            end

            # Replace null strings to missing
            if coltype.original <: AbstractString && coltype.target >: Missing
                allowmissing!(df_conv, coltype.name)
                replace!(x -> x ∈ NULL_STR ? missing : x, df_conv[!, coltype.name])
            end

            # Skip if the column is already converted
            Base.nonnothingtype(coltype.original) == Base.nonmissingtype(coltype.target) && continue

            # Convert the column to the target type
            if isnothing(coltype.convert)
                if Base.nonmissingtype(coltype.target) <: Number
                    df_conv[!, coltype.name] = map(x -> ismissing(x) ? x : parse(Base.nonmissingtype(coltype.target), x), df_conv[!, coltype.name])
                else
                    df_conv[!, coltype.name] = map(x -> ismissing(x) ? x : Base.nonmissingtype(coltype.target)(x), df_conv[!, coltype.name])
                end
            else
                df_conv[!, coltype.name] = map(x -> ismissing(x) ? missing : (coltype.convert)(Base.nonmissingtype(coltype.target), x), df_conv[!, coltype.name])
            end
        end
    end

    return df_conv
end

str2bool(::DataType, x) = x == "true"
ymd(::DataType, x) = Date(x, "YYYYmmdd")


"""
    datascheme(api::API)

Return the data scheme of the API.
"""
function datascheme(api::API)
    type = typeof(api)
    error("The function `datascheme` for the type $(type) is not implemented")
end

function datascheme(::ListedInfo)
    DataScheme([
        ColType(:Date, String, Date),
        ColType(:Code, String, String),
        ColType(:CompanyName, String, String),
        ColType(:CompanyNameEnglish, String, String),
        ColType(:Sector17Code, String, String),
        ColType(:Sector17CodeName, String, String),
        ColType(:Sector33Code, String, String),
        ColType(:Sector33CodeName, String, String),
        ColType(:ScaleCategory, String, String),
        ColType(:MarketCode, String, String),
        ColType(:MarketCodeName, String, String),
        ColType(:MarginCode, String, String),
        ColType(:MarginCodeName, String, String),
    ])
end

function datascheme(::PricesDailyQuotes)
    DataScheme([
        ColType(:Date, String, Date),
        ColType(:Code, String, String),
        ColType(:Open, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:High, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:Low, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:Close, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:UpperLimit, String, String),
        ColType(:LowerLimit, String, String),
        ColType(:Volume, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:TurnoverValue, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AdjustmentFactor, Float64, Float64),
        ColType(:AdjustmentOpen, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AdjustmentHigh, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AdjustmentLow, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AdjustmentClose, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AdjustmentVolume, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningOpen, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningHigh, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningLow, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningClose, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningUpperLimit, String, String),
        ColType(:MorningLowerLimit, String, String),
        ColType(:MorningVolume, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningTurnoverValue, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningAdjustmentFactor, Float64, Float64),
        ColType(:MorningAdjustmentOpen, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningAdjustmentHigh, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningAdjustmentLow, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningAdjustmentClose, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningAdjustmentVolume, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AfternoonOpen, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AfternoonHigh, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AfternoonLow, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AfternoonClose, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AfternoonVolume, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AfternoonUpperLimit, String, String),
        ColType(:AfternoonLowerLimit, String, String),
        ColType(:AfternoonTurnoverValue, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AfternoonAdjustmentFactor, Float64, Float64),
        ColType(:AfternoonAdjustmentOpen, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AfternoonAdjustmentHigh, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AfternoonAdjustmentLow, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AfternoonAdjustmentClose, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:AfternoonAdjustmentVolume, Union{Nothing,Float64}, Union{Float64,Missing}),
    ])
end

function datascheme(::PricesAM)
    DataScheme([
        ColType(:Date, String, Date),
        ColType(:Code, String, String),
        ColType(:MorningOpen, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningHigh, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningLow, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningClose, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningVolume, Union{Nothing,Float64}, Union{Float64,Missing}),
        ColType(:MorningTurnoverValue, Union{Nothing,Float64}, Union{Float64,Missing}),
    ])
end

function datascheme(::MarketsTradeSpec)
    DataScheme([
        ColType(:PublishedDate, String, Date),
        ColType(:StartDate, String, Date),
        ColType(:EndDate, String, Date),
        ColType(:Section, String, String),

        ColType(:ProprietarySales, Float64, Float64),
        ColType(:ProprietaryPurchases, Float64, Float64),
        ColType(:ProprietaryTotal, Float64, Float64),
        ColType(:ProprietaryBalance, Float64, Float64),

        ColType(:BrokerageSales, Float64, Float64),
        ColType(:BrokeragePurchases, Float64, Float64),
        ColType(:BrokerageTotal, Float64, Float64),
        ColType(:BrokerageBalance, Float64, Float64),

        ColType(:TotalSales, Float64, Float64),
        ColType(:TotalPurchases, Float64, Float64),
        ColType(:TotalTotal, Float64, Float64),
        ColType(:TotalBalance, Float64, Float64),

        ColType(:IndividualsSales, Float64, Float64),
        ColType(:IndividualsPurchases, Float64, Float64),
        ColType(:IndividualsTotal, Float64, Float64),
        ColType(:IndividualsBalance, Float64, Float64),
        
        ColType(:ForeignersSales, Float64, Float64),
        ColType(:ForeignersPurchases, Float64, Float64),
        ColType(:ForeignersTotal, Float64, Float64),
        ColType(:ForeignersBalance, Float64, Float64),

        ColType(:SecuritiesCosSales, Float64, Float64),
        ColType(:SecuritiesCosPurchases, Float64, Float64),
        ColType(:SecuritiesCosTotal, Float64, Float64),
        ColType(:SecuritiesCosBalance, Float64, Float64),

        ColType(:InvestmentTrustsSales, Float64, Float64),
        ColType(:InvestmentTrustsPurchases, Float64, Float64),
        ColType(:InvestmentTrustsTotal, Float64, Float64),
        ColType(:InvestmentTrustsBalance, Float64, Float64),        
        
        ColType(:BusinessCosSales, Float64, Float64),
        ColType(:BusinessCosPurchases, Float64, Float64),
        ColType(:BusinessCosTotal, Float64, Float64),
        ColType(:BusinessCosBalance, Float64, Float64),

        ColType(:OtherCosSales, Float64, Float64),
        ColType(:OtherCosPurchases, Float64, Float64),
        ColType(:OtherCosTotal, Float64, Float64),
        ColType(:OtherCosBalance, Float64, Float64),

        ColType(:InsuranceCosSales, Float64, Float64),
        ColType(:InsuranceCosPurchases, Float64, Float64),
        ColType(:InsuranceCosTotal, Float64, Float64),
        ColType(:InsuranceCosBalance, Float64, Float64),

        ColType(:CityBKsRegionalBKsEtcSales, Float64, Float64),
        ColType(:CityBKsRegionalBKsEtcPurchases, Float64, Float64),
        ColType(:CityBKsRegionalBKsEtcTotal, Float64, Float64),
        ColType(:CityBKsRegionalBKsEtcBalance, Float64, Float64),

        ColType(:TrustBanksSales, Float64, Float64),
        ColType(:TrustBanksPurchases, Float64, Float64),
        ColType(:TrustBanksTotal, Float64, Float64),
        ColType(:TrustBanksBalance, Float64, Float64),

        ColType(:OtherFinancialInstitutionsSales, Float64, Float64),
        ColType(:OtherFinancialInstitutionsPurchases, Float64, Float64),
        ColType(:OtherFinancialInstitutionsTotal, Float64, Float64),
        ColType(:OtherFinancialInstitutionsBalance, Float64, Float64),
    ])
end

function datascheme(::MarketsWeeklyMarginInterest)
    DataScheme([
        ColType(:Date, String, Date),
        ColType(:Code, String, String),
        ColType(:ShortMarginTradeVolume, Float64, Float64),
        ColType(:LongMarginTradeVolume, Float64, Float64),
        ColType(:ShortNegotiableMarginTradeVolume, Float64, Float64),
        ColType(:LongNegotiableMarginTradeVolume, Float64, Float64),
        ColType(:ShortStandardizedMarginTradeVolume, Float64, Float64),
        ColType(:LongStandardizedMarginTradeVolume, Float64, Float64),
        ColType(:IssueType, String, String),
    ])
end

function datascheme(::MarketsShortSelling)
    DataScheme([
        ColType(:Date, String, Date),
        ColType(:Sector33Code, String, String),
        ColType(:SellingExcludingShortSellingTurnoverValue, Float64, Float64),
        ColType(:ShortSellingWithRestrictionsTurnoverValue, Float64, Float64),
        ColType(:ShortSellingWithoutRestrctionsTurnoverValue, Float64, Float64),
    ])
end


function datascheme(::MarketsBreakdown)
    DataScheme([
        ColType(:Date, String, Date),
        ColType(:Code, String, String),
        ColType(:LongSellValue, Float64, Float64),
        ColType(:ShortSellWithoutMarginValue, Float64, Float64),
        ColType(:MarginSellNewValue, Float64, Float64),
        ColType(:MarginSellCloseValue, Float64, Float64),
        ColType(:LongBuyValue, Float64, Float64),
        ColType(:MarginBuyNewValue, Float64, Float64),
        ColType(:MarginBuyCloseValue, Float64, Float64),
        ColType(:LongSellVolume, Float64, Float64),
        ColType(:ShortSellWithoutMarginVolume, Float64, Float64),
        ColType(:MarginSellNewVolume, Float64, Float64),
        ColType(:MarginSellCloseVolume, Float64, Float64),
        ColType(:LongBuyVolume, Float64, Float64),
        ColType(:MarginBuyNewVolume, Float64, Float64),
        ColType(:MarginBuyCloseVolume, Float64, Float64),
    ])
end

function datascheme(::TradingCalendar)
    DataScheme([
        ColType(:Date, String, Date),
        ColType(:HolydayDivision, String, String),
    ])
end

function datascheme(::IndicesTopix)
    DataScheme([
        ColType(:Date, String, Date),
        ColType(:Open, Float64, Float64),
        ColType(:Close, Float64, Float64),
        ColType(:Low, Float64, Float64),
        ColType(:High, Float64, Float64),
    ])
end

function datascheme(::FinsStatements)
    DataScheme([
        ColType(:DisclosedDate, String, Date),
        ColType(:DisclosedTime, String, Time),
        ColType(:LocalCode, String, String),
        ColType(:DisclosureNumber, String, Int64),
        ColType(:TypeOfDocument, String, String),
        ColType(:TypeOfCurrentPeriod, String, String),
        ColType(:CurrentPeriodStartDate, String, Date),
        ColType(:CurrentPeriodEndDate, String, Date),
        ColType(:NextPeriodStartDate, String, Date),
        ColType(:NextPeriodEndDate, String, Date),
        
        ColType(:NetSales, String, Union{Float64,Missing}),
        ColType(:OperatingProfit, String, Union{Float64,Missing}),
        ColType(:OrdinaryProfit, String, Union{Float64,Missing}),
        ColType(:Profit, String, Union{Float64,Missing}),
        ColType(:EarningsPerShare, String, Union{Float64,Missing}),
        ColType(:DilutedEarningsPerShare, String, Union{Float64,Missing}),

        ColType(:TotalAssets, String, Union{Float64,Missing}),
        ColType(:Equity, String, Union{Float64,Missing}),
        ColType(:EquityToAssetRatio, String, Union{Float64,Missing}),
        ColType(:BookValuePerShare, String, Union{Float64,Missing}),
        ColType(:CashFlowsFromOperatingActivities, String, Union{Float64,Missing}),
        ColType(:CashFlowsFromInvestingActivities, String, Union{Float64,Missing}),
        ColType(:CashFlowsFromFinancingActivities, String, Union{Float64,Missing}),
        ColType(:CashAndEquivalents, String, Union{Float64,Missing}),

        ColType(:ResultDividendPerShare1stQuarter, String, Union{Float64,Missing}),
        ColType(:ResultDividendPerShare2ndQuarter, String, Union{Float64,Missing}),
        ColType(:ResultDividendPerShare3rdQuarter, String, Union{Float64,Missing}),
        ColType(:ResultDividendPerShareFiscalYearEnd, String, Union{Float64,Missing}),
        ColType(:ResultDividendPerShareAnnual, String, Union{Float64,Missing}),
        ColType(Symbol("DistributionPerUnit(REIT),"), String, Union{Float64,Missing}),
        ColType(:ResultTotalDividendPaidAnnual, String, Union{Float64,Missing}),
        ColType(:ResultPayoutRatioAnnual, String, Union{Float64,Missing}),
        ColType(:ForecastDividendPerShare1stQuarter, String, Union{Float64,Missing}),
        ColType(:ForecastDividendPerShare2ndQuarter, String, Union{Float64,Missing}),
        ColType(:ForecastDividendPerShare3rdQuarter, String, Union{Float64,Missing}),
        ColType(:ForecastDividendPerShareFiscalYearEnd, String, Union{Float64,Missing}),
        ColType(:ForecastDividendPerShareAnnual, String, Union{Float64,Missing}),
        ColType(Symbol("ForecastDistributionPerUnit(REIT),"), String, Union{Float64,Missing}),
        ColType(:NextYearForecastDividendPerShare1stQuarter, String, Union{Float64,Missing}),
        ColType(:NextYearForecastDividendPerShare2ndQuarter, String, Union{Float64,Missing}),
        ColType(:NextYearForecastDividendPerShare3rdQuarter, String, Union{Float64,Missing}),
        ColType(:NextYearForecastDividendPerShareFiscalYearEnd, String, Union{Float64,Missing}),
        ColType(:NextYearForecastDividendPerShareAnnual, String, Union{Float64,Missing}),
        ColType(Symbol("NextYearForecastDistributionPerUnit(REIT),"), String, Union{Float64,Missing}),
        # ColType(:NextYearForecastTotalDividendPaidAnnual, String, Union{Float64,Missing}  # 定義書にはこれがない
        ColType(:NextYearForecastPayoutRatioAnnual, String, Union{Float64,Missing}),  # こちらは定義が間違ってるかも？

        ColType(:ForecastNetSales2ndQuarter, String, Union{Float64,Missing}),
        ColType(:ForecastOperatingProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:ForecastOrdinaryProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:ForecastProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:ForecastEarningsPerShare2ndQuarter, String, Union{Float64,Missing}),

        ColType(:NextYearForecastNetSales2ndQuarter, String, Union{Float64,Missing}),
        ColType(:NextYearForecastOperatingProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:NextYearForecastOrdinaryProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:NextYearForecastProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:NextYearForecastEarningsPerShare2ndQuarter, String, Union{Float64,Missing}),
        
        ColType(:ForecastNetSales, String, Union{Float64,Missing}),
        ColType(:ForecastOperatingProfit, String, Union{Float64,Missing}),
        ColType(:ForecastOrdinaryProfit, String, Union{Float64,Missing}),
        ColType(:ForecastProfit, String, Union{Float64,Missing}),
        ColType(:ForecastEarningsPerShare, String, Union{Float64,Missing}),
        
        ColType(:MaterialChangesInSubsidiaries, String, Union{Bool,Missing}, str2bool),
        ColType(:ChangesBasedOnRevisionsOfAccountingStandard, String, Union{Bool,Missing}, str2bool),
        ColType(:ChangesOtherThanOnesBasedOnRevisionsOfAccountingStandard, String, Union{Bool,Missing}, str2bool),
        ColType(:ChangesInAccountingEstimates, String, Union{Bool,Missing}, str2bool),
        ColType(:RetrospectiveRestatement, String, Union{Bool,Missing}, str2bool),
        ColType(:NumberOfIssuedAndOutstandingSharesAtTheEndOfFiscalYearIncludingTreasuryStock, String, Union{Float64,Missing}),
        ColType(:NumberOfTreasuryStockAtTheEndOfFiscalYear, String, Union{Float64,Missing}),
        ColType(:AverageNumberOfShares, String, Union{Float64,Missing}),

        ColType(:NonConsolidatedNetSales, String, Union{Float64,Missing}),
        ColType(:NonConsolidatedOperatingProfit, String, Union{Float64,Missing}),
        ColType(:NonConsolidatedOrdinaryProfit, String, Union{Float64,Missing}),
        ColType(:NonConsolidatedProfit, String, Union{Float64,Missing}),
        ColType(:NonConsolidatedEarningsPerShare, String, Union{Float64,Missing}),
        
        ColType(:NonConsolidatedTotalAssets, String, Union{Float64,Missing}),
        ColType(:NonConsolidatedEquity, String, Union{Float64,Missing}),
        ColType(:NonConsolidatedEquityToAssetRatio, String, Union{Float64,Missing}),
        ColType(:NonConsolidatedBookValuePerShare, String, Union{Float64,Missing}),

        ColType(:ForecastNonConsolidatedNetSales2ndQuarter, String, Union{Float64,Missing}),
        ColType(:ForecastNonConsolidatedOperatingProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:ForecastNonConsolidatedOrdinaryProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:ForecastNonConsolidatedProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:ForecastNonConsolidatedEarningsPerShare2ndQuarter, String, Union{Float64,Missing}),

        ColType(:NextYearForecastNonConsolidatedNetSales2ndQuarter, String, Union{Float64,Missing}),
        ColType(:NextYearForecastNonConsolidatedOperatingProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:NextYearForecastNonConsolidatedOrdinaryProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:NextYearForecastNonConsolidatedProfit2ndQuarter, String, Union{Float64,Missing}),
        ColType(:NextYearForecastNonConsolidatedEarningsPerShare2ndQuarter, String, Union{Float64,Missing}),
        
        ColType(:ForecastNonConsolidatedNetSales, String, Union{Float64,Missing}),
        ColType(:ForecastNonConsolidatedOperatingProfit, String, Union{Float64,Missing}),
        ColType(:ForecastNonConsolidatedOrdinaryProfit, String, Union{Float64,Missing}),
        ColType(:ForecastNonConsolidatedProfit, String, Union{Float64,Missing}),
        ColType(:ForecastNonConsolidatedEarningsPerShare, String, Union{Float64,Missing}),

        ColType(:NextYearForecastNonConsolidatedNetSales, String, Union{Float64,Missing}),
        ColType(:NextYearForecastNonConsolidatedOperatingProfit, String, Union{Float64,Missing}),
        ColType(:NextYearForecastNonConsolidatedOrdinaryProfit, String, Union{Float64,Missing}),
        ColType(:NextYearForecastNonConsolidatedProfit, String, Union{Float64,Missing}),
        ColType(:NextYearForecastNonConsolidatedEarningsPerShare, String, Union{Float64,Missing}),
    ])
end

function datascheme(::FinsDividend)
    DataScheme([
        ColType(:AnnouncementDate, String, Date),
        ColType(:AnnouncementTime, String, Time),
        ColType(:Code, String, String),
        ColType(:ReferenceNumber, String, String),
        ColType(:StatusCode, String, String),
        ColType(:BoardMeetingDate, String, Date),
        ColType(:InterimFinalCode, String, String),
        ColType(:ForecastResultCode, String, String),
        ColType(:InterimFinalTerm, String, String),
        ColType(:GrossDividendRate, String, String),  # "-" if undeterminded, "" if not applicable
        ColType(:RecordDate, String, Date),
        ColType(:ExDate, String, Date),
        ColType(:ActulalRecordDate, String, Date),
        ColType(:PayableDate, String, String),  # "-" if undeterminded, "" if not applicable
        ColType(:CAReferenceNumber, String, String),
        ColType(:DistributionAmount, String, String),  # "-" if undeterminded, "" if not applicable
        ColType(:RetainedEarnings, String, String),  # "-" if undeterminded, "" if not applicable
        ColType(:DeemedDividend, String, String),  # "-" if undeterminded, "" if not applicable
        ColType(:DeemedCapitalGains, String, String),  # "-" if undeterminded, "" if not applicable
        ColType(:NetAssetDecreaseRatio, String, String),  # "-" if undeterminded, "" if not applicable
        ColType(:CommemorativeSpecialCode, String, String),
        ColType(:CommemorativeDividendRate, String, String),  # "-" if undeterminded, "" if not applicable
        ColType(:SpecialDividentRate, String, String),  # "-" if undeterminded, "" if not applicable
    ])
end

function datascheme(::FinsAnnouncement)
    DataScheme([
        ColType(:Code, String, String),
        ColType(:Date, String, Date),
        ColType(:CompanyName, String, String),
        ColType(:FiscalYear, String, String),
        ColType(:SectorName, String, String),
        ColType(:FiscalQuarter, String, String),
        ColType(:Section, String, String),
    ])
end

function datascheme(::OptionIndexOption)
    DataScheme([
        ColType(:Date, String, Date),
        ColType(:Code, String, String),
        ColType(:WholeDayOpen, Float64, Float64),
        ColType(:WholeDayHigh, Float64, Float64),
        ColType(:WholeDayLow, Float64, Float64),
        ColType(:WholeDayClose, Float64, Float64),
        ColType(:NightSessionOpen, Float64, Float64),
        ColType(:NightSessionHigh, Float64, Float64),
        ColType(:NightSessionLow, Float64, Float64),
        ColType(:NightSessionClose, Float64, Float64),
        ColType(:DaySessionOpen, Float64, Float64),
        ColType(:DaySessionHigh, Float64, Float64),
        ColType(:DaySessionLow, Float64, Float64),
        ColType(:DaySessionClose, Float64, Float64),
        ColType(:Volume, Float64, Float64),
        ColType(:OpenInterest, Float64, Float64),
        ColType(:TurnoverValue, Float64, Float64),
        ColType(:ContractMonth, String, String),
        ColType(:StrikePrice, Float64, Float64),
        ColType(Symbol("Volume(OnlyAuction)"), Float64, Float64),
        ColType(:EmergencyMarginTriggerDivision, String, String),
        ColType(:PutCallDivision, String, String),
        ColType(:LastTradingDay, String, Date),
        ColType(:SpecialQuotationDay, String, Date),
        ColType(:SettlementPrice, Float64, Float64),
        ColType(:BaseVolatility, Float64, Float64),
        ColType(:UnderlyingPrice, Float64, Float64),
        ColType(:ImpliedVolatility, Float64, Float64),
        ColType(:InterestRate, Float64, Float64),
    ])
end
