include("row_coherence_testing.jl")
include("R2RILS.jl")
using StatsBase: rmsd

w = 37
h = 37
r = 5

nt = 1000

hs = zeros(nt)
ls = zeros(nt)

for i in 1:1000
    U = randn(h,r)
    W = randn(r,w)
    X = U * W
    hs[i] = hopkins_statistic(U)
    Ω = A .> 0
    X̂ = R2RILS(X[Ω],Ω,r)
    ls[i] = rmsd(X,X̂,normalize=true)
end
plot(hs,ls)