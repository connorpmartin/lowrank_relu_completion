using LinearAlgebra: Matrix,norm
include("lrmc.jl")
using StatsBase: rmsd
using Statistics: mean,sample
using Plots

function row_coherence_bias_test(height::Integer = 100,width::Integer = 100,rank::Integer = 8,num_trials::Integer = 100,metric::Function = hopkins_statistic)
    results = zeros(num_trials,2)
    for i in 1:num_trials
        x = randn()

    end
end


#modified hopkins statistic on the rows of the orthogonal matrix
#we want maximally distributed 
#k is the size of the random subsample we use
function hopkins_statistic(U::Matrix;k::Integer = size(U,1))
    r = randn(k,size(U,2)) 
    r ./= mapslices(norm,r,dims=[2]) #make them into unit vectors
    subset = sample(1:size(U,1),(k),replace=false)
    u = U[subset,:]

    #calculate the dot product of each element of r with each element of u (to determine average closeness)
    dots = r * U'

    #calculate the dot product of each element of x with each other element of x (to determine closeness)
    dots_u = u * U'

    #we're not considering the dot product of u with itself here
    dots_u[((x,y) -> CartesianIndex(x,y)).(1:k,subset)] .= -Inf #they aren't considered


    #calculate nearest neighbor distance (everything is a unit vector so dot product is directly proportional to cos(theta))
    #also refactor so the values go from 0 (aligned) to 2 (antialigned)
    #the division means that the scale factor is irrelevant
    #however we may want to consider antiparallel objects to be infinitely far apart from one another
    nn_ur = -1 .* (maximum(dots,dims=2) .- 1)
    nn_uu = -1 .* (maximum(dots_u,dims=2) .- 1)


    return sum(nn_ur) / (sum(nn_uu) + sum(nn_ur))
end

#which kind of issues do antiparallels cause
#antiparallelism counteracts randomness & should therefore be a good thing
#so we can check for even spacing over the entire thing
#imp http://www.optimization-online.org/DB_FILE/2009/03/2268.pdf?



#NOTE: see https://stackoverflow.com/questions/9750908/how-to-generate-a-unit-vector-pointing-in-a-random-direction-with-isotropic-dist
#for a justification for why randn generates rotationally symmetric vectors


