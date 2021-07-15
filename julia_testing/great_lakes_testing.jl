#script to run lrmc_range_testing properly
#install package dependencies
import Pkg
Pkg.add("Convex")
Pkg.add("SCS")
Pkg.add("StatsBase")
Pkg.add("Plots")
include("lrmc_range_testing.jl")
ENV["GKSwstype"] = "nul" #disable plot output

p = lrmc_range_testing(param = :width,
                param_range = 500:500,
                #OPTIONAL ARGUMENTS
                num_trials=1,

                method = lrmc_general,
                height = 50,
                rank = 8,

                verbose=true,
                show=true
                )
savefig(p,"width_plot.png")
