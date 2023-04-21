const QueryParams = Vector{Pair{String, Any}}

"""
    convert(::Type{Vector{Pair{String, Any}}}, apistruct::API)

Convert from struct to vector of pairs for use in HTTP requests.

# Arguments
- `apistruct::API`: API struct to convert

# Returns
- `Vector{Pair{String, Any}}`: Vector of pairs for use in HTTP requests

# Examples
```julia
julia> convert(QueryParams, ListedInfo(code="72030", ""))
Vector{Pair{String, Any}} with 1 entry:
  "code" => "72030"
```

"""
function Base.convert(::Type{QueryParams}, apistruct::API)
    # Convert from struct to vector of pairs
    pairs = []
    for field in fieldnames(typeof(apistruct))
        val = getfield(apistruct, field)
        if !isnothing(val) || val != ""
            push!(pairs, string(field) => val)
        end
    end
    return pairs
end

"""
    fetch(params::API, kwargs...)

Fetch data from JQuants API.

"""
function Base.fetch(params::API, kwargs...)
    query = convert(QueryParams, params)
    keyname = jsonkeyname(params)
    results = if isempty(query)
        get(typeof(params))[keyname]
    else
        get(typeof(params); query=query)[keyname]
    end

    df_info = vcat(DataFrame.(results)...)

    return df_info
end

