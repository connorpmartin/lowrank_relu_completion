#script to run lrmc_range_testing properly
#install package dependencies
import Pkg
Pkg.add("Convex")
lrmc_range_testing(param = :β,
                param_range = .2:.2:1,
                #OPTIONAL ARGUMENTS
                num_trials=5,

                method = lrmc_general_relaxed,
                datagen = randgen,

                width = 100,
                height = 100,
                rank = 5,


                show = true,
                β = .5,
                )
savefig("job_heatmap.png")
