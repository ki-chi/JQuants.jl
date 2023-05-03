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
- `json::Bool`: If true, return a vector of the raw JSON strings.
  The number of elements in the vector is equal to the number of pages of the API response.
  If false, return a DataFrame. Default is false.


# Examples
```julia
julia> fetch(ListedInfo(code="72030"));

julia> fetch(ListedInfo(code="72030"), json=true);
```


"""
function Base.fetch(api::API; json=false)
    query = convert(QueryParams, api)  # Convert from struct to vector of pairs for use in HTTP requests
    keyname = jsonkeyname(api)
    json_vec = String[]
    is_empty_query = isempty(query) || all(p -> isempty(p.second), query)
    resp = is_empty_query ? get(api) : get(api; query=query)

    push!(json_vec, resp)  # Push the first page to the vector of JSON strings
    result = JSON.parse(resp)  # Convert from JSON string to Dict
    body = result[keyname]

    # Fetch the rest of the pages
    while haskey(result, "pagination_key")
        push!(query, "pagination_key" => result["pagination_key"])
        resp = get(api; query=query)
        push!(json_vec, resp)

        result = JSON.parse(resp)
        body = vcat(body, result[keyname])
    end

    # Return raw JSON strings if json=true
    json && return json_vec

    # Return DataFrame if json=false
    df_raw = vcat(DataFrame.(body)...)  # Convert from Dict to DataFrame
    df = convert(datascheme(api), df_raw)  # Convert from DataFrame to DataFrame with correct column types
    return df
end
