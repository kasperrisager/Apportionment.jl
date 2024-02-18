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

function index_for_next_item(entitlements::AbstractVector{<:Real}, items, divisor_sequence)
    return get_largest(entitlements .* inverse_divisor.(items .+ 1, divisor_sequence), LazyTieBreaker())
end

function index_for_next_item(entitlements::AbstractVector{<:Union{Integer, Rational}}, items, divisor_sequence::RationalDivisorSequence)
    return get_largest(entitlements .* inverse_divisor.(items .+ 1, divisor_sequence), ShuffleTieBreaker())
end

function index_for_next_item(entitlements::AbstractVector{<:Union{Integer, Rational}}, items, divisor_sequence::HuntingtonHill)
    return get_largest(entitlements.^2 .* squared_inverse_divisor.(items .+ 1, divisor_sequence), ShuffleTieBreaker())
end

function apportion(entitlements::AbstractVector{<:Real}, method::DivisorMethod)
    divisor_sequence = method.divisor_sequence
    items = fill(minimum_items(divisor_sequence), length(entitlements))
    for m in (sum(items) + 1):method.total_items
        items[index_for_next_item(entitlements, items, divisor_sequence)] += 1
    end
    return items
end

