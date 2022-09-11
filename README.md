# JQuants.jl

[The J-Quants API](https://application.jpx-jquants.com/) wrapper for Julia. 

The J-Quants API is provided as a beta version,
and this package is also under development. The API specifications are subject to change in the future.

# How to use

You have to [register](https://application.jpx-jquants.com/register) to use the API.
If you choose to authorize by using "Refresh token", you should get the token from [the portal of J-Quants API](https://application.jpx-jquants.com/).

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
