### Notes on TCSC Narvi Cluster and CSC Puhti Cluster

#### Connect to the front end server
```bash
ssh -i ~/.ssh/RSA ni@narvi.tut.fi
ssh -i ~/.ssh/RSA nixingya@puhti.csc.fi
```

#### Check the queue status (PD refers to pending, R refers to running)
```bash
squeue --partition gpu
squeue --user "$USER"
```

#### Cancel a job or all jobs
```bash
scancel xxxxxxx
scancel --user "$USER"
```

#### Storage on Narvi
```bash
cd /sgn-data/MLG/nixingyang/Package/cache
mkdir torch keras
ln -s /sgn-data/MLG/nixingyang/Package/cache/torch /home/ni/.cache/torch
ln -s /sgn-data/MLG/nixingyang/Package/cache/keras /home/ni/.keras
```

#### Storage on Puhti
```bash
ln -s /users/nixingya/.Package /scratch/project_2000052/nixingya/Package
ln -s /scratch/project_2000052/nixingya /users/nixingya/Documents/Local\ Storage
```

#### Conda Cheat Sheet
```bash
# https://github.com/tensorflow/tensorflow/blob/v2.2.0/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
conda config --set auto_activate_base false
conda config --append channels conda-forge
conda create --yes --name TensorFlow python=3.7
conda activate TensorFlow
conda install --yes tensorflow-gpu=2.2
conda install --yes matplotlib pandas pydot scikit-image scikit-learn
conda install --yes coverage pylint yapf
conda install --yes faiss-cpu -c pytorch
pip install git+git://github.com/keras-team/keras-applications.git
pip install image-classifiers
pip install opencv-python
pip install albumentations
pip install larq larq-zoo larq-compute-engine
echo $(conda list 2>&1 | awk '$4 == "pypi" {print $1}'| tr '\n' ' ')
conda list
conda update --all
conda clean --all
conda deactivate
```

#### Mount remote directories on demand (https://wiki.archlinux.org/index.php/SSHFS)
```bash
# NB: use each sshfs mount at least once manually while root so the host's signature is added to the /root/.ssh/known_hosts file
In /etc/fstab:
ni@narvi.tut.fi:/sgn-data/MLG/nixingyang /home/xingyang/Documents/Narvi fuse.sshfs noauto,_netdev,users,idmap=user,IdentityFile=/home/xingyang/.ssh/RSA,allow_other,reconnect,follow_symlinks 0 0
nixingya@puhti.csc.fi:/scratch/project_2000052/nixingya /home/xingyang/Documents/Puhti fuse.sshfs noauto,_netdev,users,idmap=user,IdentityFile=/home/xingyang/.ssh/RSA,allow_other,reconnect,follow_symlinks 0 0
From terminal:
sudo mount /home/xingyang/Documents/Narvi
sudo mount /home/xingyang/Documents/Puhti
```

#### Useful commands in ~/.bashrc
```bash
# Load key
load_key () {
  if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
  fi
  ssh-add ~/.ssh/RSA
}

# Connect to other machines
alias connect_to_narvi='ssh -i ~/.ssh/RSA ni@narvi.tut.fi'
alias connect_to_puhti='ssh -i ~/.ssh/RSA nixingya@puhti.csc.fi'

# Activate conda environments
alias activate_TensorFlow='conda activate TensorFlow'

# Get an interactive node
cluster_interactive()
{
    command="srun --job-name="$USER"_"$(basename "$PWD")" \
    --ntasks=1 --cpus-per-task=5 --mem=60G --time=0-8:00:00 \
    --partition=gpu --gres=gpu:teslap100:1 --pty /bin/bash -i"
    if [ $(hostname -s) != "narvi" ]
    then
        command="srun --job-name="$USER"_"$(basename "$PWD")" --account=project_2000052 \
        --ntasks=1 --cpus-per-task=5 --mem=60G --time=0-8:00:00 \
        --partition=gpu --gres=gpu:v100:1 --pty /bin/bash -i"
    fi
    eval "$command"
}

# Submit a job in batch mode
cluster_batch()
{
    submit_script="submit_narvi.sh"
    if [ $(hostname -s) != "narvi" ]
    then
        submit_script="submit_puhti.sh"
    fi
    echo "Using $submit_script"
    command="sbatch --job-name="$USER"_"$(basename "$PWD")" $submit_script"
    eval "$command"
}
```

#### Additional information
```plaintext
tcsc.tau@tuni.fi
servicedesk@csc.fi
https://tinyurl.com/TCSC-narvi
https://my.csc.fi/welcome
https://docs.csc.fi/computing/overview
```
