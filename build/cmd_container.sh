#!/bin/bash

echo $PASSWORD | sudo -S chown -R ${USERID}:${GROUPID} /home/docker/workspace
umask 0002

cp /home/docker/workspace/build/.bashrc /home/docker/

while read line
do
    apt-get install -y $line
done < /home/docker/workspace/build/apt_packages.txt

R -e "renv::restore()"
pipenv sync
pipenv shell