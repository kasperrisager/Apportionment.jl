struct ShuffleTieBreaker end
struct LazyTieBreaker end

function chosen(i::AbstractVector, n, ::ShuffleTieBreaker)
    return shuffle(i)[1:n]
end

function chosen(i::AbstractVector, n, ::LazyTieBreaker)
    return i[1:n]
end

function indicate_largest(v::AbstractVector{<:Real}, n, tie_breaker)
    if n == 0
        return zeros(Bool, (length(v),))
    end
    c = v[partialsortperm(v, n, rev = true)]
    largest = v .> c
    equals_needed = n - sum(largest)
    equidxs = findall(v .== c)
    if equals_needed < length(equidxs)
        equidxs = chosen(equidxs, equals_needed, tie_breaker)
    end
    for eqidx in equidxs
        largest[eqidx] = true
    end
    return largest
end
