"""
    RelativeThreshold(threshold)

A `threshold` for being apportioned items proportional to `sum(entitlements)`.
"""
struct RelativeThreshold
    threshold
end

"""
    AbsoluteThreshold(threshold)

A `threshold` for being apportioned items given as an absolute minimut entitlements.
"""
struct AbsoluteThreshold
    threshold
end

"""
    RankThreshold(n)

Apportion only to the largest `n` entitlements.
"""
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

"""
    ModifyingRule(modifier, next_rule)

Apportionment method which first appliers the `modifier` to entitlements, and then apportions according to `next_rule`.
"""
struct ModifyingRule
    modifier
    next_rule
end

function apportion(entitlements::AbstractVector{<:Real}, rule::ModifyingRule)
    return apportion(modify(entitlements, rule.modifier), rule.next_rule)
end
