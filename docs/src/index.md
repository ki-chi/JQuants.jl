# JQuants.jl

GitHub repo: [https://github.com/ki-chi/JQuants.jl](https://github.com/ki-chi/JQuants.jl)

## Overview

A Julia package for using the [J-Quants API](https://application.jpx-jquants.com/) that provide Japanese listed issues' price and financial information.

You have to [register](https://application.jpx-jquants.com/register) to use the J-Quants API.

## Installation

In the Julia REPL:

```
] add https://github.com/ki-chi/JQuants.jl.git
```

## Example

```jldoctest
julia> using JQuants

julia> authorize([YOUR EMAIL ADDRESS], [PASSWORD])
true

julia> dailyquotes = getdailyquotes(date="2022-09-09");  # Get daily stock prices
```

## API Wrappers

Functions exported from `JQuants`:

```@autodocs
Modules = [JQuants]
Private = false
Order = [:function]
```
