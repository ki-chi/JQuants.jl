@reexport module Utils

import ..JQuants: getdailyquotes
using DataFrames
using Dates

function parseymd(ymd::AbstractString)
    m = match(r"(?<year>\d{4})-?(?<month>\d{2})-?(?<day>\d{2})", ymd)
    m === nothing && throw(ErrorException("invalid format date string: $ymd"))
    return Date(join(m, "-"))
end

"""
    getdailyquotes(from, to)

Fetch daily stock price information of all listed issues for the period between `from` and `to`.
"""
function getdailyquotes(from::Union{AbstractString, Date}, to::Union{AbstractString, Date})
    # Type conversion
    days = if from isa AbstractString && to isa AbstractString
        parseymd(from):Day(1):parseymd(to)
    elseif from isa AbstractString && to isa Date
        parseymd(from):Day(1):to
    elseif from isa Date && to isa AbstractString
        from:Day(1):parseymd(to)
    else
        # if both are Date
        from:Day(1):to
    end

    dfs = Vector{DataFrame}(undef, length(days))

    @sync begin
        for i in 1:length(days)
            Threads.@spawn begin
                df = getdailyquotes(date=days[i])
                if df isa DataFrame && !isempty(df)
                    dfs[i] = df
                end
            end
        end 
    end
    
    dfs_assigned = [isassigned(dfs, i) ? dfs[i] : DataFrame() for i in 1:length(days)]

    sort(vcat(dfs_assigned...), [:Date, :Code])
end

end # module
