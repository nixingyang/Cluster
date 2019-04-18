### Notes on Narvi Cluster

#### Connect to the front end server
```plaintext
ssh -i ~/.ssh/RSA ni@narvi.tut.fi
```

#### Check the cluster info (nag is better than meg)
```plaintext
sinfo
```

#### Check the queue status (PD refers to pending, R refers to running)
```plaintext
squeue --partition=gpu
squeue --user "$USER"
```

#### Get an interactive node (check ~hehu/getGpu.sh)
```plaintext
srun --job-name="$USER"_"$(basename "$PWD")" --ntasks=1 --cpus-per-task=2 --mem=16G --time=0-7:59:00 --partition=gpu --gres=gpu:1 --pty /bin/bash -i
```

#### Conda for Python (https://docs.conda.io/projects/conda/en/latest/user-guide/cheatsheet.html)
```plaintext
conda create --name default python=3
conda activate default
conda install cython keras matplotlib opencv scikit-image scikit-learn tensorflow-gpu==1.13.1 (" ".join(sorted("package_list".split(" "))))
conda list
conda deactivate
```

#### Submit a job in batch mode (check ~hehu/gpuBatch.sh and submit.sh)
```plaintext
sbatch --job-name="$USER"_"$(basename "$PWD")" submit.sh
```

#### Cancel the job
```plaintext
scancel --user "$USER"
```

#### Storage
```plaintext
save data to /sgn-data/MLG
```

#### Mount remote directories on demand (https://wiki.archlinux.org/index.php/SSHFS)
```plaintext
# NB: use each sshfs mount at least once manually while root so the host's signature is added to the /root/.ssh/known_hosts file
# Narvi
ni@narvi.tut.fi:/sgn-data/MLG/nixingyang /home/xingyang/Documents/Narvi fuse.sshfs noauto,x-systemd.automount,_netdev,users,idmap=user,IdentityFile=/home/xingyang/.ssh/RSA,allow_other,reconnect,follow_symlinks 0 0
```

#### Load modules (obsolete)
```plaintext
module list
module avail (list the available modules)
module load CUDA/9.0
```