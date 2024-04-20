module Apportionment

using Random

include("Utilities.jl")
include("Modifiers.jl")
include("LargestRemainders.jl")
include("DivisorMethods.jl")

export apportion, apportion_ordered
export ModifyingRule, RelativeThreshold, AbsoluteThreshold, RankThreshold
export LargestRemainders, Hare, IntegerHare, IntegerDroop
export DivisorMethod, DHondt, SainteLaguë, HuntingtonHill, ModifiedSainteLaguë

end
