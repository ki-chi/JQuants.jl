# JQuants.jl

[![CI](https://github.com/ki-chi/JQuants.jl/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/ki-chi/JQuants.jl/actions/workflows/ci.yml)
[![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url]

[The J-Quants API](https://application.jpx-jquants.com/) wrapper for Julia. 

The J-Quants API is an distribution service that delivers historical stock prices and financial statements data through API,
provided by JPX Market Innovation & Research, Inc.
The API service is provided as a beta version, and the API specifications are subject to change in the future. 

This client package helps you easily use the API from Julia. 

# How to use

You have to [register](https://application.jpx-jquants.com/register) to use the J-Quants API.
If you choose to authorize by using "Refresh token", you should get the token from [the portal of J-Quants API](https://application.jpx-jquants.com/).
You can also authorize using the email address and password registered for the J-Quants API.

## Authorization

```julia
julia> authorize([YOUR REFRESH TOKEN])
true
```

or

```julia
julia> authorize([YOUR EMAIL ADDRESS], [PASSWORD])
true
```

## Get market data

This package covers [all APIs](https://jpx.gitbook.io/j-quants-api-en/api-reference)
for downloading data by the J-Quants API.

```julia
# Run after authorization

julia> getinfo();  # Get listed issues

julia> getsections();  # Get definitions of sector codes (in Japanese)

julia> getdailyquotes(date="2022-09-09");  # Get daily stock prices

julia> getfinstatements(code="86970");  # Get financial statements

julia> getfinannouncement(); # Get announcement of the next-day financial disclosure
```

See the [documentation](docs-stable-url) for detailed usage of the functions.

# Disclaimers

- No recommendation to trade in financial instrument using this package
- Not responsible for any profit or loss resulting from the use of this package
- Not guarantee any of the accuracy of the information obtained through this package


# Reference

- [J-Quants API](https://application.jpx-jquants.com/)
- [J-Quants API Reference](https://jpx.gitbook.io/j-quants-api-en/api-reference)


# Acknowledgments

Several ideas were taken from the packages below:

- [J-Quants/jquants-api-client-python](https://github.com/J-Quants/jquants-api-client-python): Python package for the J-Quants API
- [J-Quants/JQuantsR](https://github.com/J-Quants/JQuantsR): R package for the J-Quants API


[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://ki-chi.github.io/JQuants.jl/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://ki-chi.github.io/JQuants.jl/stable/
