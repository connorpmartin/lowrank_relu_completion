include("general_convex_lrmc.jl")
include("R2RILS.jl")
"""
lrmc() calculates a low-rank matrix completion for a matrix A
where we observe x = A[Ω[:]].

optargs allows any additional arguments to be passed to individual solver functions.
"""
lrmc(x::Vector,Ω::BitMatrix,rank::Integer;method::Function = lrmc_general,optargs...) = method(x,Ω,rank;optargs...)