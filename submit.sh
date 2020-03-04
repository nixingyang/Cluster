#!/bin/bash

# Allocate CPU resource
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5

# Allocate memory, time quota and GPU resource
#SBATCH --mem=60G
#SBATCH --time=6-23:59:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:teslav100:1
#SBATCH --constraint=gpumem_32

# Load ~/.bashrc
source ~/.bashrc

# Workaround of OSError (https://github.com/h5py/h5py/issues/1101)
export HDF5_USE_FILE_LOCKING='FALSE'

# Execute commands
conda activate TensorFlow
python3 -u solution.py

echo "All done!"
