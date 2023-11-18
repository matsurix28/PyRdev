#!/bin/bash

echo $PASSWORD | sudo -S chown -R ${USERID}:${GROUPID} ~/workspace
umask 0002

ln -s ~/workspace/.build/.bashrc ~/.bashrc

while read line
do
    apt-get install -y $line
done < ~/workspace/.build/apt_packages.txt

R -q -e "renv::restore()"
export PIPENV_VENV_IN_PROJECT=1
pipenv --python $PYTHON_VER
pipenv sync
pipenv shell