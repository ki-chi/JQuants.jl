using Documenter
using JQuants

makedocs(
    modules=[JQuants],
    sitename="JQuants.jl",
    authors="ki-chi <k.brilliant@gmail.com>",
    doctest=false
)

deploydocs(
    repo = "https://github.com/ki-chi/JQuants.jl.git",
    target = "build",
    deps = nothing,
    make = nothing,
    devbranch = "main"
)
