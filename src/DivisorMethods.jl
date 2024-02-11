struct DivisorMethod
    total_items
    divisor_sequence
end

abstract type RationalDivisorSequence end

struct DHondt <: RationalDivisorSequence end
struct SainteLaguë <: RationalDivisorSequence end
struct HuntingtonHill end
struct ModifiedSainteLaguë <: RationalDivisorSequence
    first::Union{Integer, Rational}
end

minimum_items(::Any) = 0
minimum_items(::HuntingtonHill) = 1

function divisor(n::Integer, ::DHondt)
    return n
end

function divisor(n::Integer, ::SainteLaguë)
    return 2n + 1
end

function divisor(n::Integer, ::HuntingtonHill)
    return sqrt(n * (n + 1))
end

function squared_divisor(n::Integer, ::HuntingtonHill)
    return n * (n + 1)
end

function divisor(n::Integer, msl::ModifiedSainteLaguë)
    return n == 0 ? msl.first : 2n + 1
end

function index_for_next_item(entitlements::AbstractVector{<:Real}, items, divisor_sequence)
    return argmax(entitlements ./ divisor.(items .+ 1, divisor_sequence))
end

function index_for_next_item(entitlements::AbstractVector{<:Union{Integer, Rational}}, items, divisor_sequence::RationalDivisorSequence)
    return argmax(entitlements .// divisor.(items .+ 1, divisor_sequence))
end

function index_for_next_item(entitlements::AbstractVector{<:Union{Integer, Rational}}, items, divisor_sequence::HuntingtonHill)
    return argmax(entitlements.^2 .// squared_divisor.(items .+ 1, divisor_sequence))
end

function apportion(entitlements::AbstractVector{<:Real}, method::DivisorMethod)
    divisor_sequence = method.divisor_sequence
    items = fill(minimum_items(divisor_sequence), length(entitlements))
    for m in 1:method.total_items
        items[index_for_next_item(entitlements, items, divisor_sequence)] += 1
    end
    return items
end

