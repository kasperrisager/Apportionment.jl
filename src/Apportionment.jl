module Apportionment

using Random

include("Utilities.jl")
include("Modifiers.jl")
include("LargestRemainders.jl")
include("DivisorMethods.jl")

export apportion
export ModifyingRule, RelativeThreshold, AbsoluteThreshold
export LargestRemainders, Hare, IntegerHare, IntegerDroop
export DivisorMethod, DHondt, SainteLaguë, HuntingtonHill, ModifiedSainteLaguë

end
