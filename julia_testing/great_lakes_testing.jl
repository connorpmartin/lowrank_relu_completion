#script to run lrmc_range_testing properly
#install package dependencies
import Pkg
Pkg.add("Convex")
Pkg.add("Mosek")
Pkg.add("MosekTools")
Pkg.add("StatsBase")
Pkg.add("Plots")
include("lrmc_range_testing.jl")
ENV["GKSwstype"] = "nul" #disable plot output
ENV["MOSEKLM_LICENSE_FILE"] = "$(pwd())/mosek.lic" #the license file is in the working directory with everything else
@show ENV["MOSEKLM_LICENSE_FILE"]
p = lrmc_range_testing(param = :width,
                param_range = 50:50,
                #OPTIONAL ARGUMENTS
                num_trials=1,

                method = lrmc_general,
                height = 50,
                rank = 8,

                verbose=true,
                show=true
                )
savefig(p,"width_plot.png")
