abstract type JQuantsError <: Exception end

"""
    JQuantsInvalidTokenError()

The refresh token or the id token are not defined.
"""
struct JQuantsInvalidTokenError <: JQuantsError end

function Base.showerror(io::IO, ::JQuantsInvalidTokenError)
    
    if !isdefined(REFRESH_TOKEN, 1) && !isdefined(ID_TOKEN, 1)
        message = "both the refresh token and the id token are"
    elseif !isdefined(REFRESH_TOKEN, 1)
        message = "the refresh token is"
    elseif !isdefined(ID_TOKEN, 1)
        message = "the id token is"
    else
        error("Unexpected Error for JQuantsInvalidTokenError")
    end

    print(io, message, " not defined")
end

"""
    JQuantsInvalidParameterError()

The parameter is invalid.
"""
struct JQuantsInvalidParameterError <: JQuantsError
    params::Dict{String, Any}
end

function Base.showerror(io::IO, e::JQuantsInvalidParameterError)
    params = replace(replace(string(e.params), "Dict" => ""), r"\{.*,.*\}" => "")
    print(io, "JQuantsInvalidParameterError: ", params, " are invalid parameter(s)")
end
