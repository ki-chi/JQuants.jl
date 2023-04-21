function get(endpointkey::EndPointKey; kwargs...)
    !isvalid_auth() && throw(JQuantsInvalidTokenError())

    endpoint = JQUANTS_URI * endpoints[endpointkey]
    headers = ["Authorization" => "Bearer $(ID_TOKEN[])"]
    resp = HTTP.get(endpoint, retries=2, headers=headers; kwargs...)
    body = JSON.parse(String(resp.body))

    if resp.status != 200
        statustext = HTTP.Messages.statustext(resp.status)
        message = body["message"]
        error("Status: $(resp.status) $(statustext)\n Message: $(message)")
    end

    return body
end

function post(endpointkey::EndPointKey; kwargs...)
    endpoint = JQUANTS_URI * endpoints[endpointkey]
    resp = HTTP.post(endpoint, retries=2; kwargs...)
    body = JSON.parse(String(resp.body))

    if resp.status != 200
        statustext = HTTP.Messages.statustext(resp.status)
        message = body["message"]
        error("Status: $(resp.status) $(statustext)\n Message: $(message)")
    end

    return body
end

