#script to run lrmc_range_testing properly
#install package dependencies
import Pkg
Pkg.add("Convex")
lrmc_range_testing(param = :height,
                param_range = 100:100:200,
                #OPTIONAL ARGUMENTS
                num_trials=5,
                width = 100,
                height = 100,
                rank = 5,
                data_gen = randgen, #a function of width,height,rank which we use to generate the data
                )
savefig("job_heatmap.png")
