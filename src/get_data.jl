"""
    getinfo()
    getinfo(code::AbstractString)

Return `DataFrame` holding the information of listed securities on the Tokyo Stock Exchange,
Nagoya Stock Exchange, Sapporo Stock Exchange, and Fukuoka Stock Exchange.

It returns all listed information if you do not specify the argument `code`. 

The details of this API are [here](https://jpx.gitbook.io/j-quants-api-en/api-reference/listed-api#inquiry-of-listed-issue-information).

# Examples

```jldoctest
julia> getinfo()
4229×7 DataFrame
  Row │ Code    CompanyName           CompanyNameEnglish                 CompanyNameFull                    MarketCode  SectorCode  UpdateDate
      │ String  String                String                             String                             String      String      String
──────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    1 │ 79860   日本アイエスケイ      NIHON ISK Company,Limited          日本アイ・エス・ケイ               B           3800        20220912
    2 │ 33280   ＢＥＥＮＯＳ          BEENOS Inc.                        ＢＥＥＮＯＳ                       A           6100        20220912
    3 │ 31970   すかいらーくＨＤ      SKYLARK HOLDINGS CO.,LTD.          （株）すかいらーくホールディング…  A           6100        20220912
    4 │ 72410   フタバ産              FUTABA INDUSTRIAL CO.,LTD.         フタバ産業                         A           3700        20220912
    5 │ 83030   新生銀                Shinsei Bank,Limited               （株）新生銀行                     B           7050        20220912
    6 │ 95520   Ｇ−Ｍ＆Ａ総合研究所   M&A Research Institute Inc.        （株）Ｍ＆Ａ総合研究所             C           9050        20220912
    7 │ 40640   カーバイド            Nippon Carbide Industries Compan…  日本カーバイド工業                 A           3200        20220912
    8 │ 21570   コシダカＨＤ          KOSHIDAKA HOLDINGS Co.,LTD.        （株）コシダカホールディングス     A           9050        20220912
    9 │ 79190   野崎印                Nozaki Insatsu Shigyo Co.,Ltd.     野崎印刷紙業                       B           3800        20220912
   10 │ 62760   シリウスＶ            SiriusVision CO.,LTD.              シリウスビジョン                   B           3600        20220912
   11 │ 68060   ヒロセ電              HIROSE ELECTRIC CO.,LTD.           ヒロセ電機                         A           3650        20220912
   12 │ 16260   ＮＦ情通・他Ｔ１７    NEXT FUNDS TOPIX-17 IT & SERVICE…  野村アセットマネジメント株式会社…  5           9999        20220912
   13 │ 30920   ＺＯＺＯ              ZOZO,Inc.                          （株）ＺＯＺＯ                     A           6100        20220912
   14 │ 72650   エイケン工業          EIKEN INDUSTRIES CO.,LTD           エイケン工業                       B           3700        20220912
   15 │ 63810   アネスト岩田          ANEST IWATA Corporation            アネスト岩田                       A           3600        20220912
   16 │ 24080   ＫＧ情報              KG Intelligence CO.,LTD.           （株）ＫＧ情報                     B           9050        20220912
   17 │ 92650   ヤマシタヘルスケア    YAMASHITA HEALTH CARE HOLDINGS,I…  ヤマシタヘルスケアホールディング…  B           6050        20220912
   18 │ 28770   日東ベスト            NittoBest Corporation              日東ベスト                         B           3050        20220912
   19 │ 33600   シップＨＤ            SHIP HEALTHCARE HOLDINGS,INC.      シップヘルスケアホールディングス   A           6050        20220912
   20 │ 65570   Ｇ−ＡＩＡＩ           AIAI Group Corporation             ＡＩＡＩグループ                   C           9050        20220912
   21 │ 64720   ＮＴＮ                NTN CORPORATION                    ＮＴＮ                             A           3600        20220912
  ⋮   │   ⋮              ⋮                            ⋮                                  ⋮                      ⋮           ⋮           ⋮
 4209 │ 30540   ハイパー              HYPER Inc.                         （株）ハイパー                     A           6050        20220912
 4210 │ 70960   Ｇ−ステムセル研究所   StemCell Institute                 （株）ステムセル研究所             C           9050        20220912
 4211 │ 66430   戸上電                Togami Electric Mfg.Co.,Ltd.       （株）戸上電機製作所               B           3650        20220912
 4212 │ 34950   香陵住販              Koryojyuhan Co.,Ltd.               香陵住販                           B           8050        20220912
 4213 │ 52040   石塚硝                ISHIZUKA GLASS CO.,LTD.            石塚硝子                           B           3400        20220912
 4214 │ 47480   構造計画              KOZO KEIKAKU ENGINEERING Inc.      （株）構造計画研究所               B           5250        20220912
 4215 │ 93270   イー・ロジット        e-LogiT co.,ltd.                   （株）イー・ロジット               B           5200        20220912
 4216 │ 90290   ヒガシ２１            HIGASHI TWENTY ONE CO.,LTD.        （株）ヒガシトゥエンティワン       B           5050        20220912
 4217 │ 94680   ＫＡＤＯＫＡＷＡ      KADOKAWA CORPORATION               （株）ＫＡＤＯＫＡＷＡ             A           5250        20220912
 4218 │ 72960   ＦＣＣ                F.C.C.CO.,LTD.                     （株）エフ・シー・シー             A           3700        20220912
 4219 │ 13580   上場日経２倍          Listed Index Fund Nikkei Leverag…  日興アセットマネジメント株式会社…  5           9999        20220912
 4220 │ 90330   広電鉄                Hiroshima Electric Railway Co.,L…  広島電鉄                           B           5050        20220912
 4221 │ 88600   フジ住宅              FUJI CORPORATION LIMITED           フジ住宅                           A           8050        20220912
 4222 │ 59850   サンコール            SUNCALL CORPORATION                サンコール                         A           3550        20220912
 4223 │ 49740   タカラバイオ          TAKARA BIO INC.                    タカラバイオ                       A           3200        20220912
 4224 │ 61110   旭精機                ASAHI-SEIKI MANUFACTURING CO.,LT…  旭精機工業                                     3600        20220912
 4225 │ 97680   いであ                IDEA Consultants,Inc.              いであ                             B           9050        20220912
 4226 │ 26270   ＧＸｅコマース日株    Global X E-Commerce Japan ETF      Ｇｌｏｂａｌ　Ｘ　Ｊａｐａｎ株式…  5           9999        20220912
 4227 │ 40970   高圧ガス              KOATSU GAS KOGYO CO.,LTD.          高圧ガス工業                       A           3200        20220912
 4228 │ 46130   関ペイント            KANSAI PAINT CO.,LTD.              関西ペイント                       A           3200        20220912
 4229 │ 71670   めぶきＦＧ            Mebuki Financial Group,Inc.        （株）めぶきフィナンシャルグルー…  A           7050        20220912
                                                                                                                              4187 rows omitted

```


```jldoctest
julia> getinfo(code="86970")
1×7 DataFrame
 Row │ Code    CompanyName  CompanyNameEnglish         CompanyNameFull           MarketCode  SectorCode  UpdateDate
     │ String  String       String                     String                    String      String      String
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 86970   ＪＰＸ       Japan Exchange Group,Inc.  （株）日本取引所グループ  A           7200        20220912
```

"""
function getinfo(;code="")
    listed_infos = get(ListedInfo; query=["code"=>code])["info"]
    vcat(DataFrame.(listed_infos)...)
