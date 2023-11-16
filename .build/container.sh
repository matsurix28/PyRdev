#!/bin/bash

echo $PASSWORD | sudo -S chown -R ${USERID}:${GROUPID} ~/workspace
umask 0002
chmod +x ~/workspace/.build/cmd/*

mkdir -p ~/workspace/.build/bin
ln -s ~/workspace/.build/cmd/save.sh ~/workspace/.build/bin/save

R -q -e "install.packages('renv', lib='~/library'); .libPaths('~/library'); renv::init()"
rm -rf ~/library

export PIPENV_VENV_IN_PROJECT=1
pipenv --python $PYTHON_VER
pipenv lock

rm ~/workspace/.build/container.sh ~/workspace/.build/setup.sh
mv ~/workspace/.build/after/* ~/workspace/.build/
rm -r ~/workspace/.build/after
git init
exit
