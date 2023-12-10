#!/bin/bash

# Download deb packages.
for arg in $@; do
  if [[ ! $arg =~ ^-.*$ ]]; then
    if [[ "$arg" == "install" ]] || [[ "$arg" == "upgrade" ]]; then
      sudo /usr/bin/apt-get -d $@ && sudo cp /var/cache/apt/archives/*.deb /home/docker/workspace/.build/debs/ && sudo apt-get -y $@
      exit
    else
      break
    fi
  fi
done

sudo /usr/bin/apt-cmd $@