end

"""
    getsections()

Return `DataFrame` of the sector informations (in Japanese) defined by Tokyo Stock Exchange.

The details of this API are [here](https://jpx.gitbook.io/j-quants-api-en/api-reference/listed-api#sector-information).

```jldoctest
julia> getsections()
34×2 DataFrame
 Row │ SectorCode  SectorName
     │ String      String
─────┼──────────────────────────────────
   1 │ 7150        保険業
   2 │ 5250        情報・通信業
   3 │ 7100        証券、商品先物取引業
   4 │ 3350        ゴム製品
   5 │ 7050        銀行業
   6 │ 1050        鉱業
   7 │ 6050        卸売業
   8 │ 3150        パルプ・紙
   9 │ 3650        電気機器
  10 │ 3800        その他製品
  11 │ 6100        小売業
  12 │ 9050        サービス業
  13 │ 5100        海運業
  14 │ 3600        機械
  15 │ 5150        空運業
  16 │ 3700        輸送用機器
  17 │ 3500        非鉄金属
  18 │ 5200        倉庫・運輸関連業
  19 │ 3550        金属製品
  20 │ 2050        建設業
  21 │ 8050        不動産業
  22 │ 3450        鉄鋼
  23 │ 3300        石油・石炭製品
  24 │ 3400        ガラス・土石製品
  25 │ 3050        食料品
  26 │ 5050        陸運業
  27 │ 3750        精密機器
  28 │ 3250        医薬品
  29 │ 7200        その他金融業
  30 │ 3100        繊維製品
  31 │ 4050        電気・ガス業
  32 │ 9999        (その他)
  33 │ 3200        化学
  34 │ 0050        水産・農林業
```
"""
function getsections()
    listed_sections = get(ListedSections)["sections"]
    vcat(DataFrame.(listed_sections)...)
end


function getdailyquotes(;code=nothing, from=nothing, to=nothing, date=nothing)
    if isnothing(code) && !isnothing(date)
        query = ["date"=>date]
    elseif !isnothing(code)
        if isnothing(from) || isnothing(to)
            query = ["code"=>code]
        else
            query = ["code"=>code, "from"=>from, "to"=>to]
        end
    else
        @show code, from, to, date
        error("Unsupported combination.")
    end

    daily_quotes = get(PricesDailyQuotes; query=query)["daily_quotes"]
    vcat(DataFrame.(daily_quotes)...)
end

function getfinstatements(;code=nothing, date=nothing)
    if !(isnothing(code) ⊻ isnothing(date))
        error("Only one of \"code\" or \"date\" must be specified.")
    end
    
    if isnothing(code) # i.e. 'date' is not nothing
        query = ["date"=>date]
    else
        query = ["code"=>code]
    end

    statesments = get(FinsStatements, query=query)["statements"]
    vcat(DataFrame.(statesments)...)
end

function getfinannouncement()
    announcement = get(FinsAnnouncement)["announcement"]
    vcat(DataFrame.(announcement)...)
end
