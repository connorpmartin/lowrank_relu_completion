using Convex: nuclearnorm
using Norm
using SCS

#easy-to-use mapping function for LRMC completion methods
completion_methods = Dict([:basic => lrmc_basic,
    ])


"""
lrmc() calculates a low-rank matrix completion for a matrix A
where we observe x = A[Ω[:]].
method describes different ways of calculating this LRMC:
    :convex uses the Convex.jl solver.
    

optargs allows any additional arguments to be passed to individual solver functions.
"""
lrmc(x::Vector,Ω::BitMatrix;method::Symbol = :basic;optargs...) = completion_methods[method](x,Ω,optargs...)


function lrmc_basic(x::Vector,Ω::BitMatrix;verbose=false)
    #define our guess for the final matrix
    A = Variable(size(Ω)...)

    problem = minimize(nuclearnorm(A),[A[Ω[:]] == x])

    solve!(problem, () -> SCS.Optimizer(verbose=verbose))

    return problem.optval
end

#β is the weight parameter on the nuclear norm regularization
#This relaxed version minimizes the frobenius norm of the error matrix while regularizing via the nuclear norm.
function lrmc_relaxed(x::Vector,Ω::BitMatrix;verbose=false,β = 1)
    #define our guess for the final matrix
    A = Variable(size(Ω)...)

    problem = minimize(sumsquares(A[Ω[:]] .- x) + β * nuclearnorm(A))

    solve!(problem, () -> SCS.Optimizer(verbose=verbose))

    return problem.optval
end