struct LargestRemainders
    total_items::Int
    quota
end

struct Hare end
struct IntegerHare end
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
