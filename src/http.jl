function get(api::API; kwargs...)
    !isvalid_auth() && throw(JQuantsInvalidTokenError())

    headers = ["Authorization" => "Bearer $(ID_TOKEN[])"]
    resp = HTTP.get(endpoint(api), retries=2, headers=headers; kwargs...)
    body = JSON.parse(String(resp.body))

    if resp.status != 200
        statustext = HTTP.Messages.statustext(resp.status)
        message = body["message"]
        error("Status: $(resp.status) $(statustext)\n Message: $(message)")
    end

    return body
end

function post(api::API; kwargs...)
    resp = HTTP.post(endpoint(api), retries=2; kwargs...)
    body = JSON.parse(String(resp.body))

    if resp.status != 200
        statustext = HTTP.Messages.statustext(resp.status)
        message = body["message"]
        error("Status: $(resp.status) $(statustext)\n Message: $(message)")
    end

    return body
end

