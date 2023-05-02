"""
    get(api::API; json=false, kwargs...)

Get data from the API endpoint.

# Arguments
- `api::API`: API endpoint
- `kwargs...`: Keyword arguments passed to `HTTP.get`

"""
function get(api::API; kwargs...)
    # Check if the token is valid
    !isvalid_auth() && throw(JQuantsInvalidTokenError())

    headers = ["Authorization" => "Bearer $(ID_TOKEN[])"]
    resp = HTTP.get(endpoint(api), retries=2, headers=headers; kwargs...)
    body = String(resp.body)

    if resp.status != 200
        statustext = HTTP.Messages.statustext(resp.status)
        dictbody = JSON.parse(body)
        message = dictbody["message"]
        error("Status: $(resp.status) $(statustext)\n Message: $(message)")
    end

    return body
end

function post(api::API; kwargs...)
    resp = HTTP.post(endpoint(api), retries=2; kwargs...)
    body = String(resp.body)

    if resp.status != 200
        statustext = HTTP.Messages.statustext(resp.status)
        dictbody = JSON.parse(body)
        message = dictbody["message"]
        error("Status: $(resp.status) $(statustext)\n Message: $(message)")
    end

    return body
end

