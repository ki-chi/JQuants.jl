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

    @test names(one_code_all_daily_quotes) == expected_colnames
    @test eltype.(eachcol(one_code_all_daily_quotes)) == expected_coltypes

    # No output on a holiday
    daily_quotes_null = getdailyquotes(date="2022-08-28")
    @test isempty(daily_quotes_null)
    @test daily_quotes_null == Any[]
end
