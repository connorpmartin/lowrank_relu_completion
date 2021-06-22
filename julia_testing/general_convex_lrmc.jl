using Convex: nuclearnorm,Variable,minimize,solve!,evaluate,sumsquares
using SCS
using LinearAlgebra

function lrmc_general(x::Vector,Ω::BitMatrix;verbose=false,time = false)
    #define our guess for the final matrix
    A = Variable(size(Ω)...)
    
    #turn logical indexing into numerical indexing 
    #because convex does not work with logical masks for some reason
    mask = filter(x -> x != 0,Ω[:] .* (1:size(Ω[:],1)))

    constraint = A[mask] == x

    
    problem = minimize(nuclearnorm(A),constraint)
    if time
        @time solve!(problem, () -> SCS.Optimizer(verbose=verbose))
    else 
        solve!(problem, () -> SCS.Optimizer(verbose=verbose))
    end

    @show evaluate(A)[Ω[:]] - x

    return evaluate(A)
end

function lrmc_general(p::Symbol)
    p != :test && throw("Use :test to run unit tests for lrmc_basic")
    #try optimizing a small matrix with smaller rank and few missing entries
    A = rand(100,5) * rand(5,100)
    Ω = BitMatrix(round.(rand(100,100)))
    Â = lrmc_general(A[Ω[:]],Ω)
    @assert norm(A .- Â) < .001 #we expect full recovery
end

#β is the weight parameter on the nuclear norm regularization
#This relaxed version minimizes the frobenius norm of the error matrix while regularizing via the nuclear norm.
function lrmc_general_relaxed(x::Vector,Ω::BitMatrix;verbose=false,β = 1)
    #define our guess for the final matrix
    A = Variable(size(Ω)...)
    mask = filter(x -> x != 0,Ω[:] .* (1:size(Ω[:],1)))

    problem = minimize(sumsquares(A[mask] - x) + β * nuclearnorm(A))

    solve!(problem, () -> SCS.Optimizer(verbose=verbose))

    return problem.optval
end

function lrmc_general_relaxed(p::Symbol)
    p != :test && throw("Use :test to run unit tests for lrmc_basic")
    #try optimizing a small matrix with smaller rank and few missing entries
    A = rand(100,5) * rand(5,100)
    Ω = BitMatrix(round.(rand(100,100)))
    Â = lrmc_general_relaxed(A[Ω[:]],Ω)
    @assert norm(A .- Â) < .001 #we expect full recovery
end