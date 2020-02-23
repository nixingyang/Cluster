### Notes on TCSC Narvi Cluster

#### Connect to the front end server
```plaintext
ssh -i ~/.ssh/RSA ni@narvi.tut.fi
```

#### Check the queue status (PD refers to pending, R refers to running)
```plaintext
squeue --partition gpu
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

#### Cancel a job or all jobs
```plaintext
scancel xxxxxxx
scancel --user "$USER"
```

#### Storage (avoid using the home directory whenever possible)
```plaintext
cd /sgn-data/MLG/nixingyang/Package/cache
mkdir torch keras
ln -s /sgn-data/MLG/nixingyang/Package/cache/torch /home/ni/.cache/torch
ln -s /sgn-data/MLG/nixingyang/Package/cache/keras /home/ni/.keras
```

#### Conda Cheat Sheet
```plaintext
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
conda config --set auto_activate_base false
conda config --append channels conda-forge
conda create --yes --name TensorFlow python=3
conda activate TensorFlow
conda install --yes pydot tensorflow-gpu=1
conda install --yes matplotlib pandas scikit-image scikit-learn
conda install --yes coverage pylint yapf
pip install --upgrade git+git://github.com/keras-team/keras-applications.git
pip install image-classifiers
pip install opencv-python
pip install albumentations
pip install larq larq-zoo zookeeper
pip install --upgrade git+git://github.com/larq/larq.git
echo $(conda list 2>&1 | awk '$4 == "pypi" {print $1}'| tr '\n' ' ')
conda list
conda update --all
conda clean --all
conda deactivate
```

#### Mount remote directories on demand (https://wiki.archlinux.org/index.php/SSHFS)
```plaintext
# NB: use each sshfs mount at least once manually while root so the host's signature is added to the /root/.ssh/known_hosts file
In /etc/fstab: ni@narvi.tut.fi:/sgn-data/MLG/nixingyang /home/xingyang/Documents/Narvi fuse.sshfs noauto,_netdev,users,idmap=user,IdentityFile=/home/xingyang/.ssh/RSA,allow_other,reconnect,follow_symlinks 0 0
From terminal: sudo mount /home/xingyang/Documents/Narvi
```

#### Useful commands in ~/.bashrc
```plaintext
# Load key
load_key () {
  if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
  fi
  ssh-add ~/.ssh/RSA
}

# Connect to other machines
alias connect_to_narvi='ssh -i ~/.ssh/RSA ni@narvi.tut.fi'

# Activate conda environments
alias activate_TensorFlow='conda activate TensorFlow'

# Get an interactive node
alias narvi_interactive='srun --job-name="$USER"_"$(basename "$PWD")" --ntasks=1 --cpus-per-task=5 --mem=60G --time=0-8:00:00 --partition=gpu --gres=gpu:teslap100:1 --pty /bin/bash -i'

# Submit a job in batch mode
alias narvi_batch='sbatch --job-name="$USER"_"$(basename "$PWD")" submit.sh'
```

#### Additional Information
```plaintext
Watch the introductory video: https://tinyurl.com/TCSC-narvi.
Send an email to tcsc.tau@tuni.fi.

| GPU Type | GPUs Per Node (* Node Amount) | CPUs Per Node | RAM Per Node |
| - | - | - | - |
| Tesla P100 PCIe 12GB | 4 (* 6) | 20 | 251G |
| Tesla P100 PCIe 16GB | 4 (* 2) | 20 | 251G |
| Tesla V100 PCIe 16GB | 4 (* 2) | 24 | 376G |
| Tesla V100 PCIe 32GB | 4 (* 2) | 24 | 754G |
```
