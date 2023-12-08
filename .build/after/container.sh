#!/bin/bash

echo $PASSWORD | sudo -S chown -R ${USERID}:${GROUPID} ~/workspace
umask 0002

ln -s ~/workspace/.build/.bashrc ~/.bashrc
ln -s ~/workspace/.build/cmd/save.sh ~/workspace/.build/bin/save
ln -s ~/workspace/.build/cmd/apt_install.sh ~/workspace/.build/bin/apt

sudo mv /etc/apt /etc/apt.bak
sudo apt-get install --allow-downgrades -y /home/docker/workspace/.build/debs/*.deb
sudo mv /etc/apt.bak /etc/apt

R -q -e "renv::restore()"
export PIPENV_VENV_IN_PROJECT=1
pipenv --python $PYTHON_VER
pipenv sync
pipenv shell