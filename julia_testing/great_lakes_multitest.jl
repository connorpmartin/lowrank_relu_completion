#script to properly run multitesting
#install package dependencies
import Pkg
Pkg.add("Convex")
Pkg.add("SCS")
Pkg.add("StatsBase")
Pkg.add("Plots")
Pkg.add("IterativeSolvers")
Pkg.add("SparseArrays")
include("lrmc_range_testing.jl")
ENV["GKSwstype"] = "nul" #disable plot output

val = Dict(0 => "scs",1 => "R2RILS")
#list trials here
trials = Array{Dict}(undef,8)

trials[1] = Dict(:param => :rank,
:param_range => 2:2:20,
:num_trials=>20,
:eps => 1e-15,
:verbose => false,
:width =>40,
:height => 40,
:method => scs,)

trials[2] = Dict(:param => :rank,
:param_range => 2:2:20,
:num_trials=>20,

:width =>40,
:height => 40,
:method => R2RILS,)

trials[3] = Dict(:param => :rank,
:param_range => cat(2:4:14, 18:8:50,dims=1),
:num_trials=>20,
:eps => 1e-15,
:verbose => false,

:width =>100,
:height => 100,
:method => scs,)

trials[4] = Dict(:param => :rank,
:param_range => cat(2:4:14, 18:8:50,dims=1),
:num_trials=>20,

:width =>100,
:height => 100,
:method => R2RILS,)

trials[5] = Dict(:param => :width,
:param_range => 100:25:300,
:num_trials=>20,
:eps => 1e-15,
:verbose => false,

:height => 100,
:rank => 10,
:method => scs,)

trials[6] = Dict(:param => :width,
:param_range => 100:25:300,
:num_trials=>20,

:height => 100,
:rank => 10,
:method => R2RILS,)

trials[7] = Dict(:param => :width,
:param_range => 100:25:300,
:num_trials=>20,
:eps => 1e-15,
:verbose => false,

:height => 100,
:rank => 5,
:method => scs,)

trials[8] = Dict(:param => :width,
:param_range => 100:25:300,
:num_trials=>20,

:height => 100,
:rank => 5,
:method => R2RILS,)


Threads.@threads for i in 1:length(trials)
    p1,p2 = lrmc_range_testing(;trials[i]...)
    savefig(p1,"trial$(i)_$(val[i % 2])_nrmse.png")
    savefig(p2,"trial$(i)_$(val[i % 2])_percent.png")
end
