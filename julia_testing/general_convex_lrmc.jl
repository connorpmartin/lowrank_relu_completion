using Convex: nuclearnorm
using SCS

function lrmc_general(x::Vector,Ω::BitMatrix;verbose=false)
    #define our guess for the final matrix
    A = Variable(size(Ω)...)

    problem = minimize(nuclearnorm(A),A[Ω[:]] == x)

    solve!(problem, () -> SCS.Optimizer(verbose=verbose))

    return problem.optval
end

function lrmc_general(p::Symbol)
    p != :test && throw("Use :test to run unit tests for lrmc_basic")
    #try optimizing a small matrix with smaller rank and few missing entries
    A = rand(20,3) * rand(3,20)
    Ω = BitMatrix(round.(rand(20,20)))
    Â = lrmc_general(A[Ω[:]],Ω)
    @assert norm(A .- Â) ≤ 1e-4 #we expect full recovery
end

#β is the weight parameter on the nuclear norm regularization
#This relaxed version minimizes the frobenius norm of the error matrix while regularizing via the nuclear norm.
function lrmc_general_relaxed(x::Vector,Ω::BitMatrix;verbose=false,β = 1)
    #define our guess for the final matrix
    A = Variable(size(Ω)...)

    problem = minimize(sumsquares(A[Ω[:]] .- x) + β * nuclearnorm(A))

    solve!(problem, () -> SCS.Optimizer(verbose=verbose))

    return problem.optval
end
