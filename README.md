# Apportionment

[![Build Status](https://github.com/kasperrisager/Apportionment.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/kasperrisager/Apportionment.jl/actions/workflows/CI.yml?query=branch%3Amaster)

This package aims to provide commonly used methods of [apportionment](https://en.wikipedia.org/wiki/Mathematics_of_apportionment) for allocating seats in political bodies according to votes and/or census data. The methods provided should be
* Versatile - fully configurable rules
* Easy to use - because most use cases are simple
* Correct and auditable - for use in real-life political bodies
* Performant - for use in stochastic simulation studies

As is evident, the package is currently under development.

## Usage

    julia> using Apportionment
    julia> apportion([915393, 304273, 233349], LargestRemainders(76))
    3-element Vector{Int64}:
     48
     16
     12