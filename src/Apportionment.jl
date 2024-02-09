module Apportionment

using Random

include("Utilities.jl")
include("Modifiers.jl")
include("LargestRemainders.jl")

export apportion
export RelativeThreshold, AbsoluteThreshold, ModifyingRule
export LargestRemainders

end
