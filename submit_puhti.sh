#!/bin/bash

# Set the billing project
#SBATCH --account=project_2000052

# Allocate CPU resource
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5

# Allocate memory, time quota and GPU resource
#SBATCH --mem=60G
#SBATCH --time=2-23:59:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:v100:1

# Load ~/.bashrc
source ~/.bashrc

# Workaround of OSError (https://github.com/h5py/h5py/issues/1101)
export HDF5_USE_FILE_LOCKING="FALSE"

# Workaround of ImportError (https://stackoverflow.com/a/49675434)
export CC=gcc

# Execute commands
conda activate TensorFlow2.4
python3 -u solution.py

echo "All done!"
