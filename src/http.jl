function get(endpointkey::EndPointKey; kwargs...)
    !isvalid_auth() && throw(JQuantsInvalidTokenError())

    endpoint = JPX_URL * endpoints[endpointkey]
    headers = ["Authorization" => "Bearer $(ID_TOKEN[])"]
    resp = HTTP.get(endpoint, headers=headers; kwargs...)
    body = JSON.parse(String(resp.body))

    if resp.status != 200
        statustext = HTTP.Messages.statustext(resp.status)
        message = body["message"]
        error("Status: $(resp.status) $(statustext)\n Message: $(message)")
    end

    return body
end

function post(endpointkey::EndPointKey; kwargs...)
    endpoint = JPX_URL * endpoints[endpointkey]
    resp = HTTP.post(endpoint; kwargs...)
    body = JSON.parse(String(resp.body))

    if resp.status != 200
        statustext = HTTP.Messages.statustext(resp.status)
        message = body["message"]
        error("Status: $(resp.status) $(statustext)\n Message: $(message)")
    end

    return body
end

