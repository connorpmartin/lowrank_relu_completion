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

p1,p2 = lrmc_range_testing(param = :rank,
                param_range = 2:2:20,
                #OPTIONAL ARGUMENTS
                num_trials=20,

                width=40,
                height = 40,
                method = R2RILS,
                )
savefig(p,"trial1_nrmse.png")
savefig(p,"trial1_percent.png")
