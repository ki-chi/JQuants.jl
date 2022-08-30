using JQuants
using Test

@testset "Authorization" begin
    JQuants.authorize(refresh_token)
    JQuants.authorize(mail_address, password)
end

@testset "Inquiry of listed issues information" begin
    issue_code = "86970"  # JPX
    listed_info = getlistedinfo(issue_code)

    @test listed_info.code == "86970"
    @test listed_info.company_name == "ＪＰＸ"
    @test listed_info.company_name_english == "Japan Exchange Group,Inc."
    @test listed_info.company_name_full == "(株) 日本取引所グループ"
    @test listed_info.sector_code == "7200"
    @test listed_info.market_code == "A"

    listed_sections = getlistedsections()
    
end
