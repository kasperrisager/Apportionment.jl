struct RelativeThreshold
    threshold
end

struct AbsoluteThreshold
    threshold
end

function modify(entitlements, at::AbsoluteThreshold)
    return [e >= at.threshold ? e : 0 for e in entitlements]
end

function modify(entitlements, rt::RelativeThreshold)
    return modify(entitlements, AbsoluteThreshold(sum(entitlements) * rt.threshold))
end

struct ModifyingRule
    modifier
    next_rule
end

function apportion(entitlements::AbstractVector{<:Real}, rule::ModifyingRule)
    return apportion(modify(entitlements, rule.modifier), rule.next_rule)
end
