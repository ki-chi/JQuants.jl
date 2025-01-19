using JQuants
using DataFrames
using Test
using Dates

function check_scheme_names(df::DataFrame, datascheme::JQuants.DataScheme; skippremiumplan=false)
    expected_colnames = []
    for coltype in datascheme
        if coltype.restriction_level == JQuants.require_premium_plan && skippremiumplan
            continue
        end

        push!(expected_colnames, string(coltype.name))
    end
    return sort(names(df)) == sort(expected_colnames)
end

function check_scheme_types(df::DataFrame, datascheme::JQuants.DataScheme; skippremiumplan=false)
    bools = []
    for coltype in datascheme
        if coltype.restriction_level == JQuants.require_premium_plan && skippremiumplan
            continue
        end

        expected_name = string(coltype.name)
        expected_type = coltype.target
        eltype(df[!, expected_name]) == expected_type ? push!(bools, true) : push!(bools, false)
    end
    return all(bools) 
end

@testset "Undefined tokens error" begin
    @test_throws JQuants.JQuantsInvalidTokenError fetch(ListedInfo(code="86970"))
end

@testset "Authorization" begin
    emailaddress = ENV["JQUANTS_API_EMAIL"]
    password = ENV["JQUANTS_API_PASSWORD"]
    @test JQuants.authorize(emailaddress, password)
end

@testset "Trading Calendar" begin
    calendar = fetch(TradingCalendar(holidaydivision="1"))

    expected_colnames = [
        "Date",
        "HolidayDivision",
    ]

    @test sort(names(calendar)) == sort(expected_colnames)
end

# Get the latest date from the trading calendar
test_date = fetch(TradingCalendar(holidaydivision="1")) |> (df -> subset(df, :Date => x -> x .< today())) |> last |> row -> row[:Date]
test_holiday = fetch(TradingCalendar(holidaydivision="0")) |> (df -> subset(df, :Date => x -> x .< today())) |> last |> row -> row[:Date]

@testset "Listed issues information" begin
    code = "86970"  # JPX
    listed_info = fetch(ListedInfo(code=code, date=test_date))
    scheme = JQuants.datascheme(ListedInfo(code=code, date=test_date))

    @test check_scheme_names(listed_info, scheme)
    @test check_scheme_types(listed_info, scheme)

    @test listed_info[begin, :Code] == "86970"
    @test listed_info[begin, :CompanyName] == "日本取引所グループ"
    @test listed_info[begin, :CompanyNameEnglish] == "Japan Exchange Group,Inc."
    @test listed_info[begin, :Sector17Code] == "16"
    @test listed_info[begin, :Sector17CodeName] == "金融（除く銀行）"
    @test listed_info[begin, :Sector33Code] == "7200"
    @test listed_info[begin, :Sector33CodeName] == "その他金融業"
    @test listed_info[begin, :ScaleCategory] == "TOPIX Large70"
    @test listed_info[begin, :MarketCode] == "0111"
    @test listed_info[begin, :MarketCodeName] == "プライム"

end

@testset "Daily prices" begin
    daily_quotes = fetch(PricesDailyQuotes(date=test_date))
    scheme = JQuants.datascheme(PricesDailyQuotes(date=test_date))

    @test check_scheme_names(daily_quotes, scheme, skippremiumplan=true)
    @test check_scheme_types(daily_quotes, scheme, skippremiumplan=true)

    # No output on a holiday
    daily_quotes_null = fetch(PricesDailyQuotes(date=test_holiday))
    @test isempty(daily_quotes_null)
    @test daily_quotes_null == Any[]
end

