#!/bin/bash -l
#SBATCH --job-name=matlab_test
#SBATCH --account=girasole1 # adjust this to match the accounting group you are using to submit jobs
#SBATCH --time=0-03:00         # adjust this to match the walltime of your job
#SBATCH --nodes=1      
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1      # adjust this if you are using parallel commands
#SBATCH --mem=4000             # adjust this according to the memory requirement per node you need
#SBATCH --mail-user=connorpm@umich.edu # adjust this to match your email address
#SBATCH --mail-type=ALL

# Choose a version of MATLAB by loading a module:
module load matlab
# Remove -singleCompThread below if you are using parallel commands:
matlab -nodisplay -singleCompThread -r "mc_columns"