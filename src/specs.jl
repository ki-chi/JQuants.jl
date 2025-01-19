abstract type API end;

# Define the types of API by pricing plan
abstract type PremiumPlanAPI <: API end;
abstract type StandardPlanAPI <: PremiumPlanAPI end;
abstract type LitePlanAPI <: StandardPlanAPI end;
abstract type FreePlanAPI <: LitePlanAPI end;

struct TokenAuthUser <: API end;
struct TokenAuthRefresh <: API end;

struct ListedInfo <: LitePlanAPI
    code::AbstractString
    date::AbstractString
end;

function ListedInfo(; code="", date="")
    date_str = date2str(date)
    return ListedInfo(code, date_str)
end

# Some data columns in PricesDailyQuotes are only obtained with a Lite plan or higher,
# but for those data, they are defined in datascheme.
# The API itself can be called even with the Free plan, so it inherits FreePlanAPI.
struct PricesDailyQuotes <: FreePlanAPI
    code::AbstractString
    from::AbstractString
    to::AbstractString
    date::AbstractString
end;

function PricesDailyQuotes(;code="", from="", to="", date="")
    from_str = date2str(from)
    to_str = date2str(to)
    date_str = date2str(date)

    if isempty(code) && !isempty(date_str)
        PricesDailyQuotes("", "", "", date_str)
    elseif !isempty(code)
        if isempty(from_str) || isempty(to_str)
            PricesDailyQuotes(code, "", "", "")
        else
            PricesDailyQuotes(code, from_str, to_str, "")
        end
    else
        throw(JQuantsInvalidParameterError(
            Dict("code" => code, "from" => from, "to" => to, "date" => date)))
    end
end

struct PricesAM <: PremiumPlanAPI
    code::AbstractString
end;

function PricesAM(;code="")
    if isempty(code)
        PricesAM("")
    else
        
    end
end


struct MarketsTradesSpec <: LitePlanAPI
    section::AbstractString
    from::AbstractString
    to::AbstractString
end;

function MarketsTradesSpec(;section="", from="", to="")
    from_str = date2str(from)
    to_str = date2str(to)

    if isempty(section) && isempty(from_str) && isempty(to_str)
        MarketsTradesSpec("", "", "")
    elseif !isempty(section)
        if isempty(from_str) || isempty(to_str)
            MarketsTradesSpec(section, "", "")
        else
            MarketsTradesSpec(section, from_str, to_str)
        end
    elseif !isempty(from_str) || !isempty(to_str)
        MarketsTradesSpec("", from_str, to_str)
    else 
        @show section, from, to
        error("Unsupported combination.")
    end
end

struct MarketsWeeklyMarginInterest <: StandardPlanAPI
    code::AbstractString
    date::AbstractString
    from::AbstractString
    to::AbstractString
end;

function MarketsWeeklyMarginInterest(;code="", from="", to="", date="")
    from_str = date2str(from)
    to_str = date2str(to)
    date_str = date2str(date)

    if isempty(code) && !isempty(date_str)
        MarketsWeeklyMarginInterest("", "", "", date_str)
    elseif !isempty(code)
        if isempty(from_str) || isempty(to_str)
            MarketsWeeklyMarginInterest(code, "", "", "")
        else
            MarketsWeeklyMarginInterest(code, from_str, to_str, "")
        end
    else
        @show code, from, to, date
        error("Unsupported combination.")
    end
    
end


struct MarketsShortSelling <: StandardPlanAPI
    sector33code::AbstractString
    date::AbstractString
    from::AbstractString
    to::AbstractString
end;

struct MarketsBreakdown <: PremiumPlanAPI
    code::AbstractString
    date::AbstractString
    from::AbstractString
    to::AbstractString
end;

struct Indices <: StandardPlanAPI
    code::AbstractString
    date::AbstractString
    from::AbstractString
    to::AbstractString
end;

function Indices(;code="", date="",  from="", to="")
    from_str = date2str(from)
    to_str = date2str(to)
    date_str = date2str(date)

    if isempty(code) && !isempty(date_str)
        Indices("", "", "", date_str)
    elseif !isempty(code)
        if isempty(from_str) || isempty(to_str)
            Indices(code, "", "", "")
        else
            Indices(code, from_str, to_str, "")
        end
    else
        throw(JQuantsInvalidParameterError(
            Dict("code" => code, "from" => from, "to" => to, "date" => date)))
    end
