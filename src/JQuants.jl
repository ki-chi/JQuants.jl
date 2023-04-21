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
    ListedSections
    PricesDailyQuotes
    FinsStatements
    FinsAnnouncement
    MarketsTradeSpec
    IndicesTopix
end

const endpoints = Base.ImmutableDict(
    TokenAuthUser => "/token/auth_user",
    TokenAuthRefresh => "/token/auth_refresh",
    ListedInfo => "/listed/info",
    ListedSections => "/listed/sections",
    PricesDailyQuotes => "/prices/daily_quotes",
    FinsStatements => "/fins/statements",
    FinsAnnouncement => "/fins/announcement",
    MarketsTradeSpec => "/markets/trades_spec",
    IndicesTopix => "/indices/topix"
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
