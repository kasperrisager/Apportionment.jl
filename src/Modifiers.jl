struct RelativeThreshold
    threshold
end

struct AbsoluteThreshold
    threshold
end

struct RankThreshold
    n
end

function modify(entitlements, at::AbsoluteThreshold)
    return [e >= at.threshold ? e : 0 for e in entitlements]
end

function modify(entitlements, rt::RelativeThreshold)
    return modify(entitlements, AbsoluteThreshold(sum(entitlements) * rt.threshold))
end

function modify(entitlements::AbstractVector{<:Real}, rt::RankThreshold)
    return ifelse.(indicate_nlargest(entitlements, rt.n, LazyTieBreaker()), entitlements, 0.0)
end

function modify(entitlements::AbstractVector{<:Union{Integer, Rational}}, rt::RankThreshold)
    return ifelse.(indicate_nlargest(entitlements, rt.n, ShuffleTieBreaker()), entitlements, 0)
end

struct ModifyingRule
    modifier
    next_rule
end

function apportion(entitlements::AbstractVector{<:Real}, rule::ModifyingRule)
    return apportion(modify(entitlements, rule.modifier), rule.next_rule)
end
