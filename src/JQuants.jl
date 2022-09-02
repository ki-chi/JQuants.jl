module JQuants

using HTTP
using JSON
using DataFrames

export authorize, getlistedinfo

const REFRESH_TOKEN = Ref{String}()
const ID_TOKEN = Ref{String}()
const JPX_URL = "https://api.jpx-jquants.com/v1"

@enum EndPointKey begin
    TokenAuthUser
    TokenAuthRefresh
    ListedInfo
    ListedSections
    PricesDailyQuotes
    FinsStatements
end

const endpoints = Base.ImmutableDict(
    TokenAuthUser => "/token/auth_user",
    TokenAuthRefresh => "/token/auth_refresh",
    ListedInfo => "/listed/info",
    ListedSections => "/listed/sections",
    PricesDailyQuotes => "/prices/daily_quotes",
    FinsStatements => "/fins/statements"
)



isvalid_auth() = isdefined(REFRESH_TOKEN, 1) && isdefined(ID_TOKEN, 1) 

function update_ref_token(mailaddress, password)
    body = JSON.json(Dict("mailaddress"=>mailaddress, "password"=>password))
    resp = post(JQuants.TokenAuthUser, body=body)
    REFRESH_TOKEN[] = resp["refreshToken"]
end

function update_id_token()
    resp = post(JQuants.TokenAuthRefresh, query=["refreshtoken"=>REFRESH_TOKEN[]])
    ID_TOKEN[] = resp["idToken"]
end

function authorize(refresh_token)
    REFRESH_TOKEN[] = refresh_token
    update_id_token()
    return isvalid_auth()
end

function authorize(mailaddress, password)
    update_ref_token(mailaddress, password)
    update_id_token()
    return isvalid_auth()
end

function get(endpointkey::EndPointKey; kwargs...)
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

function getlistedinfo(;code="")
    listed_infos = get(ListedInfo; query=["code"=>code])["info"]
    vcat(DataFrame.(listed_infos)...)
end



end # module