end

struct IndicesTopix <: LitePlanAPI
    from::AbstractString
    to::AbstractString
end;

function IndicesTopix(;from="", to="")
    from_str = date2str(from)
    to_str = date2str(to)

    if isempty(from_str) && isempty(to_str)
        IndicesTopix("", "")
    elseif isempty(from_str)
        IndicesTopix("", to_str)
    elseif isempty(to_str)
        IndicesTopix(from_str, "")
    else
        IndicesTopix(from_str, to_str)
    end
end

struct FinsStatements <: FreePlanAPI
    code::AbstractString
    date::AbstractString
end;

function FinsStatements(;code="", date="")
    date_str = date2str(date)

    if !(isempty(code) ⊻ isempty(date_str))
        error("Only one of \"code\" or \"date\" must be specified.")
    end
    
    if isempty(code) # i.e. 'date' is not nothing
        FinsStatements("", date_str)
    else
        FinsStatements(code, "")
    end
end

struct FinsDividend <: PremiumPlanAPI
    code::AbstractString
    date::AbstractString
    from::AbstractString
    to::AbstractString
end;

function FinsDividend(;code="", date="", from="", to="")
    from_str = date2str(from)
    to_str = date2str(to)
    date_str = date2str(date)

    if isempty(code) && !isempty(date_str)
        FinsDividend("", "", "", date_str)
    elseif !isempty(code)
        if isempty(from_str) || isempty(to_str)
            FinsDividend(code, "", "", "")
        else
            FinsDividend(code, from_str, to_str, "")
        end
    else
        throw(JQuantsInvalidParameterError(
            Dict("code" => code, "from" => from, "to" => to, "date" => date)))
    end
end

struct FinsAnnouncement <: FreePlanAPI end;

struct OptionIndexOption <: PremiumPlanAPI
    date::AbstractString
end;

function OptionIndexOption(;date="")
    if !isempty(date)
        OptionIndexOption(date2str(date))
    else
        throw(JQuantsInvalidParameterError(Dict("date" => date)))
    end
end


"""
    TradingCalendar(;holidaydivision="", from="", to="")

[Trading Calendar API](https://jpx.gitbook.io/j-quants-en/api-reference/trading_calendar)

## Parameters
- `holidaydivision::AbstractString`: Holiday division.
  (Non-business day: "0", Business day: "1", Day of TSE Half-Day Trading Sessions: "2", Non-business days with holiday trading: "3")
- `from::AbstractString`: Start date. (e.g. "2018-01-01")
- `to::AbstractString`: End date. (e.g. "2018-01-31")

## Examples
```julia
julia> using JQuants

julia> fetch(TradingCalendar(holidaydivision="1", from="2018-01-01", to="2018-01-31"))
```
"""
struct TradingCalendar <: FreePlanAPI
    holidaydivision::AbstractString
    from::AbstractString
    to::AbstractString
end;

function TradingCalendar(;holidaydivision="", from="", to="")
    from_str = date2str(from)
    to_str = date2str(to)

    if isempty(holidaydivision) && isempty(from_str) && isempty(to_str)
        TradingCalendar("", "", "")
    elseif !isempty(holidaydivision)
        if isempty(from_str) || isempty(to_str)
            TradingCalendar(holidaydivision, "", "")
        else
            TradingCalendar(holidaydivision, from_str, to_str)
        end
    elseif !isempty(from_str) || !isempty(to_str)
        TradingCalendar("", from_str, to_str)
    else 
        @show holidaydivision, from, to
        error("Unsupported combination.")
    end
end


"""
    FinsDetails(;code="", date="")

[Financial Statements Details API](https://jpx.gitbook.io/j-quants-ja/api-reference/statements-1)

## Parameters
- `code::AbstractString`: Stock code. (e.g. "8697")
- `date::AbstractString`: Date. (e.g. "2018-01-01")

## Examples
```julia
julia> using JQuants

julia> fetch(FinsDetails(code="8697", date="2018-01-01"))
```
"""
struct FinsDetails <: PremiumPlanAPI
    code::AbstractString
    date::AbstractString
end;

function FinsDetails(; code="", date="")
    isempty(code) && isempty(date) && error("One of \"code\" or \"date\" must be specified.")
    FinsDetails(code, date2str(date))
end
