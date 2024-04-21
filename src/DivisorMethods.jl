"""
    DivisorMethod(total_items, divisor_sequence)

A divisor method for apportionment.

# Arguments
- `total_items`: items to be apportioned.
- `divisor_sequence`: object specifying the sequence of divisors to use.
"""
struct DivisorMethod
    total_items
    divisor_sequence
end


abstract type RationalDivisorSequence end
Base.broadcastable(o::RationalDivisorSequence) = Ref(o)

"""
    DHondt()

The d'Hondt divisor sequence, `1, 2, 3, ...`.
"""
struct DHondt <: RationalDivisorSequence end

"""
    SainteLaguë()

The Sainte-Laguë divisor sequence, `1, 3, 5, ...`.
"""
struct SainteLaguë <: RationalDivisorSequence end

"""
    ModifiedSainteLaguëSainteLaguë(first::Union{Integer, Rational})

The modified Sainte-Laguë divisor sequence, `first, 3, 5, 7, ...`, where `first` is a parameter.
"""
struct ModifiedSainteLaguë <: RationalDivisorSequence
    first::Union{Integer, Rational}
end

"""
    HuntingtonHill()

The Huntington-Hill divisor sequence, `0, sqrt(1 * 2), sqrt(2 * 3), sqrt(3 * 4), ...`, where it is implied
that all agents receive at least one item.
"""
struct HuntingtonHill end
Base.broadcastable(o::HuntingtonHill) = Ref(o)

minimum_items(::Any) = 0
minimum_items(::HuntingtonHill) = 1

function inverse_divisor(n::Integer, ::DHondt)
    return 1 // n
end

function inverse_divisor(n::Integer, ::SainteLaguë)
    return 1 // (2n - 1)
end

function inverse_divisor(n::Integer, ::HuntingtonHill)
    return 1.0 / sqrt(n * (n - 1))
end

function squared_inverse_divisor(n::Integer, ::HuntingtonHill)
    return 1 // (n * (n - 1))
end

function inverse_divisor(n::Integer, msl::ModifiedSainteLaguë)
    return n == 1 ? 1 // msl.first : 1 // (2n - 1)
end

function index_for_next_item(items, entitlements::AbstractVector{<:Real}, divisor_sequence)
    return get_largest(entitlements .* inverse_divisor.(items .+ 1, divisor_sequence), LazyTieBreaker())
end

function index_for_next_item(items, entitlements::AbstractVector{<:Union{Integer, Rational}}, divisor_sequence::RationalDivisorSequence)
    return get_largest(entitlements .* inverse_divisor.(items .+ 1, divisor_sequence), ShuffleTieBreaker())
end

function index_for_next_item(items, entitlements::AbstractVector{<:Union{Integer, Rational}}, divisor_sequence::HuntingtonHill)
    return get_largest(entitlements.^2 .* squared_inverse_divisor.(items .+ 1, divisor_sequence), ShuffleTieBreaker())
end

function increment!(items, entitlements, divisor_sequence)
    next_idx = index_for_next_item(items, entitlements, divisor_sequence)
    items[next_idx] += 1
    return next_idx
end

"""
    apportion_ordered(entitlements::AbstractVector{<:Real}, method::DivisorMethod[, initial_items::AbstractVector{<:Integer}])

Apportion based on entitlements and a divisor method, reporting the order in which items are apportioned.

# Arguments
- `entitlements`: relative amounts that the agents are entitled to.
- `method`: divisor method to apportion according to.
- `initial_items`: Optional: items already allocated, default is 0 for each agent, except for `HuntingtonHill`, where it is 1. 
"""
function apportion_ordered(entitlements::AbstractVector{<:Real}, method::DivisorMethod, initial_items::AbstractVector{<:Integer})
    divisor_sequence = method.divisor_sequence
    items = initial_items
    remaining_items = method.total_items - sum(initial_items)
    apportionment_order = Vector{Int}(undef, remaining_items)
    for m in 1:remaining_items
        apportionment_order[m] = increment!(items, entitlements, divisor_sequence)
    end
    return apportionment_order
end

"""
    apportion(entitlements::AbstractVector{<:Real}, method::DivisorMethod[, initial_items::AbstractVector{<:Integer}])

when using a divisor `method`, one can optionally specify `initial_items` that are already apportioned to each agent.
Default is 0 for each agent, except for `HuntingtonHill`, where it is 1. 
"""
function apportion(entitlements::AbstractVector{<:Real}, method::DivisorMethod, initial_items::AbstractVector{<:Integer})
    divisor_sequence = method.divisor_sequence
    items = initial_items
    remaining_items = method.total_items - sum(initial_items)
    for m in 1:remaining_items
        increment!(items, entitlements, divisor_sequence)
    end
    return items
end

function apportion_ordered(entitlements::AbstractVector{<:Real}, method::DivisorMethod)
    initial_items = fill(minimum_items(method.divisor_sequence), length(entitlements))
    return apportion_ordered(entitlements, method, initial_items)
end

function apportion(entitlements::AbstractVector{<:Real}, method::DivisorMethod)
    initial_items = fill(minimum_items(method.divisor_sequence), length(entitlements))
    return apportion(entitlements, method, initial_items)
end
