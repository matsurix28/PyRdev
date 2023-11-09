#!/bin/bash

echo $PASSWORD | sudo -S chown -R $${USERID}:${GROUPID} /home/docker/workspace
umask 0002
chmod +x /home/docker/workspace/cmd/*

ln -s /home/docker/workspace/build/cmd/save.sh /home/docker/workspace/build/bin/save

R -e "install.packages('renv', lib='/home/docker/library'); .libPaths('/home/docker/library'); renv::init()"

export PIPENV_VENV_IN_PROJECT=1
pipenv --python $PYTHON_VER

sed -i "s/build_container.sh/cmd_container.sh/g" /home/docker/workspace/build/Dockerfile
rm /home/docker/workspace/build/build_container.sh /home/docker/workspace/build/setup.sh
git init
exit
