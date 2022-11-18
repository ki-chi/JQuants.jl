"""
    date2str(x)

Convert `x` to "yyyy-mm-dd" formated string if `x` is `Date`.
"""
date2str(x) = error("argument 'x' must be AbstractSttinrg or Date.")
date2str(x::AbstractString) = x
date2str(x::Date) = Dates.format(x, "yyyy-mm-dd")


"""
    getinfo(;code::AbstractString = "", date::Union{AbstractString, Date} = "")

Return `DataFrame` holding the information of listed securities on the Tokyo Stock Exchange,
Nagoya Stock Exchange, Sapporo Stock Exchange, and Fukuoka Stock Exchange.

It returns all listed information if you do not specify the argument `code`. 

The details of this API are [here](https://jpx.gitbook.io/j-quants-api-en/api-reference/listed-api).

# Examples

```jldoctest
julia> getinfo()
4223×10 DataFrame
  Row │ Code    CompanyName                        Date      MarketCode  MarketCodeName  ScaleCategory  Sector17Code  Sector17CodeName          Sector33Code  Sector33CodeName
      │ String  String                             String    String      String          String         String        String                    String        String
──────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    1 │ 13010   極洋                               20221119  111         プライム        TOPIX Small 2  1             食品                      50            水産・農林業
    2 │ 13050   ダイワ上場投信−トピックス          20221119  109         その他          -              99            その他                    9999          その他
    3 │ 13060   ＮＥＸＴＦＵＮＤＳＴＯＰＩＸ連動…  20221119  109         その他          -              99            その他                    9999          その他
    4 │ 13080   上場インデックスファンドＴＯＰＩ…  20221119  109         その他          -              99            その他                    9999          その他
    5 │ 13090   ＮＥＸＴＦＵＮＤＳＣｈｉｎａＡＭ…  20221119  109         その他          -              99            その他                    9999          その他
  ⋮   │   ⋮                     ⋮                     ⋮          ⋮             ⋮               ⋮             ⋮                   ⋮                   ⋮               ⋮
 4219 │ 99930   ヤマザワ                           20221119  112         スタンダード    TOPIX Small 2  14            小売                      6100          小売業
 4220 │ 99940   やまや                             20221119  112         スタンダード    TOPIX Small 2  14            小売                      6100          小売業
 4221 │ 99950   グローセル                         20221119  111         プライム        TOPIX Small 2  13            商社・卸売                6050          卸売業
 4222 │ 99960   サトー商会                         20221119  112         スタンダード    -              13            商社・卸売                6050          卸売業
 4223 │ 99970   ベルーナ                           20221119  111         プライム        TOPIX Small 1  14            小売                      6100          小売業
```


```jldoctest
julia> getinfo(code="86970")
1×10 DataFrame
 Row │ Code    CompanyName         Date      MarketCode  MarketCodeName  ScaleCategory  Sector17Code  Sector17CodeName  Sector33Code  Sector33CodeName
     │ String  String              String    String      String          String         String        String            String        String
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 86970   日本取引所グループ  20221119  111         プライム        TOPIX Large70  16            金融（除く銀行）  7200          その他金融業
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

"""
    getdailyquotes(; code::AbstractString = "",
                   from::Union{AbstractString, Date} = "",
                   to::Union{AbstractString, Date} = "",
                   date::Union{AbstractString, Date} = "")

Return `DataFrame` holding daily stock price information. 

You should choose the combination of valid parameters in the function
from three patterns below:

1. Pass `code`: All historical stock prices of a specific issue
2. Pass `code`, `from`, and `to`: Stock prices of a specific issue for the specified period
3. Pass `date`: All listed issue prices for the specific date

Note: either `code` or `date` must be specified.

Arguments

