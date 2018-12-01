Color = {}

function Color:new(r, g, b, α)
    α = α or 1
    return {R = r, G = g, B = b, A = α}
end
