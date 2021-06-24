include("lrmc.jl")
using StatsBase: rmsd
using Plots: plot,scatter!
function lrmc_range_testing(param::Symbol,param_range;num_trials::Integer = 5,input_kwargs...)
    input_kwargs = Dict{Symbol,Any}(input_kwargs)
    grades = zeros(length(param_range),num_trials)
    for i in 1:length(param_range)
        input_kwargs[param] = param_range[i]
        for j in 1:num_trials
            #run tests
            grades[i,j] = lrmc_test(;input_kwargs...)
        end
    end
    avg_grades = mean(grades,dims=2)
    #line plot of average grades with general grades scattered
    plot(param_range,avg_grades)
    return scatter!(param_range,avg_grades)
end

"""

"""
function lrmc_test(;num_trials::Integer = 5,data_gen::Function = randgen,mask_gen::Function = x -> rand() < .5,method::Symbol = :general,time::Bool = false,datagen_args...)
    A = data_gen(;datagen_args...)
    Ω = mask_gen.(A)
    Â = lrmc(A[Ω[:]],Ω,method = method,time = time)

    return rmsd(A,Â,normalize=true)
end

function randgen(;height::Integer = 100,width::Integer = 100,rank::Integer = 5)
    return rand(height,rank) * rand(rank,width)
end