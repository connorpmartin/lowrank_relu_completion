include("general_convex_lrmc.jl")
#mapping dictionary for LRMC completion methods
completion_methods = Dict([:general => lrmc_general,
                           :general_relaxed => lrmc_general_relaxed,
                        ])
"""
lrmc() calculates a low-rank matrix completion for a matrix A
where we observe x = A[Ω[:]].
method describes different ways of calculating this LRMC:
    :convex uses the Convex.jl solver.
    

optargs allows any additional arguments to be passed to individual solver functions.
"""
#this line interpolates the method by adding lrmc_ and calls it on x and Ω, passing any additional optional arguments.
lrmc(x::Vector,Ω::BitMatrix;method::Symbol = :general,optargs...) = completion_methods[method](x,Ω;optargs...)