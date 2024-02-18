module Apportionment

using Random

include("Utilities.jl")
include("Modifiers.jl")
include("LargestRemainders.jl")
include("DivisorMethods.jl")

export apportion
export RelativeThreshold, AbsoluteThreshold, ModifyingRule
export LargestRemainders
export DivisorMethod, DHondt, SainteLaguë, HuntingtonHill, ModifiedSainteLaguë

end
