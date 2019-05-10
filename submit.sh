#!/bin/bash

# Allocate CPU resource
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4

# Allocate memory, time quota and GPU resource
#SBATCH --mem=32G
#SBATCH --time=6-23:59:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:teslav100:1
#SBATCH --constraint=gpumem_32

# These commands will be executed on the compute node:

# Load .bashrc file and activate python virtual environment
source ~/.bashrc
enable_conda

# Finally run your job
python3 -u solution.py

echo "All done!"