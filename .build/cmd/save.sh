#!/bin/bash

# Delete unused packages. 
ls -1 ~/workspace/.build/debs > ~/workspace/.build/debs.list
while read line; do
  package=`echo ${line%%_*} | sed -e 's/%3a/:/g'`
  version=`echo ${line#*_} | sed -e 's/_.*//g' -e 's/%3a/:/g'`
  if ! dpkg -l $package 2>&1 | grep -e "^ii" -e "^hi" | grep -q "$version" > /dev/null 2>&1; then
    rm ~/workspace/.build/debs/$line
  fi
done < ~/workspace/.build/debs.list

# Make list of installed packages.
dpkg -l | grep "^ii" | awk '{print $2"="$3}' > ~/workspace/.build/installed_packages.list

# Lock R packages.
cd ~/workspace
R -q -e "renv::install(); renv::snapshot()"
