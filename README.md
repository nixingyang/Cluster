# Notes on TCSC Narvi Cluster and CSC Puhti Cluster

## Connect to the front end server

```bash
ssh -i ~/.ssh/RSA ni@narvi.tut.fi
ssh -i ~/.ssh/RSA nixingya@puhti.csc.fi
```

## Check the queue status (PD refers to pending, R refers to running)

```bash
squeue --partition gpu
squeue --user "$USER"
```

## Cancel a job or all jobs

```bash
scancel xxxxxxx
scancel --user "$USER"
```

## Storage on Narvi

```bash
mkdir ~/Documents
ln -s /lustre/ni ~/Documents/Local\ Storage
```

## Storage on Puhti

```bash
ln -s /users/nixingya/.Package /scratch/project_2000052/nixingya/Package
ln -s /scratch/project_2000052/nixingya /users/nixingya/Documents/Local\ Storage
```

## Conda Cheat Sheet

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
conda config --set auto_activate_base false
echo $(conda list 2>&1 | awk '$4 == "pypi" {print $1}'| tr '\n' ' ')
conda list
conda update --all
conda clean --all
conda deactivate
```

```bash
# cudatoolkit, cudnn: https://github.com/tensorflow/tensorflow/blob/v2.4.0/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile
# numpy: https://github.com/tensorflow/tensorflow/issues/43679
# pylint: https://github.com/tensorflow/tensorflow/issues/43038#issuecomment-688805690
conda create --yes --name TensorFlow2.4 python=3.8
conda activate TensorFlow2.4
conda install --yes cudatoolkit=11.0 cudnn=8.0 -c nvidia
conda install --yes cython matplotlib numpy=1.18 pandas pydot scikit-learn
conda install --yes coverage pylint=2.4 rope yapf
conda install --yes faiss-gpu -c pytorch
pip install tensorflow==2.4.0 tensorflow-addons
pip install tf2cv
pip install opencv-python
pip install albumentations --no-binary imgaug,albumentations
pip install larq larq-zoo larq-compute-engine
```

```bash
# https://docs.openvinotoolkit.org/2021.1/openvino_docs_install_guides_installing_openvino_conda.html
conda create --yes --name OpenVINO python=3.8
conda activate OpenVINO
conda install --yes openvino-ie4py-ubuntu18=2021.1 -c intel
conda install --yes defusedxml flask matplotlib networkx pyyaml scipy tqdm
conda install --yes tensorboardX youtube-dl -c conda-forge
pip install tensorflow==2.4.0
pip install test-generator==0.1.1
pip install opencv-python==4.2.0.34
```

## Mount remote directories on demand (https://wiki.archlinux.org/index.php/SSHFS)

```bash
# NB: use each sshfs mount at least once manually while root so the host's signature is added to the /root/.ssh/known_hosts file
In /etc/fstab:
ni@narvi.tut.fi:/lustre/ni /home/ni/Documents/Narvi fuse.sshfs noatime,noauto,_netdev,users,idmap=user,IdentityFile=/home/ni/.ssh/RSA,allow_other,reconnect,follow_symlinks 0 0
nixingya@puhti.csc.fi:/scratch/project_2000052/nixingya /home/ni/Documents/Puhti fuse.sshfs noatime,noauto,_netdev,users,idmap=user,IdentityFile=/home/ni/.ssh/RSA,allow_other,reconnect,follow_symlinks 0 0
From terminal:
sudo mount /home/ni/Documents/Narvi
sudo mount /home/ni/Documents/Puhti
```

## Useful commands in ~/.bashrc

```bash
# Load key
load_key () {
  if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
  fi
  ssh-add ~/.ssh/RSA
}

# Get an interactive node
cluster_interactive () {
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
cluster_batch () {
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

## Additional information

```plaintext
tcsc.tau@tuni.fi
servicedesk@csc.fi
https://tinyurl.com/TCSC-narvi
https://my.csc.fi/welcome
https://docs.csc.fi/computing/overview
```
