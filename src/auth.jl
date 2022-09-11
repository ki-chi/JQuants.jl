const REFRESH_TOKEN = Ref{AbstractString}()
const ID_TOKEN = Ref{AbstractString}()

isvalid_auth() = isdefined(REFRESH_TOKEN, 1) && isdefined(ID_TOKEN, 1) 

function update_ref_token(emailaddress, password)
    body = JSON.json(Dict("mailaddress"=>emailaddress, "password"=>password))
    resp = post(JQuants.TokenAuthUser, body=body)
    REFRESH_TOKEN[] = resp["refreshToken"]
end

function update_id_token()
    resp = post(JQuants.TokenAuthRefresh, query=["refreshtoken"=>REFRESH_TOKEN[]])
    ID_TOKEN[] = resp["idToken"]
end


"""
    authorize(refresh_token::AbstractString)
    authorize(emailaddress::AbstractString, password::AbstractString)

Authorize by the refresh token `refresh_token`, or the combination of email address
`emailaddress` and password `password`. Return `true` after the authorization.

The details of this API are [here](https://jpx.gitbook.io/j-quants-api-en/api-reference/refreshtoken)
and [here](https://jpx.gitbook.io/j-quants-api-en/api-reference/refresh).

This package temporally holds your ID Token and Refresh Token as the package-internal variables.
Once authorized, reauthorization is not required until that the process of Julia exits or the tokens expires.
You can access your tokens as `JQuants.REFRESH_TOKEN[]` and `JQuants.ID_TOKEN[]`.


# Examples

```julia
julia> reftoken = [YOUR REFRESH TOKEN];

julia> authorize(reftoken)
true
```

```jldoctest
julia> email, pass = ENV["JQUANTS_EMAIL_ADDRESS"], ENV["JQUANTS_PASSWORD"];

julia> authorize(email, pass)
true
```

"""
function authorize end

function authorize(refresh_token::AbstractString)
    REFRESH_TOKEN[] = refresh_token
    update_id_token()
    return isvalid_auth()
end

function authorize(emailaddress::AbstractString, password::AbstractString)
    update_ref_token(emailaddress, password)
    update_id_token()
    return isvalid_auth()
end
