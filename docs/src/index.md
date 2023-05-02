# JQuants.jl

GitHub repo: [https://github.com/ki-chi/JQuants.jl](https://github.com/ki-chi/JQuants.jl)

## Overview

A Julia package for using the [J-Quants API](https://jpx-jquants.com/?lang=en) that provide Japanese listed issues' price and financial information.

You have to [register](https://jpx-jquants.com/auth/signup/?lang=en) to use the J-Quants API.

## Installation

In the Julia REPL:

```
] JQuants
```

or

```
julia> using Pkg; Pkg.add("JQuants")
```

## Example

```jldoctest
julia> using JQuants

julia> authorize([YOUR REFRESH TOKEN])
true

julia> fetch(FinsStatements(code="86970"));  # Fetch financial statements

```

## API Wrappers

Functions exported from `JQuants`:

```@autodocs
Modules = [JQuants]
Private = false
Order = [:function]
```
