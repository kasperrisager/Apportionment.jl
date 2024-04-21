"""
    LargestRemainders(total_items::Int, quota)

A largest remainders method apportioning `total_items` based on a `quota`.
"""
struct LargestRemainders
    total_items::Int
    quota
end

"""
    Hare()

The Hare quota, setting the price for each item to `sum(entitlements) / total_items`.
"""
struct Hare end

"""
    IntegerHare()

The Hare quota, but with the price rounded up to a whole number of entitlements. Should only be used with integer entitlements.
"""
struct IntegerHare end

"""
    IntegerDroop()

The Droop quota, setting the price for each item to `floor(1 + sum(entitlements) / (1 + total_items))`.
Should only be used with integer entitlements.
"""
struct IntegerDroop end

function quota(entitlements::Real, items, ::Hare)
    return entitlements / items
end

function quota(entitlements::Union{Integer, Rational}, items, ::Hare)
    return entitlements // items
end

function quota(entitlements, items, ::IntegerHare)
    return ceil(Int, quota(items, entitlements, Hare()))
end
function quota(entitlements::Real, items, ::IntegerDroop)
    return floor(Int, 1 + entitlements / (1 + items))
end
function quota(entitlements::Union{Integer, Rational}, items, ::IntegerDroop)
    return floor(Int, 1 + entitlements // (1 + items))
end

function apportion_quotas(quotas::AbstractVector{<:Real}, total_items, tie_breaker)
    items = floor.(Int, quotas)
    remaining_items = total_items - sum(items)
    return items + indicate_nlargest(quotas - items, remaining_items, tie_breaker)
end

function apportion(entitlements::AbstractVector{<:Real}, lr::LargestRemainders)
    return apportion_quotas(entitlements / quota(sum(entitlements), lr.total_items, lr.quota), lr.total_items, LazyTieBreaker())
end

function apportion(entitlements::Vector{<:Union{Integer, Rational}}, lr::LargestRemainders)
    return apportion_quotas(entitlements // quota(sum(entitlements), lr.total_items, lr.quota), lr.total_items, ShuffleTieBreaker())
end
