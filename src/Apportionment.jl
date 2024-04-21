module Apportionment

using Random

"""
    apportion(entitlements::AbstractVector{<:Real}, method)

Apportion based on `entitlements` and a `method` of apportionment, reporting the number of items apportioned to each agent.
"""
function apportion(entitlements::AbstractVector{<:Real}, method, initial_items::AbstractVector{<:Integer}) end


include("Utilities.jl")
include("Modifiers.jl")
include("LargestRemainders.jl")
include("DivisorMethods.jl")

export apportion, apportion_ordered
export ModifyingRule, RelativeThreshold, AbsoluteThreshold, RankThreshold
export LargestRemainders, Hare, IntegerHare, IntegerDroop
export DivisorMethod, DHondt, SainteLaguë, HuntingtonHill, ModifiedSainteLaguë

end
