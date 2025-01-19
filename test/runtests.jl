using JQuants
using DataFrames
using Test
using Dates

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

    expected_colnames = [
        "Date", "Code", "CompanyName", "CompanyNameEnglish", "Sector17Code",
        "Sector17CodeName", "Sector33Code", "Sector33CodeName",
        "ScaleCategory", "MarketCode", "MarketCodeName",
    ]

    @test sort(names(listed_info)) == sort(expected_colnames)

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
    expected_colnames = [
        "AdjustmentClose", "AdjustmentFactor",
        "AdjustmentHigh", "AdjustmentLow", "AdjustmentOpen", "AdjustmentVolume",
        "Close", "Code", "Date", "High", "Low", "Open", "TurnoverValue", "Volume",
        "LowerLimit", "UpperLimit"
    ]
    expected_coltypes = [
        Union{Missing, Float64}, Float64,
        Union{Missing, Float64}, Union{Missing, Float64}, Union{Missing, Float64},
        Union{Missing, Float64}, Union{Missing, Float64}, String, Date,
        Union{Missing, Float64}, Union{Missing, Float64}, Union{Missing, Float64},
        Union{Missing, Float64}, Union{Missing, Float64}
    ]

    @test sort(names(daily_quotes)) == sort(expected_colnames)

    for (colname, coltype) in zip(expected_colnames, expected_coltypes)
        @test eltype(daily_quotes[!, colname]) == coltype 
    end

    # No output on a holiday
    daily_quotes_null = fetch(PricesDailyQuotes(date=test_holiday))
    @test isempty(daily_quotes_null)
    @test daily_quotes_null == Any[]
end

@testset "Financial statements" begin
    statements = fetch(FinsStatements(code="86970"))

    @test length(names(statements)) == 106
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
