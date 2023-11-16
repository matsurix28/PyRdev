#!/bin/bash

echo $PASSWORD | sudo -S chown -R ${USERID}:${GROUPID} /home/docker/workspace
umask 0002
chmod +x /home/docker/workspace/.build/cmd/*

mkdir -p /home/docker/workspace/.build/bin
ln -s /home/docker/workspace/.build/cmd/save.sh /home/docker/workspace/.build/bin/save

R -e "install.packages('renv', lib='/home/docker/library'); .libPaths('/home/docker/library'); renv::init()"

export PIPENV_VENV_IN_PROJECT=1
pipenv --python $PYTHON_VER
pipenv lock

rm /home/docker/workspace/.build/container.sh /home/docker/workspace/.build/setup.sh
mv /home/docker/workspace/.build/after/* /home/docker/workspace/.build/
rm -r /home/docker/workspace/.build/after
git init
exit
