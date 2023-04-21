export TokenAuthUser, TokenAuthRefresh, ListedInfo, PricesDailyQuotes, PricesAM, MarketsTradeSpec, MarketsWeeklyMarginInterest, MarketsShortSelling, MarketsBreakdown, IndicesTopix, FinsStatements, FinsDividend, FinsAnnouncement, OptionIndexOption

const DateArg = Union{Date, AbstractString, Nothing};

abstract type API end;

struct TokenAuthUser <: API end;
struct TokenAuthRefresh <: API end;


struct ListedInfo <: API
    code::AbstractString
    date::DateArg
end;

struct PricesDailyQuotes <: API
    code::AbstractString
    from::DateArg
    to::DateArg
    date::DateArg
end;

struct PricesAM <: API
    code::AbstractString
end;

struct MarketsTradeSpec <: API
    section::AbstractString
    from::DateArg
    to::DateArg
end;

struct MarketsWeeklyMarginInterest <: API
    code::AbstractString
    date::DateArg
    from::DateArg
    to::DateArg
end;

struct MarketsShortSelling <: API
    sector33code::AbstractString
    date::DateArg
    from::DateArg
    to::DateArg
end;

struct MarketsBreakdown <: API
    code::AbstractString
    date::DateArg
    from::DateArg
    to::DateArg
end;

struct IndicesTopix <: API
    from::DateArg
    to::DateArg
end;

struct FinsStatements <: API
    code::AbstractString
    date::DateArg
end;

struct FinsDividend <: API
    code::AbstractString
    date::DateArg
    from::DateArg
    to::DateArg
end;

struct FinsAnnouncement <: API end;

struct OptionIndexOption <: API
    date::DateArg
end;

