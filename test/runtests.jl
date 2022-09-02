using JQuants
using Test

@testset "Authorization" begin
    refresh_token = ENV["JQUANTS_REFRESH_TOKEN"]
    mail_address = ENV["JQUANTS_MAIL_ADDRESS"]
    password = ENV["JQUANTS_PASSWORD"]
    @test JQuants.authorize(refresh_token)
    @test JQuants.authorize(mail_address, password)
end

@testset "Inquiry of listed issues information" begin
    code = "86970"  # JPX
    listed_info = getlistedinfo(code=code)

    @test listed_info[begin, :Code] == "86970"
    @test listed_info[begin, :CompanyName] == "ＪＰＸ"
    @test listed_info[begin, :CompanyNameEnglish] == "Japan Exchange Group,Inc."
    @test listed_info[begin, :CompanyNameFull] == "（株）日本取引所グループ"
    @test listed_info[begin, :MarketCode] == "A"
    @test listed_info[begin, :SectorCode] == "7200"
end
