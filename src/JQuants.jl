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
    PricesDailyQuotes, PricesAM, MarketsTradeSpec,
    MarketsWeeklyMarginInterest, MarketsShortSelling,
    MarketsBreakdown, IndicesTopix, FinsStatements,
    FinsDividend, FinsAnnouncement, OptionIndexOption

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

# Data types
include("datatypes.jl")

# For market data API
include("get_data.jl")
include("fetch.jl")

# Utility functions
include("utils.jl")

end # module
