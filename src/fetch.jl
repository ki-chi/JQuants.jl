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
        if !(isnothing(val) || val == "")
            push!(pairs, string(field) => val)
        end
    end
    return pairs
end

"""
    fetch(api::API, kwargs...)

Fetch data from JQuants API.

# Arguments
- `api::API`: API struct to fetch data from
- `json::Bool`: If true, return the raw JSON string. If false, return a DataFrame. Default is false.

"""
function Base.fetch(api::API, json=false)
    query = convert(QueryParams, api)  # Convert from struct to vector of pairs for use in HTTP requests
    keyname = jsonkeyname(api)
    is_empty_query = isempty(query) || all(p -> isempty(p.second), query)
    resp = is_empty_query ? get(api) : get(api; query=query)

    # Return raw JSON string if json=true
    json && return resp

    result = JSON.parse(resp)  # Convert from JSON string to Dict
    df_raw = vcat(DataFrame.(result[keyname])...)  # Convert from Dict to DataFrame
    df = convert(datascheme(api), df_raw)  # Convert from DataFrame to DataFrame with correct column types
    return df
end
