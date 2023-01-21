struct ColType
    name::Symbol
    original::DataType
    target::Union{DataType,Union}
    convert::Union{Function,Nothing}
end

ColType(name, original, target) = ColType(name, original, target, nothing)

DataScheme = Vector{ColType}

const NULL_STR = ["", "－"]

function Base.convert(scheme::DataScheme, df)
    df_conv = copy(df)
    for coltype in scheme
        if coltype.original != coltype.target

            # Replace null strings to missing
            if coltype.original <: AbstractString && coltype.target >: Missing
                allowmissing!(df_conv, coltype.name)
                replace!(x -> x ∈ NULL_STR ? missing : x, df_conv[!, coltype.name])
            end

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

dataschemes = Dict{EndPointKey,DataScheme}()


dataschemes[FinsStatements] = DataScheme(
    [
        ColType(:ApplyingOfSpecificAccountingOfTheQuarterlyFinancialStatements, String, Union{Bool,Missing}, str2bool)
        ColType(:AverageNumberOfShares, String, Union{Float64,Missing})
        ColType(:BookValuePerShare, String, Union{Float64,Missing})
        ColType(:ChangesBasedOnRevisionsOfAccountingStandard, String, Union{Bool,Missing}, str2bool)
        ColType(:ChangesInAccountingEstimates, String, Union{Bool,Missing}, str2bool)
        ColType(:ChangesOtherThanOnesBasedOnRevisionsOfAccountingStandard, String, Union{Bool,Missing}, str2bool)
        ColType(:CurrentFiscalYearEndDate, String, Date)
        ColType(:CurrentFiscalYearStartDate, String, Date)
        ColType(:CurrentPeriodEndDate, String, Date)
        ColType(:DisclosedDate, String, Date)
        ColType(:DisclosedTime, String, Time)
        ColType(:DisclosedUnixTime, String, Float64)
        ColType(:DisclosureNumber, String, Int64)
        ColType(:EarningsPerShare, String, Union{Float64,Missing})
        ColType(:Equity, String, Union{Float64,Missing})
        ColType(:EquityToAssetRatio, String, Union{Float64,Missing})
        ColType(:ForecastDividendPerShare1stQuarter, String, Union{Float64,Missing})
        ColType(:ForecastDividendPerShare2ndQuarter, String, Union{Float64,Missing})
        ColType(:ForecastDividendPerShare3rdQuarter, String, Union{Float64,Missing})
        ColType(:ForecastDividendPerShareAnnual, String, Union{Float64,Missing})
        ColType(:ForecastDividendPerShareFiscalYearEnd, String, Union{Float64,Missing})
        ColType(:ForecastEarningsPerShare, String, Union{Float64,Missing})
        ColType(:ForecastNetSales, String, Union{Float64,Missing})
        ColType(:ForecastOperatingProfit, String, Union{Float64,Missing})
        ColType(:ForecastOrdinaryProfit, String, Union{Float64,Missing})
        ColType(:ForecastProfit, String, Union{Float64,Missing})
        ColType(:LocalCode, String, String)
        ColType(:MaterialChangesInSubsidiaries, String, Union{Bool,Missing}, str2bool)
        ColType(:NetSales, String, Union{Float64,Missing})
        ColType(:NumberOfIssuedAndOutstandingSharesAtTheEndOfFiscalYearIncludingTreasuryStock, String, Union{Float64,Missing})
        ColType(:NumberOfTreasuryStockAtTheEndOfFiscalYear, String, Union{Float64,Missing})
        ColType(:OperatingProfit, String, Union{Float64,Missing})
        ColType(:OrdinaryProfit, String, Union{Float64,Missing})
        ColType(:Profit, String, Union{Float64,Missing})
        ColType(:ResultDividendPerShare1stQuarter, String, Union{Float64,Missing})
        ColType(:ResultDividendPerShare2ndQuarter, String, Union{Float64,Missing})
        ColType(:ResultDividendPerShare3rdQuarter, String, Union{Float64,Missing})
        ColType(:ResultDividendPerShareAnnual, String, Union{Float64,Missing})
        ColType(:ResultDividendPerShareFiscalYearEnd, String, Union{Float64,Missing})
        ColType(:RetrospectiveRestatement, String, Union{Bool,Missing}, str2bool)
        ColType(:TotalAssets, String, Union{Float64,Missing})
        ColType(:TypeOfCurrentPeriod, String, String)
        ColType(:TypeOfDocument, String, String)
    ]
)


