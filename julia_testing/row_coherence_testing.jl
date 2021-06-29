include("lrmc.jl")
using StatsBase: rmsd
using Statistics: mean
using Plots

function row_coherence_test(height::Integer = 100,width::Integer = 100,num_trials::Integer = 100,metric::Function = )
    
end


#modified hopkins statistic on the rows of the orthogonal matrix
#k is the size of the random subsample we use
function hopkins_statistic(U::Matrix,k::Integer = size(U,1))
    R = rand(size(U)) #sample 
end