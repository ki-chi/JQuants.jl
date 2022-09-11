const REFRESH_TOKEN = Ref{String}()
const ID_TOKEN = Ref{String}()

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
