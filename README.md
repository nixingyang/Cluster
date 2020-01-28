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
srun --job-name="$USER"_"$(basename "$PWD")" --ntasks=1 --cpus-per-task=5 --mem=60G --time=0-8:00:00 --partition=gpu --gres=gpu:teslap100:1 --pty /bin/bash -i
```

#### Submit a job in batch mode (check ~hehu/gpuBatch.sh and submit.sh)
```plaintext
sbatch --job-name="$USER"_"$(basename "$PWD")" submit.sh
```

#### Storage
```plaintext
Save everything to /sgn-data/MLG and avoid using home directory.
cd /sgn-data/MLG/nixingyang/Package/cache
mkdir torch keras
ln -s /sgn-data/MLG/nixingyang/Package/cache/torch /home/ni/.cache/torch
ln -s /sgn-data/MLG/nixingyang/Package/cache/keras /home/ni/.keras
```

#### Conda for Python (https://docs.conda.io/projects/conda/en/latest/user-guide/cheatsheet.html)
```plaintext
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
conda config --set auto_activate_base false
conda config --append channels conda-forge
conda create --yes --name default python=3
conda activate default
conda install --yes matplotlib pandas pydot scikit-image scikit-learn tensorflow-gpu=1 (" ".join(sorted("package_list".split(" "))))
conda install --yes coverage pylint yapf
pip install --upgrade git+git://github.com/keras-team/keras-applications.git
pip install opencv-python
pip install albumentations
pip install -U $(conda list 2>&1 | awk '$4 == "pypi" {print $1}'| tr '\n' ' ')
conda list
conda update --all
conda update -n base -c defaults conda
conda clean --all
conda deactivate
```

#### Cancel the job
```plaintext
scancel --user "$USER"
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
  fi
  ssh-add ~/.ssh/RSA
}

# Connect to the narvi front-end server
alias connect_to_narvi='ssh -i ~/.ssh/RSA ni@narvi.tut.fi'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/sgn-data/MLG/nixingyang/Package/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/sgn-data/MLG/nixingyang/Package/miniconda/etc/profile.d/conda.sh" ]; then
        . "/sgn-data/MLG/nixingyang/Package/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/sgn-data/MLG/nixingyang/Package/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Enable conda environment
enable_conda () {
  conda activate default
}

# Get an interactive node
narvi_interactive () {
  srun --job-name="$USER"_"$(basename "$PWD")" --ntasks=1 --cpus-per-task=5 --mem=60G --time=0-8:00:00 --partition=gpu --gres=gpu:teslap100:1 --pty /bin/bash -i
}

# Submit a job in batch mode
narvi_batch () {
  sbatch --job-name="$USER"_"$(basename "$PWD")" submit.sh
}

# 7-Zip
export PATH=/sgn-data/MLG/nixingyang/Package/p7zip_16.02/bin:$PATH

# gdrive
export PATH=/sgn-data/MLG/nixingyang/Package/gdrive_2.1.0:$PATH
```

#### Additional Information (tcsc.tau@tuni.fi and https://wiki.eduuni.fi/display/tuttcsc/GPU+resources)
| GPU Type | GPUs Per Node (* Node Amount) | CPUs Per Node | RAM Per Node |
| - | - | - | - |
| Tesla P100 PCIe 12GB | 4 (* 6) | 20 | 251G |
| Tesla P100 PCIe 16GB | 4 (* 2) | 20 | 251G |
| Tesla V100 PCIe 16GB | 4 (* 2) | 24 | 376G |
| Tesla V100 PCIe 32GB | 4 (* 2) | 24 | 754G |