- `code::AbstractString=""`: issue code (e.g. \"27800\" or \"2780\")
- `from::Union{AbstractString, Date}=""`: starting point of data period （e.g. \"20210901\" or \"2021-09-01\"）
- `to::Union{AbstractString, Date}=""`: end point of data period （e.g. \"20210907\" or \"2021-09-07\"）
- `date::Union{AbstractString, Date}=""`: data of data （e.g. \"20210907\" or \"2021-09-07\"）

The details of this API are [here](https://jpx.gitbook.io/j-quants-api-en/api-reference/prices-api#daily-stock-price-information).

# Examples

```jldoctest
julia> getdailyquotes(code="86970")
1390×14 DataFrame
  Row │ AdjustmentClose  AdjustmentFactor  AdjustmentHigh  AdjustmentLow  AdjustmentOpen  AdjustmentVolume  Close   Code    Date      High    Low     Open    TurnoverValue  Volume
      │ Union…           Float64           Union…          Union…         Union…          Union…            Union…  String  String    Union…  Union…  Union…  Union…         Union…
──────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    1 │ 1706.0                        1.0  1713.0          1681.0         1690.0          1.999e6           1706.0  86970   20170104  1713.0  1681.0  1690.0  3.40143e9      1.999e6
    2 │ 1712.0                        1.0  1716.0          1696.0         1703.0          2.1371e6          1712.0  86970   20170105  1716.0  1696.0  1703.0  3.65372e9      2.1371e6
    3 │ 1691.0                        1.0  1698.0          1688.0         1694.0          1.6784e6          1691.0  86970   20170106  1698.0  1688.0  1694.0  2.84135e9      1.6784e6
    4 │ 1664.0                        1.0  1688.0          1662.0         1682.0          1.8836e6          1664.0  86970   20170110  1688.0  1662.0  1682.0  3.14754e9      1.8836e6
    5 │ 1687.0                        1.0  1702.0          1682.0         1700.0          1.7861e6          1687.0  86970   20170111  1702.0  1682.0  1700.0  3.01924e9      1.7861e6
    6 │ 1682.0                        1.0  1693.0          1671.0         1685.0          1.9381e6          1682.0  86970   20170112  1693.0  1671.0  1685.0  3.26701e9      1.9381e6
    7 │ 1692.0                        1.0  1704.0          1673.0         1683.0          1.6462e6          1692.0  86970   20170113  1704.0  1673.0  1683.0  2.77886e9      1.6462e6
    8 │ 1673.0                        1.0  1690.0          1668.0         1684.0          941900.0          1673.0  86970   20170116  1690.0  1668.0  1684.0  1.57804e9      941900.0
    9 │ 1642.0                        1.0  1675.0          1641.0         1675.0          1.2122e6          1642.0  86970   20170117  1675.0  1641.0  1675.0  1.99925e9      1.2122e6
   10 │ 1661.0                        1.0  1664.0          1636.0         1645.0          1.3235e6          1661.0  86970   20170118  1664.0  1636.0  1645.0  2.18785e9      1.3235e6
   11 │ 1659.0                        1.0  1684.0          1653.0         1679.0          1.3038e6          1659.0  86970   20170119  1684.0  1653.0  1679.0  2.16927e9      1.3038e6
   12 │ 1632.0                        1.0  1650.0          1624.0         1650.0          2.2629e6          1632.0  86970   20170120  1650.0  1624.0  1650.0  3.6977e9       2.2629e6
   13 │ 1586.0                        1.0  1608.0          1585.0         1599.0          2.6611e6          1586.0  86970   20170123  1608.0  1585.0  1599.0  4.23923e9      2.6611e6
   14 │ 1570.0                        1.0  1579.0          1555.0         1563.0          2.0087e6          1570.0  86970   20170124  1579.0  1555.0  1563.0  3.15693e9      2.0087e6
   15 │ 1560.0                        1.0  1610.0          1549.0         1596.0          3.1307e6          1560.0  86970   20170125  1610.0  1549.0  1596.0  4.89873e9      3.1307e6
   16 │ 1580.0                        1.0  1592.0          1570.0         1585.0          1.4269e6          1580.0  86970   20170126  1592.0  1570.0  1585.0  2.25742e9      1.4269e6
   17 │ 1580.0                        1.0  1595.0          1576.0         1587.0          1.3322e6          1580.0  86970   20170127  1595.0  1576.0  1587.0  2.10922e9      1.3322e6
   18 │ 1653.0                        1.0  1674.0          1575.0         1580.0          3.5799e6          1653.0  86970   20170130  1674.0  1575.0  1580.0  5.87341e9      3.5799e6
   19 │ 1685.0                        1.0  1735.0          1674.0         1675.0          3.8894e6          1685.0  86970   20170131  1735.0  1674.0  1675.0  6.61842e9      3.8894e6
   20 │ 1667.0                        1.0  1675.0          1648.0         1669.0          1.7512e6          1667.0  86970   20170201  1675.0  1648.0  1669.0  2.91227e9      1.7512e6
   21 │ 1614.0                        1.0  1674.0          1610.0         1669.0          1.8843e6          1614.0  86970   20170202  1674.0  1610.0  1669.0  3.0631e9       1.8843e6
   22 │ 1622.0                        1.0  1653.0          1621.0         1622.0          2.4143e6          1622.0  86970   20170203  1653.0  1621.0  1622.0  3.94023e9      2.4143e6
  ⋮   │        ⋮                ⋮                ⋮               ⋮              ⋮                ⋮            ⋮       ⋮        ⋮        ⋮       ⋮       ⋮           ⋮           ⋮
 1370 │ 2172.0                        1.0  2209.0          2162.5         2208.5          1.6495e6          2172.0  86970   20220812  2209.0  2162.5  2208.5  3.60256e9      1.6495e6
 1371 │ 2191.5                        1.0  2193.5          2164.0         2173.0          645700.0          2191.5  86970   20220815  2193.5  2164.0  2173.0  1.41011e9      645700.0
 1372 │ 2182.0                        1.0  2200.5          2178.0         2197.0          684500.0          2182.0  86970   20220816  2200.5  2178.0  2197.0  1.49572e9      684500.0
 1373 │ 2223.5                        1.0  2226.5          2195.0         2198.0          994900.0          2223.5  86970   20220817  2226.5  2195.0  2198.0  2.20712e9      994900.0
 1374 │ 2200.0                        1.0  2224.5          2191.5         2220.5          816400.0          2200.0  86970   20220818  2224.5  2191.5  2220.5  1.79884e9      816400.0
 1375 │ 2171.5                        1.0  2206.5          2169.0         2206.0          828800.0          2171.5  86970   20220819  2206.5  2169.0  2206.0  1.80549e9      828800.0
 1376 │ 2161.5                        1.0  2165.5          2146.0         2154.0          577800.0          2161.5  86970   20220822  2165.5  2146.0  2154.0  1.24705e9      577800.0
 1377 │ 2146.0                        1.0  2155.5          2125.5         2142.5          725600.0          2146.0  86970   20220823  2155.5  2125.5  2142.5  1.5559e9       725600.0
 1378 │ 2144.0                        1.0  2150.0          2134.0         2149.0          620500.0          2144.0  86970   20220824  2150.0  2134.0  2149.0  1.33003e9      620500.0
 1379 │ 2170.0                        1.0  2181.0          2157.5         2167.0          797000.0          2170.0  86970   20220825  2181.0  2157.5  2167.0  1.73014e9      797000.0
 1380 │ 2163.5                        1.0  2191.0          2161.5         2189.5          536900.0          2163.5  86970   20220826  2191.0  2161.5  2189.5  1.16541e9      536900.0
 1381 │ 2072.0                        1.0  2120.0          2071.0         2118.0          1.5405e6          2072.0  86970   20220829  2120.0  2071.0  2118.0  3.21194e9      1.5405e6
 1382 │ 2107.5                        1.0  2115.0          2084.0         2092.5          914000.0          2107.5  86970   20220830  2115.0  2084.0  2092.5  1.923e9        914000.0
 1383 │ 2084.5                        1.0  2095.0          2077.0         2081.5          1.1662e6          2084.5  86970   20220831  2095.0  2077.0  2081.5  2.43159e9      1.1662e6
 1384 │ 2059.0                        1.0  2064.0          2033.0         2052.0          1.1923e6          2059.0  86970   20220901  2064.0  2033.0  2052.0  2.44859e9      1.1923e6
 1385 │ 2062.5                        1.0  2071.5          2052.5         2059.0          974900.0          2062.5  86970   20220902  2071.5  2052.5  2059.0  2.00996e9      974900.0
 1386 │ 2057.5                        1.0  2062.5          2047.0         2052.5          639900.0          2057.5  86970   20220905  2062.5  2047.0  2052.5  1.31607e9      639900.0
 1387 │ 2035.0                        1.0  2060.0          2026.5         2049.5          1.0251e6          2035.0  86970   20220906  2060.0  2026.5  2049.5  2.08953e9      1.0251e6
 1388 │ 2068.5                        1.0  2075.0          2031.5         2036.0          1.2172e6          2068.5  86970   20220907  2075.0  2031.5  2036.0  2.50871e9      1.2172e6
 1389 │ 2092.0                        1.0  2097.0          2073.0         2087.0          1.4061e6          2092.0  86970   20220908  2097.0  2073.0  2087.0  2.9351e9       1.4061e6
 1390 │ 2096.0                        1.0  2100.0          2067.0         2073.0          1.7931e6          2096.0  86970   20220909  2100.0  2067.0  2073.0  3.73586e9      1.7931e6
                                                                                                                                                                     1347 rows omitted
```

```jldoctest
julia> getdailyquotes(date="2022-09-09")
4194×14 DataFrame
  Row │ AdjustmentClose  AdjustmentFactor  AdjustmentHigh  AdjustmentLow  AdjustmentOpen  AdjustmentVolume  Close    Code    Date      High     Low      Open     TurnoverValue  Volume
      │ Union…           Float64           Union…          Union…         Union…          Union…            Union…   String  String    Union…   Union…   Union…   Union…         Union…
──────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    1 │ 3650.0                        1.0  3665.0          3600.0         3600.0          17700.0           3650.0   13010   20220909  3665.0   3600.0   3600.0   6.41995e7      17700.0
    2 │ 2049.0                        1.0  2053.0          2041.0         2047.5          144580.0          2049.0   13050   20220909  2053.0   2041.0   2047.5   2.95961e8      144580.0
    3 │ 2029.0                        1.0  2032.0          2019.0         2023.0          1.56714e6         2029.0   13060   20220909  2032.0   2019.0   2023.0   3.17597e9      1.56714e6
    4 │ 2003.0                        1.0  2008.0          1997.0         1999.5          268200.0          2003.0   13080   20220909  2008.0   1997.0   1999.5   5.36422e8      268200.0
    5 │ 43000.0                       1.0  43300.0         42340.0        43100.0         135.0             43000.0  13090   20220909  43300.0  42340.0  43100.0  5.79351e6      135.0
    6 │ 937.4                         1.0  943.3           937.0          939.9           4590.0            937.4    13110   20220909  943.3    937.0    939.9    4.31443e6      4590.0
    7 │ 20065.0                       1.0  20065.0         20065.0        20065.0         4.0               20065.0  13120   20220909  20065.0  20065.0  20065.0  80260.0        4.0
    8 │ 3251.0                        1.0  3252.0          3251.0         3252.0          90.0              3251.0   13130   20220909  3252.0   3251.0   3252.0   292610.0       90.0
    9 │ 356.9                         1.0  356.9           356.9          356.9           1000.0            356.9    13190   20220909  356.9    356.9    356.9    356900.0       1000.0
   10 │ 28845.0                       1.0  28895.0         28700.0        28820.0         38225.0           28845.0  13200   20220909  28895.0  28700.0  28820.0  1.10184e9      38225.0
   11 │ 28930.0                       1.0  28995.0         28790.0        28920.0         223706.0          28930.0  13210   20220909  28995.0  28790.0  28920.0  6.46669e9      223706.0
   12 │ 8315.0                        1.0  8315.0          8223.0         8250.0          1060.0            8315.0   13220   20220909  8315.0   8223.0   8250.0   8.75058e6      1060.0
   13 │                               1.0                                                                            13240   20220909
   14 │ 201.0                         1.0  201.1           200.0          200.0           5500.0            201.0    13250   20220909  201.1    200.0    200.0    1.10263e6      5500.0
   15 │ 22890.0                       1.0  22985.0         22850.0        22940.0         10578.0           22890.0  13260   20220909  22985.0  22850.0  22940.0  2.42452e8      10578.0
   16 │ 6141.0                        1.0  6167.0          6132.0         6151.0          5810.0            6141.0   13280   20220909  6167.0   6132.0   6151.0   3.57613e7      5810.0
   17 │ 29095.0                       1.0  29150.0         28950.0        29090.0         10860.0           29095.0  13290   20220909  29150.0  28950.0  29090.0  3.15749e8      10860.0
   18 │ 28965.0                       1.0  29020.0         28825.0        28935.0         34170.0           28965.0  13300   20220909  29020.0  28825.0  28935.0  9.88916e8      34170.0
   19 │ 552.0                         1.0  554.0           546.0          547.0           1.5187e6          552.0    13320   20220909  554.0    546.0    547.0    8.3395e8       1.5187e6
   20 │ 2453.0                        1.0  2463.0          2419.0         2440.0          467000.0          2453.0   13330   20220909  2463.0   2419.0   2440.0   1.14064e9      467000.0
   21 │ 2180.5                        1.0  2184.0          2165.5         2165.5          183180.0          2180.5   13430   20220909  2184.0   2165.5   2165.5   3.99248e8      183180.0
   22 │ 2047.0                        1.0  2048.5          2037.0         2037.5          8100.0            2047.0   13450   20220909  2048.5   2037.0   2037.5   1.65685e7      8100.0
  ⋮   │        ⋮                ⋮                ⋮               ⋮              ⋮                ⋮             ⋮       ⋮        ⋮         ⋮        ⋮        ⋮           ⋮            ⋮
 4174 │ 325.0                         1.0  330.0           324.0          324.0           73100.0           325.0    99720   20220909  330.0    324.0    324.0    2.38981e7      73100.0
 4175 │ 27.0                          1.0  28.0            27.0           27.0            788700.0          27.0     99730   20220909  28.0     27.0     27.0     2.13666e7      788700.0
 4176 │ 5450.0                        1.0  5480.0          5390.0         5390.0          14400.0           5450.0   99740   20220909  5480.0   5390.0   5390.0   7.8115e7       14400.0
 4177 │                               1.0                                                                            99760   20220909
 4178 │ 2653.0                        1.0  2665.0          2653.0         2654.0          500.0             2653.0   99770   20220909  2665.0   2653.0   2654.0   1.3291e6       500.0
 4179 │ 46.0                          1.0  48.0            46.0           47.0            379800.0          46.0     99780   20220909  48.0     46.0     47.0     1.75814e7      379800.0
 4180 │ 1109.0                        1.0  1127.0          1109.0         1109.0          27700.0           1109.0   99790   20220909  1127.0   1109.0   1109.0   3.09e7         27700.0
 4181 │ 109.0                         1.0  110.0           109.0          110.0           55000.0           109.0    99800   20220909  110.0    109.0    110.0    6.0189e6       55000.0
 4182 │ 774.0                         1.0  775.0           750.0          750.0           37000.0           774.0    99820   20220909  775.0    750.0    750.0    2.81852e7      37000.0
 4183 │ 83280.0                       1.0  84680.0         83280.0        84610.0         784700.0          83280.0  99830   20220909  84680.0  83280.0  84610.0  6.59618e10     784700.0
 4184 │ 5500.0                        1.0  5535.0          5428.0         5510.0          1.361e7           5500.0   99840   20220909  5535.0   5428.0   5510.0   7.46429e10     1.361e7
 4185 │ 1799.0                        1.0  1820.0          1797.0         1797.0          6200.0            1799.0   99860   20220909  1820.0   1797.0   1797.0   1.11685e7      6200.0
 4186 │ 3300.0                        1.0  3320.0          3280.0         3280.0          182500.0          3300.0   99870   20220909  3320.0   3280.0   3280.0   6.01202e8      182500.0
 4187 │ 3430.0                        1.0  3450.0          3415.0         3435.0          266300.0          3430.0   99890   20220909  3450.0   3415.0   3435.0   9.14459e8      266300.0
 4188 │ 640.0                         1.0  662.0           640.0          659.0           65600.0           640.0    99900   20220909  662.0    640.0    659.0    4.26735e7      65600.0
 4189 │ 815.0                         1.0  815.0           809.0          811.0           23700.0           815.0    99910   20220909  815.0    809.0    811.0    1.92387e7      23700.0
 4190 │ 1303.0                        1.0  1304.0          1300.0         1300.0          9200.0            1303.0   99930   20220909  1304.0   1300.0   1300.0   1.19678e7      9200.0
 4191 │ 2583.0                        1.0  2583.0          2568.0         2568.0          4700.0            2583.0   99940   20220909  2583.0   2568.0   2568.0   1.20815e7      4700.0
 4192 │ 430.0                         1.0  434.0           428.0          429.0           78100.0           430.0    99950   20220909  434.0    428.0    429.0    3.36048e7      78100.0
 4193 │ 1210.0                        1.0  1210.0          1201.0         1201.0          700.0             1210.0   99960   20220909  1210.0   1201.0   1201.0   843500.0       700.0
 4194 │ 729.0                         1.0  732.0           725.0          727.0           280400.0          729.0    99970   20220909  732.0    725.0    727.0    2.0404e8       280400.0
                                                                                                                                                                          4151 rows omitted
```

"""
function getdailyquotes(;code::AbstractString="", from::Union{AbstractString, Date}="",
                        to::Union{AbstractString, Date}="", date::Union{AbstractString, Date}="")
    # Type conversion
    from_str = date2str(from)
    to_str = date2str(to)
    date_str = date2str(date)

    if isempty(code) && !isempty(date_str)
        query = ["date"=>date_str]
    elseif !isempty(code)
        if isempty(from_str) || isempty(to_str)
            query = ["code"=>code]
        else
            query = ["code"=>code, "from"=>from_str, "to"=>to_str]
        end
    else
        @show code, from, to, date
        error("Unsupported combination.")
    end

    daily_quotes = get(PricesDailyQuotes; query=query)["daily_quotes"]
    vcat(DataFrame.(daily_quotes)...)
end

"""
    getfinstatements(; code::AbstractString = "", date::Union{AbstractString, Date} = "")

Return `DataFrame` holding financial statements based on quarterly disclosures.

Either `code` or `date` must be specified.

- If you specify `code`, you get all historical financial statements of the specified stock.
- If you specify `date`, you get all financial statements disclosed on the day.

Arguments

- `code::AbstractString=""`: issue code
- `date::Union{AbstractString, Date}=""`: disclosure date 

# Examples

These examples display the limited columns of data.

```jldoctest
julia> fs = getfinstatements(code="86970");

julia> fs[!,[:LocalCode, :CurrentFiscalYearEndDate, :CurrentPeriodEndDate, :DisclosedDate, :TypeOfCurrentPeriod, :TypeOfDocument, :TotalAssets]]
29×7 DataFrame
 Row │ LocalCode  CurrentFiscalYearEndDate  CurrentPeriodEndDate  DisclosedDate  TypeOfCurrentPeriod  TypeOfDocument                     TotalAssets
     │ String     String                    String                String         String               String                             String
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 86970      2017-03-31                2016-12-31            2017-01-30     3Q                   3QFinancialStatements_Consolidat…  40450677000000
   2 │ 86970      2017-03-31                2017-03-31            2017-03-22     FY                   ForecastRevision
   3 │ 86970      2017-03-31                2017-03-31            2017-04-28     FY                   FYFinancialStatements_Consolidat…  41288932000000
   4 │ 86970      2018-03-31                2017-06-30            2017-07-28     1Q                   1QFinancialStatements_Consolidat…  37878487000000
   5 │ 86970      2018-03-31                2017-09-30            2017-10-30     2Q                   2QFinancialStatements_Consolidat…  42523504000000
   6 │ 86970      2018-03-31                2017-12-31            2018-01-31     3Q                   3QFinancialStatements_Consolidat…  37987261000000
   7 │ 86970      2018-03-31                2018-03-31            2018-03-22     FY                   ForecastRevision
   8 │ 86970      2018-03-31                2018-03-31            2018-04-27     FY                   FYFinancialStatements_Consolidat…  41316341000000
   9 │ 86970      2019-03-31                2018-06-30            2018-07-30     1Q                   1QFinancialStatements_Consolidat…  35842130000000
  10 │ 86970      2019-03-31                2018-09-30            2018-10-29     2Q                   2QFinancialStatements_Consolidat…  42544750000000
  11 │ 86970      2019-03-31                2018-12-31            2019-01-29     3Q                   3QFinancialStatements_Consolidat…  55009203000000
  12 │ 86970      2019-03-31                2019-03-31            2019-04-26     FY                   FYFinancialStatements_Consolidat…  54069405000000
  13 │ 86970      2020-03-31                2019-06-30            2019-07-30     1Q                   1QFinancialStatements_Consolidat…  56422396000000
  14 │ 86970      2020-03-31                2020-03-31            2019-09-25     FY                   ForecastRevision
  15 │ 86970      2020-03-31                2019-09-30            2019-10-30     2Q                   2QFinancialStatements_Consolidat…  68410143000000
  16 │ 86970      2020-03-31                2019-12-31            2020-01-30     3Q                   3QFinancialStatements_Consolidat…  56671198000000
  17 │ 86970      2020-03-31                2020-03-31            2020-03-23     FY                   ForecastRevision
  18 │ 86970      2020-03-31                2020-03-31            2020-04-30     FY                   FYFinancialStatements_Consolidat…  67286302000000
  19 │ 86970      2021-03-31                2020-06-30            2020-07-29     1Q                   1QFinancialStatements_Consolidat…  60827068000000
  20 │ 86970      2021-03-31                2020-09-30            2020-10-28     2Q                   2QFinancialStatements_Consolidat…  60545559000000
  21 │ 86970      2021-03-31                2020-12-31            2021-01-28     3Q                   3QFinancialStatements_Consolidat…  59393100000000
  22 │ 86970      2021-03-31                2021-03-31            2021-03-22     FY                   ForecastRevision
  23 │ 86970      2021-03-31                2021-03-31            2021-04-28     FY                   FYFinancialStatements_Consolidat…  60075678000000
  24 │ 86970      2022-03-31                2021-06-30            2021-07-28     1Q                   1QFinancialStatements_Consolidat…  61301218000000
  25 │ 86970      2022-03-31                2021-09-30            2021-10-27     2Q                   2QFinancialStatements_Consolidat…  59583064000000
  26 │ 86970      2022-03-31                2021-12-31            2022-01-27     3Q                   3QFinancialStatements_Consolidat…  62076519000000
  27 │ 86970      2022-03-31                2022-03-31            2022-03-22     FY                   ForecastRevision
  28 │ 86970      2022-03-31                2022-03-31            2022-04-26     FY                   FYFinancialStatements_Consolidat…  71463434000000
  29 │ 86970      2023-03-31                2022-06-30            2022-07-27     1Q                   1QFinancialStatements_Consolidat…  76048180000000
```

```jldoctest
julia> fs = getfinstatements(date="2022-01-05");

julia> fs[!,[:LocalCode, :CurrentFiscalYearEndDate, :CurrentPeriodEndDate, :DisclosedDate, :TypeOfCurrentPeriod, :TypeOfDocument, :TotalAssets]]
12×7 DataFrame
 Row │ LocalCode  CurrentFiscalYearEndDate  CurrentPeriodEndDate  DisclosedDate  TypeOfCurrentPeriod  TypeOfDocument                     TotalAssets
     │ String     String                    String                String         String               String                             String
─────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 27530      2022-03-31                2021-12-31            2022-01-05     3Q                   3QFinancialStatements_Consolidat…  24937000000
   2 │ 97930      2022-02-28                2021-11-30            2022-01-05     3Q                   3QFinancialStatements_Consolidat…  97786000000
   3 │ 97930      2022-02-28                2022-02-28            2022-01-05     FY                   ForecastRevision
   4 │ 27890      2022-02-28                2021-11-30            2022-01-05     3Q                   3QFinancialStatements_Consolidat…  5878000000
   5 │ 13760      2022-05-31                2021-11-30            2022-01-05     2Q                   2QFinancialStatements_Consolidat…  38635000000
   6 │ 17120      2022-02-28                2021-11-30            2022-01-05     3Q                   3QFinancialStatements_Consolidat…  22853000000
   7 │ 65520      2022-05-31                2021-11-30            2022-01-05     2Q                   2QFinancialStatements_Consolidat…  4891000000
   8 │ 76790      2022-02-28                2021-11-30            2022-01-05     3Q                   3QFinancialStatements_Consolidat…  64392000000
   9 │ 26590      2022-02-28                2021-11-30            2022-01-05     3Q                   3QFinancialStatements_Consolidat…  164870000000
  10 │ 38250      2022-03-31                2022-03-31            2022-01-05     FY                   ForecastRevision
  11 │ 99770      2022-02-28                2021-11-30            2022-01-05     3Q                   3QFinancialStatements_NonConsoli…  30476000000
  12 │ 32820      2022-01-31                2022-01-31            2022-01-05     FY                   ForecastRevision_REIT
```

"""
function getfinstatements(;code::AbstractString="", date::Union{AbstractString, Date}="")
    # Type conversion
    date_str = date2str(date)

    if !(isempty(code) ⊻ isempty(date_str))
        error("Only one of \"code\" or \"date\" must be specified.")
    end
    
    if isempty(code) # i.e. 'date' is not nothing
        query = ["date"=>date_str]
    else
        query = ["code"=>code]
    end

    statesments = get(FinsStatements, query=query)["statements"]
    vcat(DataFrame.(statesments)...)
end

"""
    getfinannouncement()

Return `DataFrame` holding the scheduled financial announcement of next-day.

It will be updated at around 19:00 (JST) only when there is an update at the following site.
[https://www.jpx.co.jp/listing/event-schedules/financial-announcement/index.html](https://www.jpx.co.jp/listing/event-schedules/financial-announcement/index.html)

If there is no update at the site, this functions' return remeins old schedules.

The details of this API are [here](https://jpx.gitbook.io/j-quants-api-en/api-reference/finance-api#next-day-financial-announcement).

# Examples

```jldoctest
julia> getfinannouncement()
54×7 DataFrame
 Row │ Code    CompanyName                        Date      FiscalQuarter  FiscalYear  Section       SectorName
     │ String  String                             String    String         String      String        String
─────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 34090   北日本紡績                         20220815  第１四半期     3月31日     スタンダード  繊維製品
   2 │ 70920   Ｆａｓｔ　Ｆｉｔｎｅｓｓ　Ｊａｐ…  20220815  第１四半期     3月31日     プライム      サービス業
   3 │ 39890   シェアリングテクノロジー           20220815  第３四半期     9月30日     グロース      情報・通信業
   4 │ 14470   ＩＴｂｏｏｋホールディングス       20220815  第１四半期     3月31日     グロース      建設業
   5 │ 44450   リビン・テクノロジーズ             20220815  第３四半期     9月30日     グロース      情報・通信業
   6 │ 70620   フレアス                           20220815  第１四半期     3月31日     グロース      サービス業
   7 │ 38580   ユビキタスＡＩ                     20220815  第１四半期     3月31日     スタンダード  情報・通信業
   8 │ 65510   ツナググループ・ホールディングス   20220815  第３四半期     9月30日     スタンダード  サービス業
   9 │ 61980   キャリア                           20220815  第３四半期     9月30日     グロース      サービス業
  10 │ 75710   ヤマノホールディングス             20220815  第１四半期     3月31日     スタンダード  小売業
  11 │ 99270   ワットマン                         20220815  第１四半期     3月31日     スタンダード  小売業
  12 │ 61670   冨士ダイス                         20220815  第１四半期     3月31日     プライム      機械
  13 │ 63430   フリージア・マクロス               20220815  第１四半期     3月31日     スタンダード  機械
  14 │ 46530   ダイオーズ                         20220815  第１四半期     3月31日     プライム      サービス業
  15 │ 69420   ソフィアホールディングス           20220815  第１四半期     3月31日     スタンダード  情報・通信業
  16 │ 87460   第一商品                           20220815  第１四半期     3月31日     スタンダード  証券、商品先物取引業
  17 │ 39000   クラウドワークス                   20220815  第３四半期     9月30日     グロース      情報・通信業
  18 │ 17570   中小企業ホールディングス           20220815  第１四半期     3月31日     スタンダード  建設業
  19 │ 93180   アジア開発キャピタル               20220815  第１四半期     3月31日     スタンダード  証券、商品先物取引業
  20 │ 87370   あかつき本社                       20220815  第１四半期     3月31日     スタンダード  証券、商品先物取引業
  21 │ 14430   技研ホールディングス               20220815  第１四半期     3月31日     スタンダード  建設業
  ⋮  │   ⋮                     ⋮                     ⋮            ⋮            ⋮            ⋮                 ⋮
  34 │ 70840   Ｋｉｄｓ　Ｓｍｉｌｅ　Ｈｏｌｄｉ…  20220815  第１四半期     3月31日     グロース      サービス業
  35 │ 23880   ウェッジホールディングス           20220815  第３四半期     9月30日     グロース      その他金融業
  36 │ 90820   大和自動車交通                     20220815  第１四半期     3月31日     スタンダード  陸運業
  37 │ 76380   ＮＥＷ　ＡＲＴ　ＨＯＬＤＩＮＧＳ   20220815  第１四半期     3月31日     スタンダード  小売業
  38 │ 21340   燦キャピタルマネージメント         20220815  第１四半期     3月31日     スタンダード  サービス業
  39 │ 70780   ＩＮＣＬＵＳＩＶＥ                 20220815  第１四半期     3月31日     グロース      サービス業
  40 │ 95530   マイクロアド                       20220815  第３四半期     9月30日     グロース      サービス業
  41 │ 44230   アルテリア・ネットワークス         20220815  第１四半期     3月31日     プライム      情報・通信業
  42 │ 74620   ＣＡＰＩＴＡ                       20220815  第１四半期     3月31日     スタンダード  小売業
  43 │ 41670   ココペリ                           20220815  第１四半期     3月31日     グロース      情報・通信業
  44 │ 52770   スパンクリートコーポレーション     20220815  第１四半期     3月31日     スタンダード  ガラス・土石製品
  45 │ 38400   パス                               20220815  第１四半期     3月31日     スタンダード  情報・通信業
  46 │ 68150   ユニデンホールディングス           20220815  第１四半期     3月31日     プライム      電気機器
  47 │ 47540   トスネット                         20220815  第３四半期     9月30日     スタンダード  サービス業
  48 │ 84730   ＳＢＩホールディングス             20220815  第１四半期     3月31日     プライム      証券、商品先物取引業
  49 │ 39620   チェンジ                           20220815  第１四半期     3月31日     プライム      情報・通信業
  50 │ 39240   ランドコンピュータ                 20220815  第１四半期     3月31日     プライム      情報・通信業
  51 │ 60960   レアジョブ                         20220815  第１四半期     3月31日     プライム      サービス業
  52 │ 44270   ＥｄｕＬａｂ                       20220815  第３四半期     9月30日     グロース      情報・通信業
  53 │ 66160   トレックス・セミコンダクター       20220815  第１四半期     3月31日     プライム      電気機器
  54 │ 80720   日本出版貿易                       20220815  第１四半期     3月31日     スタンダード  卸売業
                                                                                                           12 rows omitted
```

"""
function getfinannouncement()
    announcement = get(FinsAnnouncement)["announcement"]
    vcat(DataFrame.(announcement)...)
end

"""
    gettradesspecs(;section::AbstractString = "", from::Union{Date,AbstractString} = "", to::Union{Date,AbstractString} = "")

Return `DataFrame` holding the investment trend statistics by investor types.

If you specify `section` (ex. "TSEPrime"), you fetch the statistics filtered only for the market section.

If you specify `from` and `to`, the data holds the statistics published between `from` and `to`.


# Example

```jldoctest
julia> trades_specs = gettradesspecs(section="TSEPrime", from="2022-09-01", to="2022-09-08");

julia> size(trades_specs)
(2, 56)                                                                                                                                                                                   47 columns omitted

```

"""
function gettradesspecs(;section::AbstractString="", from::Union{Date,AbstractString}="", to::Union{Date,AbstractString}="")
    from_datestr, to_datestr = date2str(from), date2str(to)
    
    if isempty(section) && isempty(from_datestr) && isempty(to_datestr)
        query = nothing
    elseif !isempty(section)
        if isempty(from_datestr) || isempty(to_datestr)
            query = ["section"=>section]
        else
            query = ["section"=>section, "from"=>from_datestr, "to"=>to_datestr]
        end
    elseif !isempty(from_datestr) || !isempty(to_datestr)
        query = ["from"=>from_datestr, "to"=>to_datestr]
    else 
        @show section, from, to
        error("Unsupported combination.")
    end
    trades_spec = get(MarketsTradeSpec; query=query)["trades_spec"]
    vcat(DataFrame.(trades_spec)...)
end

"""
    gettopix(;from::Union{Date, AbstractString} = "", to::Union{Date,AbstractString} = "")

Return `DataFrame` holding daily TOPIX (Tokyo Stock Price Index) data.

When you specify `from` and `to`, the data holds the TOPIX between them. If not, it contains all available historical data.

```jldoctest
julia> gettopix()
460×5 DataFrame
 Row │ Date      Open     High     Low      Close
     │ String    Float64  Float64  Float64  Float64
─────┼──────────────────────────────────────────────
   1 │ 20210104  1810.45  1811.68  1776.6   1794.59
   2 │ 20210105  1788.63  1797.12  1784.8   1791.22
   3 │ 20210106  1790.86  1802.98  1789.68  1796.18
  ⋮  │    ⋮         ⋮        ⋮        ⋮        ⋮
 457 │ 20221115  1958.22  1966.49  1957.44  1964.22
 458 │ 20221116  1964.48  1966.78  1948.89  1963.29
 459 │ 20221117  1962.79  1972.75  1962.79  1966.28
 460 │ 20221118  1971.79  1976.33  1966.06  1967.03
```

"""
function gettopix(;from::Union{Date, AbstractString} = "", to::Union{Date,AbstractString} = "")
    from_datestr, to_datestr = date2str(from), date2str(to)
    
    if isempty(from_datestr) && isempty(to_datestr)
        query = nothing
    elseif isempty(from_datestr)
        query = ["to"=>to_datestr]
    elseif isempty(to_datestr)
        query = ["from"=>from_datestr]
    else
        query = ["from"=>from_datestr, "to"=>to_datestr]
    end

    topix_prices = get(IndicesTopix; query=query)["topix"]
    vcat(DataFrame.(topix_prices)...)[!, [:Date, :Open, :High, :Low, :Close]]
end
