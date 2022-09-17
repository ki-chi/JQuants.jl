const REFRESH_TOKEN = Ref{AbstractString}()
const ID_TOKEN = Ref{AbstractString}()

isvalid_auth() = isdefined(REFRESH_TOKEN, 1) && isdefined(ID_TOKEN, 1)
check_refresh_token() = REFRESH_TOKEN[]
check_id_token() = ID_TOKEN[]

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
You can check your tokens using `JQuants.check_refresh_token()` and `JQuants.check_id_token()`.


# Examples

```jldoctest
julia> reftoken = [YOUR REFRESH TOKEN];

julia> authorize(reftoken)
true
```

```jldoctest
julia> email, pass = [YOUR EMAIL ADDRESS], [YOUR PASSWORD]

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
