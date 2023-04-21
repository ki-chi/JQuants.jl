module JQuants

using Dates

using HTTP
using JSON
using DataFrames
using Reexport

export authorize, getinfo, getsections, getdailyquotes,
    getfinstatements, getfinannouncement, gettradesspecs,
    gettopix
    


const JQUANTS_URI = "https://api.jquants.com/v1"

# Endpoints
@enum EndPointKey begin
    TokenAuthUser
    TokenAuthRefresh
    ListedInfo
    PricesDailyQuotes
    PricesAM
    MarketsTradeSpec
    MarketsWeeklyMarginInterest
    MarketsShortSelling
    MarketsBreakdown
    IndicesTopix
    FinsStatements
    FinsDividend
    FinsAnnouncement
    OptionIndexOption
end

const endpoints = Base.ImmutableDict(
    TokenAuthUser => "/token/auth_user",
    TokenAuthRefresh => "/token/auth_refresh",
    ListedInfo => "/listed/info",
    PricesDailyQuotes => "/prices/daily_quotes",
    PricesAM => "/prices/prices_am",
    MarketsTradeSpec => "/markets/trades_spec",
    MarketsWeeklyMarginInterest => "/markets/weekly_margin_interest",
    MarketsShortSelling => "/markets/short_selling",
    MarketsBreakdown => "/markets/breakdown",
    IndicesTopix => "/indices/topix",
    FinsStatements => "/fins/statements",
    FinsDividend => "/fins/dividend",
    FinsAnnouncement => "/fins/announcement",
    OptionIndexOption => "/option/index_option",
)

# Errors
include("errors.jl")

# Get & Post functions
include("http.jl")

# Authorization
include("auth.jl")

# Data types
include("datatypes.jl")

# For market data API
include("get_data.jl")

# Utility functions
include("utils.jl")

end # module
