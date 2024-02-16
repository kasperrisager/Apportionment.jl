struct ShuffleTieBreaker end
struct LazyTieBreaker end

function choose_one(i::AbstractVector, ::ShuffleTieBreaker)
    return rand(i)
end

function choose_one(i::AbstractVector, ::LazyTieBreaker)
    return i[1]
end

function choose_n(i::AbstractVector, n, ::ShuffleTieBreaker)
    return shuffle(i)[1:n]
end

function choose_n(i::AbstractVector, n, ::LazyTieBreaker)
    return i[1:n]
end

function get_largest(v::AbstractVector{<:Real}, tie_breaker)
    candidates = findall(el -> el == maximum(v), v)
    return choose_one(candidates, tie_breaker)
end

function indicate_nlargest(v::AbstractVector{<:Real}, n, tie_breaker)
    if n == 0
        return zeros(Bool, (length(v),))
    end
    c = v[partialsortperm(v, n, rev = true)]
    largest = v .> c
    equals_needed = n - sum(largest)
    equidxs = findall(v .== c)
    if equals_needed < length(equidxs)
        equidxs = choose_n(equidxs, equals_needed, tie_breaker)
    end
    for eqidx in equidxs
        largest[eqidx] = true
    end
    return largest
end

