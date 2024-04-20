struct DivisorMethod
    total_items
    divisor_sequence
end

abstract type RationalDivisorSequence end
Base.broadcastable(o::RationalDivisorSequence) = Ref(o)

struct DHondt <: RationalDivisorSequence end
struct SainteLaguë <: RationalDivisorSequence end
struct ModifiedSainteLaguë <: RationalDivisorSequence
    first::Union{Integer, Rational}
end

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
