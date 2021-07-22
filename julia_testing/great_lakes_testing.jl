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

p = lrmc_range_testing(param = :width,
                param_range = 350:350,
                #OPTIONAL ARGUMENTS
                num_trials=1,

                method = lrmc_general,
                height = 100,
                rank = 8,

                tol = 1e-10,
                verbose=true,
                show=true
                )
savefig(p,"width_plot.png")
