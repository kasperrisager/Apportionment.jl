struct LargestRemainders
    total_items::Int
end

function apportion(entitlements, lr::LargestRemainders)
    quotas = entitlements / sum(entitlements) * lr.total_items
    items = floor.(Int, quotas)
    remaining_items = lr.total_items - sum(items)
    if remaining_items == 0
        return items
    end
    remaining_quotas = quotas - items
    required_remaining_quota = remaining_quotas[partialsortperm(remaining_quotas, remaining_items, rev = true)]
    return items + (remaining_quotas .>= required_remaining_quota)
end

export LargestRemainders, apportion