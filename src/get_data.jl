function getinfo(;code="")
    listed_infos = get(ListedInfo; query=["code"=>code])["info"]
    vcat(DataFrame.(listed_infos)...)
end

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
