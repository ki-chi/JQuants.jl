module JQuants

using Dates

using HTTP
using JSON
using DataFrames
using Reexport

# Authorization function
export authorize

# APIs
export fetch
export TokenAuthUser, TokenAuthRefresh, ListedInfo,
    PricesDailyQuotes, PricesAM, MarketsTradesSpec,
    MarketsWeeklyMarginInterest, MarketsShortSelling,
    MarketsBreakdown, Indices, IndicesTopix, FinsStatements,
    FinsDividend, FinsAnnouncement, OptionIndexOption,
    TradingCalendar, FinsDetails

const JQUANTS_URI = "https://api.jquants.com/v1"

# Errors
include("errors.jl")

# API specification
include("specs.jl")

# endpoints
include("endpoints.jl")

# Get & Post functions
include("http.jl")

# Authorization
include("auth.jl")

# Data types for the type conversion
include("datatypes.jl")

# Fetch market data
include("fetch.jl")

# Utility functions
include("utils.jl")

end # module