dataschemes[MarketsTradeSpec] = DataScheme(
    [
    ColType(:BrokerageBalance, Float64, Float64),
    ColType(:BrokeragePurchases, Float64, Float64),
    ColType(:BrokerageSales, Float64, Float64),
    ColType(:BrokerageTotal, Float64, Float64),
    ColType(:BusinessCosBalance, Float64, Float64),
    ColType(:BusinessCosPurchases, Float64, Float64),
    ColType(:BusinessCosSales, Float64, Float64),
    ColType(:BusinessCosTotal, Float64, Float64),
    ColType(:CityBKsRegionalBKsEtcBalance, Float64, Float64),
    ColType(:CityBKsRegionalBKsEtcPurchases, Float64, Float64),
    ColType(:CityBKsRegionalBKsEtcSales, Float64, Float64),
    ColType(:CityBKsRegionalBKsEtcTotal, Float64, Float64),
    ColType(:EndDate, String, Date),
    ColType(:ForeignersBalance, Float64, Float64),
    ColType(:ForeignersPurchases, Float64, Float64),
    ColType(:ForeignersSales, Float64, Float64),
    ColType(:ForeignersTotal, Float64, Float64),
    ColType(:IndividualsBalance, Float64, Float64),
    ColType(:IndividualsPurchases, Float64, Float64),
    ColType(:IndividualsSales, Float64, Float64),
    ColType(:IndividualsTotal, Float64, Float64),
    ColType(:InsuranceCosBalance, Float64, Float64),
    ColType(:InsuranceCosPurchases, Float64, Float64),
    ColType(:InsuranceCosSales, Float64, Float64),
    ColType(:InsuranceCosTotal, Float64, Float64),
    ColType(:InvestmentTrustsBalance, Float64, Float64),
    ColType(:InvestmentTrustsPurchases, Float64, Float64),
    ColType(:InvestmentTrustsSales, Float64, Float64),
    ColType(:InvestmentTrustsTotal, Float64, Float64),
    ColType(:OtherCosBalance, Float64, Float64),
    ColType(:OtherCosPurchases, Float64, Float64),
    ColType(:OtherCosSales, Float64, Float64),
    ColType(:OtherCosTotal, Float64, Float64),
    ColType(:OtherFinancialInstitutionsBalance, Float64, Float64),
    ColType(:OtherFinancialInstitutionsPurchases, Float64, Float64),
    ColType(:OtherFinancialInstitutionsSales, Float64, Float64),
    ColType(:OtherFinancialInstitutionsTotal, Float64, Float64),
    ColType(:ProprietaryBalance, Float64, Float64),
    ColType(:ProprietaryPurchases, Float64, Float64),
    ColType(:ProprietarySales, Float64, Float64),
    ColType(:ProprietaryTotal, Float64, Float64),
    ColType(:PublishedDate, String, Date),
    ColType(:Section, String, String),
    ColType(:SecuritiesCosBalance, Float64, Float64),
    ColType(:SecuritiesCosPurchases, Float64, Float64),
    ColType(:SecuritiesCosSales, Float64, Float64),
    ColType(:SecuritiesCosTotal, Float64, Float64),
    ColType(:StartDate, String, Date),
    ColType(:TotalBalance, Float64, Float64),
    ColType(:TotalPurchases, Float64, Float64),
    ColType(:TotalSales, Float64, Float64),
    ColType(:TotalTotal, Float64, Float64),
    ColType(:TrustBanksBalance, Float64, Float64),
    ColType(:TrustBanksPurchases, Float64, Float64),
    ColType(:TrustBanksSales, Float64, Float64),
    ColType(:TrustBanksTotal, Float64, Float64)
])

