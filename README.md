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
srun --job-name="$USER"_"$(basename "$PWD")" --ntasks=1 --cpus-per-task=2 --mem=16G --time=0-8:00:00 --partition=gpu --gres=gpu:teslap100:1 --pty /bin/bash -i
```

#### Submit a job in batch mode (check ~hehu/gpuBatch.sh and submit.sh)
```plaintext
sbatch --job-name="$USER"_"$(basename "$PWD")" submit.sh
```

#### Conda for Python (https://docs.conda.io/projects/conda/en/latest/user-guide/cheatsheet.html)
```plaintext
conda create --name default python=3
conda activate default
conda install cython keras matplotlib opencv scikit-image scikit-learn tensorflow-gpu==1.13.1 (" ".join(sorted("package_list".split(" "))))
conda list
conda update --all
conda deactivate
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
In /etc/fstab: ni@narvi.tut.fi:/sgn-data/MLG/nixingyang /home/xingyang/Documents/Narvi fuse.sshfs noauto,_netdev,users,idmap=user,IdentityFile=/home/xingyang/.ssh/RSA,allow_other,reconnect,follow_symlinks 0 0
From terminal: sudo mount /home/xingyang/Documents/Narvi
```

#### Example ~/.bashrc file
```plaintext
# Load key
load_key () {
  if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    ssh-add ~/.ssh/RSA
  fi
}

# Enable conda environment
enable_conda () {
  . /home/opt/anaconda3/etc/profile.d/conda.sh
  conda activate default
  export PATH=~/.conda/envs/default/bin:$PATH
}

# Get an interactive node
narvi_interactive () {
  srun --job-name="$USER"_"$(basename "$PWD")" --ntasks=1 --cpus-per-task=2 --mem=16G --time=0-8:00:00 --partition=gpu --gres=gpu:teslap100:1 --pty /bin/bash -i
}

# Submit a job in batch mode
narvi_batch () {
  sbatch --job-name="$USER"_"$(basename "$PWD")" submit.sh
}

# Models and examples built with TensorFlow
export TENSORFLOW_MODELS_PATH=~/Storage/Package/tensorflow_models_1.13.0/research
export PYTHONPATH=$TENSORFLOW_MODELS_PATH:$TENSORFLOW_MODELS_PATH/slim
```

#### Additional Information
```plaintext
tcsc.tau@tuni.fi
https://wiki.eduuni.fi/display/tuttcsc/GPU+resources
```