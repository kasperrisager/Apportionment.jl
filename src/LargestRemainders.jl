struct LargestRemainders
    total_items::Int
end

function apportion_quotas(quotas::AbstractVector{<:Real}, lr::LargestRemainders, tie_breaker)
    items = floor.(Int, quotas)
    remaining_items = lr.total_items - sum(items)
    return items + indicate_largest(quotas - items, remaining_items, tie_breaker)
end

function apportion(entitlements::AbstractVector{<:Real}, lr::LargestRemainders)
    return apportion_quotas(entitlements / sum(entitlements) * lr.total_items, lr, LazyTieBreaker())
end

function apportion(entitlements::Vector{<:Union{Integer, Rational}}, lr::LargestRemainders)
    return apportion_quotas(entitlements // sum(entitlements) * lr.total_items, lr, ShuffleTieBreaker())
end

export LargestRemainders, apportion