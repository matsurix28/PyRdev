#!/bin/bash

sudo apt-get install --no-install-recommends --allow-downgrades -y /home/docker/workspace/.build/debs/*.deb
sudo chown -R ${USERID}:${GROUPID} /home/docker/workspace

R -q -e "renv::restore()"
pipenv sync