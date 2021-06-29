using LinearAlgebra: Matrix
include("lrmc.jl")
using StatsBase: rmsd
using Statistics: mean
using Plots

function row_coherence_test(height::Integer = 100,width::Integer = 100,num_trials::Integer = 100,metric::Function = hopkins_statistic)
    
end


#modified hopkins statistic on the rows of the orthogonal matrix
#k is the size of the random subsample we use
function hopkins_statistic(U::Matrix,k::Integer = size(U,1))
    R = rand(k,size(U,2)) #random sample
    u = sample(U,)
end

#which kind of issues do antiparallels cause
#antiparallelism counteracts randomness
#imp http://www.optimization-online.org/DB_FILE/2009/03/2268.pdf?