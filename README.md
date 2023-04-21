# JQuants.jl

[![CI](https://github.com/ki-chi/JQuants.jl/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/ki-chi/JQuants.jl/actions/workflows/ci.yml)
[![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url]

[The J-Quants API](https://jpx-jquants.com/?lang=en) wrapper for Julia. 

The J-Quants API is an distribution service that delivers historical stock prices and financial statements data through API,
provided by JPX Market Innovation & Research, Inc.

This client package helps you easily use the API from Julia. 

# How to use

## Installation

In the Julia REPL:

```
] JQuants
```

or

```
julia> using Pkg; Pkg.add("JQuants")
```

## Authorization

You have to [register](https://jpx-jquants.com/auth/signup/?lang=en) to use the J-Quants API.
You may also grant authentication credentials through employment of a "Refresh token," or alternatively, by employing the email address and password that was previously registered for the J-Quants API.

```julia
julia> using JQuants

julia> authorize([YOUR REFRESH TOKEN])
true
```

or

```julia
julia> authorize([YOUR EMAIL ADDRESS], [PASSWORD])
true
```

## Get market data

This package covers [APIs](https://jpx.gitbook.io/j-quants-en/api-reference)
for downloading data by the J-Quants API.

```julia
# Run after authorization

julia> get(ListedInfo());  # Get listed issues

julia> get(DailyQuotes(date="2022-09-09"));  # Get daily stock prices

julia> get(DailyQuotes(date=Date(2022, 9, 9)));  # Dates.Date type is also OK

julia> get(FinStatements(code="86970"));  # Get financial statements

julia> get(FinAnnouncement()); # Get announcement of the next-day financial disclosure

julia> get(TradesSpec());  # Get investment trend statistics by investor types

julia> get(Topix());  # Get daily 'TOPIX' index data
```

See the [documentation][docs-stable-url] for detailed usage of the functions.

# Disclaimers

- No recommendation to trade in financial instrument using this package
- Not responsible for any profit or loss resulting from the use of this package
- Not guarantee any of the accuracy of the information obtained through this package


# Reference

- [J-Quants API](https://jpx-jquants.com/?lang=en)
- [J-Quants API Reference](https://jpx.gitbook.io/j-quants-en/api-reference)


# Acknowledgments

Several ideas were taken from the packages below:

- [J-Quants/jquants-api-client-python](https://github.com/J-Quants/jquants-api-client-python): Python package for the J-Quants API
- [J-Quants/JQuantsR](https://github.com/J-Quants/JQuantsR): R package for the J-Quants API


[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://ki-chi.github.io/JQuants.jl/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://ki-chi.github.io/JQuants.jl/stable/
