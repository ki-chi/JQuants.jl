module JQuants

const REFRESH_TOKEN = Ref{String}()
const ID_TOKEN = Ref{String}()

isvalid_auth() = isdefined(REFRESH_TOKEN, 1) && isdefined(ID_TOKEN, 1) 

function update_ref_token(mailaddress, password)
    # todo
end

function update_id_token()
    # todo
end

function authorize(refresh_token)
    REFRESH_TOKEN[] = refresh_token
    ID_TOKEN[] = getidtoken()
end

function authorize(mailaddress, password)
    REFRESH_TOKEN[] = update_ref_token(mailaddress, password)
    ID_TOKEN[] = getidtoken()
end
