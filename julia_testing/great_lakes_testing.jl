#script to run lrmc_range_testing properly
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

p = lrmc_range_testing(param = :rank,
                param_range = 3:2:15,
                #OPTIONAL ARGUMENTS
                num_trials=20,
                multiplot_param = :method,
                multiplot_values = [R2RILS,lrmc_general],

                width=50,
                height = 50,

                eps = 1e-10,
                verbose=true,
                show=true
                )
savefig(p,"40b40.png")
