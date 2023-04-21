abstract type API end;

struct TokenAuthUser <: API end;
struct TokenAuthRefresh <: API end;


struct ListedInfo <: API
    code::AbstractString
    date::AbstractString
end;

function ListedInfo(;code="", date="")
    date_str = date2str(date)

    if isempty(code) && isempty(date_str)
        ListedInfo("", "")
    elseif isempty(code)
        ListedInfo("", date_str)
    elseif isempty(date_str)
        ListedInfo(code, "")
    else
        ListedInfo(code, date_str)
    end
end


struct PricesDailyQuotes <: API
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
        @show code, from, to, date
        error("Unsupported combination.")
    end
end

struct PricesAM <: API
    code::AbstractString
end;

function PricesAM(;code="")
    if isempty(code)
        PricesAM("")
    else
        PricesAM(code)
    end
end


struct MarketsTradeSpec <: API
    section::AbstractString
    from::AbstractString
    to::AbstractString
end;

function MarketsTradeSpec(;section="", from="", to="")
    from_str = date2str(from)
    to_str = date2str(to)

    if isempty(section) && isempty(from_str) && isempty(to_str)
        MarketsTradeSpec("", "", "")
    elseif !isempty(section)
        if isempty(from_str) || isempty(to_str)
            MarketsTradeSpec(section, "", "")
        else
            MarketsTradeSpec(section, from_str, to_str)
        end
    elseif !isempty(from_str) || !isempty(to_str)
        MarketsTradeSpec("", from_str, to_str)
    else 
        @show section, from, to
        error("Unsupported combination.")
    end
end

struct MarketsWeeklyMarginInterest <: API
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


struct MarketsShortSelling <: API
    sector33code::AbstractString
    date::AbstractString
    from::AbstractString
    to::AbstractString
end;

struct MarketsBreakdown <: API
    code::AbstractString
    date::AbstractString
    from::AbstractString
    to::AbstractString
end;

struct IndicesTopix <: API
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

struct FinsStatements <: API
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

struct FinsDividend <: API
    code::AbstractString
    date::AbstractString
    from::AbstractString
    to::AbstractString
end;

struct FinsAnnouncement <: API end;

struct OptionIndexOption <: API
    date::AbstractString
end;

