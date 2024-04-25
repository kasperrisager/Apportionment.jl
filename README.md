# Apportionment

[![Build Status](https://github.com/kasperrisager/Apportionment.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/kasperrisager/Apportionment.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![codecov](https://codecov.io/github/kasperrisager/Apportionment.jl/graph/badge.svg?token=QJF2U8JTRA)](https://codecov.io/github/kasperrisager/Apportionment.jl)

This package aims to provide commonly used methods of [apportionment](https://en.wikipedia.org/wiki/Mathematics_of_apportionment) for allocating seats in political bodies according to votes and/or census data. The methods provided should be
* Versatile - fully configurable rules
* Easy to use - because most use cases are simple
* Correct and auditable - for use in real-life political bodies
* Performant - for use in stochastic simulation studies

As is evident, the package is currently under development. It currently supports most commonly encountered Largest Remainders and Divisor Methods, as well as thresholds.

## Nomenclature

Methods of apportionment are most often used to allocate seats in political assemblies to either political parties based on votes or to 
geographical regions based on some measure of importance. However, the methods can also be used for completely different purposes, such as allocating batches to be produced between factories based on their capacity. Therefore, this package uses nomenclature agnostic to the precise use:

- The methods apportion indivisible *items*
- among a set of *agents*
- approximately proportionally to the *entitlements* of those agents

## Basic usage

    julia> using Apportionment
    julia> apportion([915393, 304273, 233349], LargestRemainders(76, Hare()))
    3-element Vector{Int64}:
     48
     16
     12
    julia> apportion([915393, 304273, 233349], DivisorMethod(15, SainteLaguë()))
    3-element Vector{Int64}:
      10
       3
       2
    julia> apportion_ordered([915393, 304273, 233349], DivisorMethod(6, SainteLaguë()))
    6-element Vector{Int64}:
     1
     1
     2
     3
     1
     1

## Constructing methods of apportionment

The rules of apportionment are defined in types. The package supports three top-level types
 - `LargestRemainders` that take the total number of items to be apportioned and a quota rule
 - `DivisorMethod` that take the total number of items to be apportioned and a divisor sequence
 - `ModifyingRule` that takes a modifier, such as a threshold, and the next rule to apply.

The supported quota rules for Largest remainders are
 - `Hare`
 - `IntegerHare`
 - `IntegerDroop`
 
The supported divisor sequences are
 - `DHondt`
 - `SainteLaguë`
 - `ModifiedSainteLaguë`
 - `HuntingtonHill`

The supported modifying rules are
 - `RelativeThreshold`
 - `AbsoluteThreshold`
 - `RankThreshold`

The package is designed to be easily extended with more rules.

As an example, apportionment of seats for the US House of Representatives is

    DivisorMethod(435, HuntingtonHill())

Apportionment for the Parliament of Denmark (largest remainders with a 2 percent threshold)

    ModifyingRule(RelativeThreshold(0.02),
        LargestRemainders(175, Hare()))

More involved rules can be crafted, such as "54 seats are apportioned by d'Hondt's method among
parties with at least 5 percent of the vote, however never among more than 5 parties". This would be

    ModifyingRule(RelativeThreshold(0.05),
        ModifyingRule(RankThreshold(5),
            DivisorMethods(54, DHondt())))

## Handling ties

In some cases, applying the methods of apportionment will result in ties between two or more agents. The package will discover those ties, and handles them according to the following convention

- If entitlements are `Integer` or `Rational`, ties are resolved by apportioning randomly among the tied agents, with equal weight on each agent.
- If entitlements are `Real` the tie is assumed to be a freak accident, and the algorithm will apportion in the easiest possible way.

This means, that if the resolution of ties is a concern, it is crucial to use integer (or rational) entitlements.

## Contributing

Because the central design work on the package is still ongoing, it is not yet in a state to receive contributions. Suggestions for methods and features will be very much appreciated, also if the come with suggested implementations.
