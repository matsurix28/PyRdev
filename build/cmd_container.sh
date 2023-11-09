#!/bin/bash

export PATH="$PATH:/home/docker/workspace/build/bin"

echo $PASSWORD | sudo -S chown -R ${USERID}:${GROUPID} /home/docker/workspace
umask 0002

while read line
do
    apt-get install -y $line
done < /home/docker/workspace/build/apt_packages.txt

R -e "renv::restore()"
pipenv sync
pipenv shell