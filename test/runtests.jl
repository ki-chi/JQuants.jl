using JQuants
using DataFrames
using Test

@testset "Authorization" begin
    mail_address = ENV["JQUANTS_MAIL_ADDRESS"]
    password = ENV["JQUANTS_PASSWORD"]
    @test JQuants.authorize(mail_address, password)
end

@testset "Listed issues information" begin
    code = "86970"  # JPX
    listed_info = getinfo(code=code)

    @test listed_info[begin, :Code] == "86970"
    @test listed_info[begin, :CompanyName] == "ＪＰＸ"
    @test listed_info[begin, :CompanyNameEnglish] == "Japan Exchange Group,Inc."
    @test listed_info[begin, :CompanyNameFull] == "（株）日本取引所グループ"
    @test listed_info[begin, :MarketCode] == "A"
    @test listed_info[begin, :SectorCode] == "7200"
end

@testset "Listed sections" begin
    listed_sections = getsections()
    
    @test size(listed_sections) == (34, 2)
    @test subset(listed_sections, :SectorCode => x -> x .== "7150")[begin, :SectorName] == "保険業"
    @test subset(listed_sections, :SectorCode => x -> x .== "9999")[begin, :SectorName] == "(その他)"
end

@testset "Daily prices" begin
    one_code_all_daily_quotes = getdailyquotes(code="86970")
    expected_colnames = [
        "AdjustmentClose", "AdjustmentFactor",
        "AdjustmentHigh", "AdjustmentLow", "AdjustmentOpen", "AdjustmentVolume",
        "Close", "Code", "Date", "High", "Low", "Open", "TurnoverValue", "Volume"
    ]
    expected_coltypes = [
        Union{Nothing, Float64}, Float64,
        Union{Nothing, Float64}, Union{Nothing, Float64}, Union{Nothing, Float64},
        Union{Nothing, Float64}, Union{Nothing, Float64}, String, String,
        Union{Nothing, Float64}, Union{Nothing, Float64}, Union{Nothing, Float64},
        Union{Nothing, Float64}, Union{Nothing, Float64}
    ]

    @test sort(names(one_code_all_daily_quotes)) == expected_colnames

    for (colname, coltype) in zip(expected_colnames, expected_coltypes)
        @test eltype(one_code_all_daily_quotes[!, colname]) == coltype 
    end

    # No output on a holiday
    daily_quotes_null = getdailyquotes(date="2022-08-28")
    @test isempty(daily_quotes_null)
    @test daily_quotes_null == Any[]
end

@testset "Financial statements by code" begin
    statements = getfinstatements(code="86970")
    expected_colnames = [
        "ApplyingOfSpecificAccountingOfTheQuarterlyFinancialStatements",
        "AverageNumberOfShares",
        "BookValuePerShare",
        "ChangesBasedOnRevisionsOfAccountingStandard",
        "ChangesInAccountingEstimates",
        "ChangesOtherThanOnesBasedOnRevisionsOfAccountingStandard",
        "CurrentFiscalYearEndDate",
        "CurrentFiscalYearStartDate",
        "CurrentPeriodEndDate",
        "DisclosedDate",
        "DisclosedTime",
        "DisclosedUnixTime",
        "DisclosureNumber",
        "EarningsPerShare",
        "Equity",
        "EquityToAssetRatio",
        "ForecastDividendPerShare1stQuarter",
        "ForecastDividendPerShare2ndQuarter",
        "ForecastDividendPerShare3rdQuarter",
        "ForecastDividendPerShareAnnual",
        "ForecastDividendPerShareFiscalYearEnd",
        "ForecastEarningsPerShare",
        "ForecastNetSales",
        "ForecastOperatingProfit",
        "ForecastOrdinaryProfit",
        "ForecastProfit",
        "LocalCode",
        "MaterialChangesInSubsidiaries",
        "NetSales",
        "NumberOfIssuedAndOutstandingSharesAtTheEndOfFiscalYearIncludingTreasuryStock",
        "NumberOfTreasuryStockAtTheEndOfFiscalYear",
        "OperatingProfit",
        "OrdinaryProfit",
        "Profit",
        "ResultDividendPerShare1stQuarter",
        "ResultDividendPerShare2ndQuarter",
        "ResultDividendPerShare3rdQuarter",
        "ResultDividendPerShareAnnual",
        "ResultDividendPerShareFiscalYearEnd",
        "RetrospectiveRestatement",
        "TotalAssets",
        "TypeOfCurrentPeriod",
        "TypeOfDocument"
    ]
    expected_coltypes = repeat([String], 43)

    @test sort(names(statements)) == expected_colnames
    @test eltype.(eachcol(statements)) == expected_coltypes
end

@testset "Financial statements by date" begin
    statements = getfinstatements(date="2022-01-05")

    expected_codes = [
        "13760",
        "17120",
        "26590",
        "27530",
        "27890",
        "32820",
        "38250",
        "65520",
        "76790",
        "97930",
        "97930",
        "99770"
    ]

    @test sort(statements[!, :LocalCode]) == expected_codes
end

@testset "Financial announcement" begin
    ann = getfinannouncement()

    expected_colnames = [
        "Code",
        "Date",
        "CompanyName",
        "FiscalYear",
        "SectorName",
        "FiscalQuarter",
        "Section"
    ]

    expected_coltypes = repeat([String], 7)

    @test sort(names(ann)) == sort(expected_colnames)
    @test eltype.(eachcol(ann)) == expected_coltypes
end
