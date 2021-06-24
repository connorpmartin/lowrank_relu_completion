include("lrmc.jl")
using StatsBase: rmsd
using Statistics: mean
using Plots
function lrmc_range_testing(;param::Symbol,param_range,num_trials::Integer = 5,input_kwargs...)
    input_kwargs = Dict{Symbol,Any}(input_kwargs)
    grades = zeros(length(param_range),num_trials)
    for i in 1:length(param_range)
        input_kwargs[param] = param_range[i]
        for j in 1:num_trials
            #run tests
            grades[i,j] = log10(lrmc_test(;input_kwargs...))
        end
    end
    avg_grades = mean(grades,dims=2)
    #@show grades
    #line plot of average grades with general grades scattered
    plot(param_range,avg_grades,xlabel = "Value of $(param)",ylabel = "Log Normalized RMSE",title = "Log RMSE vs $(param) value",label = ["Averages" "filler"])
    return scatter!(repeat(param_range,num_trials),grades[:],label = ["Individual Tests" "filler"])
end

#generates a heatmap based on the intersection of the ranges
function lrmc_multirange_testing(;x_param::Symbol,x_param_range,y_param::Symbol,y_param_range,num_trials::Integer = 5,input_kwargs...)
    input_kwargs = Dict{Symbol,Any}(input_kwargs)
    grades = zeros(length(x_param_range),length(y_param_range),num_trials)
    for i in 1:length(x_param_range)
        for j in 1:length(y_param_range)
            input_kwargs[x_param] = x_param_range[i]
            input_kwargs[y_param] = y_param_range[j]
            for k in 1:num_trials
                #run tests
                grades[i,j,k] = log10(lrmc_test(;input_kwargs...))
            end
        end
    end
    return heatmap(x_param_range,y_param_range,mean(grades,dims=3)[:,:,1],
                    c=cgrad([:blue, :white,:red]),xlabel = "Value of $(x_param)",
                    ylabel = "Value of $(y_param)",title = "Log NRMSE by $(x_param) vs $(y_param)")
end



"""

"""
function lrmc_test(;data_gen::Function = randgen,height::Integer = 100,width::Integer = 100,rank::Integer = 5,
                    mask_gen::Function = x -> x ≥ 0,lrmc_args...)
    A = data_gen(height,width,rank)
    Ω = mask_gen.(A)

    Â = lrmc(A[Ω[:]],Ω;lrmc_args...)
    

    return rmsd(A,Â,normalize=true)
end

function randgen(height::Integer = 100,width::Integer = 100,rank::Integer = 5)
    return (rand(height,rank) .- .5) * (rand(rank,width) .- .5)
end