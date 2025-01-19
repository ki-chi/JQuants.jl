using JQuants
using DataFrames
using Test
using Dates

function check_scheme_names(df::DataFrame, datascheme::JQuants.DataScheme; skippremiumplan=false)
    expected_colnames = String[]
    for coltype in datascheme
        if coltype.restriction_level == JQuants.require_premium_plan && skippremiumplan
            continue
        end

        push!(expected_colnames, string(coltype.name))
    end

    if sort(names(df)) != sort(expected_colnames)
	@info "Diff" setdiff(sort(names(df)), sort(expected_colnames))
    end

    return sort(names(df)) == sort(expected_colnames)
end

function check_scheme_types(df::DataFrame, datascheme::JQuants.DataScheme; skippremiumplan=false)
    bools = Bool[]
    for coltype in datascheme
        if coltype.restriction_level == JQuants.require_premium_plan && skippremiumplan
            continue
        end

        expected_name = string(coltype.name)
        expected_type = coltype.target
        if eltype(df[!, expected_name]) <: expected_type
            push!(bools, true)
        else
            @info "Diff" expected_name, expected_type, eltype(df[!, expected_name])
            push!(bools, false)
        end
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
    statements = fetch(FinsStatements(code="86970"))
    scheme = JQuants.datascheme(FinsStatements(code="86970"))

    @test check_scheme_names(statements, scheme)
    @test check_scheme_types(statements, scheme)
end

@testset "Pagination" begin
    @test_nowarn statements = fetch(FinsStatements(date="2022-05-13"))  # A lot of disclosures on this day
end

@testset "Financial announcement" begin
    ann = fetch(FinsAnnouncement())
    scheme = JQuants.datascheme(FinsAnnouncement())

    @test check_scheme_names(ann, scheme)
    @test check_scheme_types(ann, scheme)
end

    @test sort(names(ann)) == sort(expected_colnames)
end
