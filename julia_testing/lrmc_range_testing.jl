include("lrmc.jl")
using Statistics: mean
using StatsBase: median
using Plots: plot!,plot,scatter!,savefig,cgrad,xticks!,yticks!,yaxis!,xaxis!
using LinearAlgebra: norm


"""
parameter :height, :width, :rank, :method
parameter_range [100 125 150], 100:25:150 [lrmc_general lrmc_general_relaxed]

num_trials
lrmc_range_testing iterates over that parameter



height
width
rank
method = f(x,Ω,optional arguments)
datagen = f(height,width,rank)


"""
function lrmc_range_testing(;param::Symbol,param_range,multiplot_param::Symbol = param,multiplot_values = [param],num_trials::Integer = 1,input_kwargs...)
    input_kwargs = Dict{Symbol,Any}(input_kwargs)
    grades = zeros(length(param_range),num_trials)
    const_params  = filter(x -> x != param,[:height,:width,:rank])

    p = plot(xlabel = "$(param)",ylabel = "Normalized RMSE",title = "Using Julia $(input_kwargs[:method]), $(const_params[1]) = $(input_kwargs[const_params[1]]), $(const_params[2]) = $(input_kwargs[const_params[2]])",legend=:outertopright)
    p2 = plot(xlabel = "$(param)",ylabel = "Unique Convergence %",title = "Using Julia $(input_kwargs[:method]), $(const_params[1]) = $(input_kwargs[const_params[1]]), $(const_params[2]) = $(input_kwargs[const_params[2]])",legend=:outertopright)
    for i in 1:length(multiplot_values)
        input_kwargs[multiplot_param] = multiplot_values[i]
        for j in 1:length(param_range)
            input_kwargs[param] = param_range[j]
            for k in 1:num_trials
                #run tests
                grades[j,k] = lrmc_test(;input_kwargs...)
            end
        end
        median_grades = median(grades,dims=2)
        percent_grades = sum(grades .< 1e-8,dims=2) ./ size(grades,2) * 100
                    #NOTE: need to readd "multiplot_values[i]"
                    #or get this naming working for both single/multiplots.
        plot!(p,param_range,median_grades,label = ["Medians" "filler"],legend=:outertopright,yaxis=:log,color=:blue)
        scatter!(p,repeat(param_range,num_trials),grades[:],label = ["Individual Tests" "filler"],legend=:outertopright,yaxis=:log,markercolor=:white,markerstrokecolor=:red)

        plot!(p2,param_range,percent_grades,legend=:none)
    end
    #line plot of average grades with general grades scattered
    xticks!(p,param_range[1:2:end])
    yticks!(p,10.0 .^ (1:-3:-17))
    yaxis!(p,(1e-17,10))
    xaxis!(p,(param_range[1],param_range[end]))

    xticks!(p2,param_range[1:2:end])
    yticks!(p2,0:20:100)
    yaxis!(p2,(0,100))
    xaxis!(p,(param_range[1],param_range[end]))

    return p,p2
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
function lrmc_test(;data_gen::Function = rand_gen,height::Integer = 100,width::Integer = 100,rank::Integer = 5,
                    mask_gen::Function = x -> x ≥ 0,lrmc_args...)
    A = data_gen(height,width,rank)
    Ω = mask_gen.(A)

    Â = lrmc(A[Ω[:]],Ω,rank;lrmc_args...)
    
    return norm(A - Â) / norm(A)
end

function rand_gen(height::Integer = 100,width::Integer = 100,rank::Integer = 5)
    return randn(height,rank) * randn(rank,width)
end