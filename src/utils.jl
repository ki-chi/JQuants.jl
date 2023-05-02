using Dates

"""
    date2str(x)

Convert `x` to "yyyy-mm-dd" formated string if `x` is `Date`.
"""
date2str(::Any) = error("argument 'x' must be AbstractString or Date.")
date2str(x::AbstractString) = x
date2str(x::Date) = Dates.format(x, "yyyy-mm-dd")