@testset "Financial statements" begin
    expected_colnames = [
        "DisclosedDate",
        "DisclosedTime",
        "LocalCode",
        "DisclosureNumber",
        "TypeOfDocument",
        "TypeOfCurrentPeriod",
        "CurrentPeriodStartDate",
        "CurrentPeriodEndDate",
        "CurrentFiscalYearStartDate",
        "CurrentFiscalYearEndDate",
        "NextFiscalYearStartDate",
        "NextFiscalYearEndDate",
        "NetSales",
        "OperatingProfit",
        "OrdinaryProfit",
        "Profit",
        "EarningsPerShare",
        "DilutedEarningsPerShare",
        "TotalAssets",
        "Equity",
        "EquityToAssetRatio",
        "BookValuePerShare",
        "CashFlowsFromOperatingActivities",
        "CashFlowsFromInvestingActivities",
        "CashFlowsFromFinancingActivities",
        "CashAndEquivalents",
        "ResultDividendPerShare1stQuarter",
        "ResultDividendPerShare2ndQuarter",
        "ResultDividendPerShare3rdQuarter",
        "ResultDividendPerShareFiscalYearEnd",
        "ResultDividendPerShareAnnual",
        "DistributionsPerUnit(REIT)",
        "ResultTotalDividendPaidAnnual",
        "ResultPayoutRatioAnnual",
        "ForecastDividendPerShare1stQuarter",
        "ForecastDividendPerShare2ndQuarter",
        "ForecastDividendPerShare3rdQuarter",
        "ForecastDividendPerShareFiscalYearEnd",
        "ForecastDividendPerShareAnnual",
        "ForecastDistributionsPerUnit(REIT)",
        "ForecastTotalDividendPaidAnnual",
        "ForecastPayoutRatioAnnual",
        "NextYearForecastDividendPerShare1stQuarter",
        "NextYearForecastDividendPerShare2ndQuarter",
        "NextYearForecastDividendPerShare3rdQuarter",
        "NextYearForecastDividendPerShareFiscalYearEnd",
        "NextYearForecastDividendPerShareAnnual",
        "NextYearForecastDistributionsPerUnit(REIT)",
        "NextYearForecastPayoutRatioAnnual",
        "ForecastNetSales2ndQuarter",
        "ForecastOperatingProfit2ndQuarter",
        "ForecastOrdinaryProfit2ndQuarter",
        "ForecastProfit2ndQuarter",
        "ForecastEarningsPerShare2ndQuarter",
        "NextYearForecastNetSales2ndQuarter",
        "NextYearForecastOperatingProfit2ndQuarter",
        "NextYearForecastOrdinaryProfit2ndQuarter",
        "NextYearForecastProfit2ndQuarter",
        "NextYearForecastEarningsPerShare2ndQuarter",
        "ForecastNetSales",
        "ForecastOperatingProfit",
        "ForecastOrdinaryProfit",
        "ForecastProfit",
        "ForecastEarningsPerShare",
        "NextYearForecastNetSales",
        "NextYearForecastOperatingProfit",
        "NextYearForecastOrdinaryProfit",
        "NextYearForecastProfit",
        "NextYearForecastEarningsPerShare",
        "MaterialChangesInSubsidiaries",
        "SignificantChangesInTheScopeOfConsolidation",
        "ChangesBasedOnRevisionsOfAccountingStandard",
        "ChangesOtherThanOnesBasedOnRevisionsOfAccountingStandard",
        "ChangesInAccountingEstimates",
        "RetrospectiveRestatement",
        "NumberOfIssuedAndOutstandingSharesAtTheEndOfFiscalYearIncludingTreasuryStock",
        "NumberOfTreasuryStockAtTheEndOfFiscalYear",
        "AverageNumberOfShares",
        "NonConsolidatedNetSales",
        "NonConsolidatedOperatingProfit",
        "NonConsolidatedOrdinaryProfit",
        "NonConsolidatedProfit",
        "NonConsolidatedEarningsPerShare",
        "NonConsolidatedTotalAssets",
        "NonConsolidatedEquity",
        "NonConsolidatedEquityToAssetRatio",
        "NonConsolidatedBookValuePerShare",
        "ForecastNonConsolidatedNetSales2ndQuarter",
        "ForecastNonConsolidatedOperatingProfit2ndQuarter",
        "ForecastNonConsolidatedOrdinaryProfit2ndQuarter",
        "ForecastNonConsolidatedProfit2ndQuarter",
        "ForecastNonConsolidatedEarningsPerShare2ndQuarter",
        "NextYearForecastNonConsolidatedNetSales2ndQuarter",
        "NextYearForecastNonConsolidatedOperatingProfit2ndQuarter",
        "NextYearForecastNonConsolidatedOrdinaryProfit2ndQuarter",
        "NextYearForecastNonConsolidatedProfit2ndQuarter",
        "NextYearForecastNonConsolidatedEarningsPerShare2ndQuarter",
        "ForecastNonConsolidatedNetSales",
        "ForecastNonConsolidatedOperatingProfit",
        "ForecastNonConsolidatedOrdinaryProfit",
        "ForecastNonConsolidatedProfit",
        "ForecastNonConsolidatedEarningsPerShare",
        "NextYearForecastNonConsolidatedNetSales",
        "NextYearForecastNonConsolidatedOperatingProfit",
        "NextYearForecastNonConsolidatedOrdinaryProfit",
        "NextYearForecastNonConsolidatedProfit",
        "NextYearForecastNonConsolidatedEarningsPerShare"
    ]

    statements = fetch(FinsStatements(code="86970"))

    @test sort(names(statements)) == sort(expected_colnames)
end

@testset "Pagination" begin
    @test_nowarn statements = fetch(FinsStatements(date="2022-05-13"))  # A lot of disclosures on this day
end

@testset "Financial announcement" begin
    ann = fetch(FinsAnnouncement())

    expected_colnames = [
        "Code",
        "Date",
        "CompanyName",
        "FiscalYear",
        "SectorName",
        "FiscalQuarter",
        "Section"
    ]

    @test sort(names(ann)) == sort(expected_colnames)
end
