#!/bin/bash

# Download deb packages.
for arg in $@; do
  if [[ ! $arg =~ ^-.*$ ]]; then
    if [[ "$arg" == "install" ]] || [[ "$arg" == "upgrade" ]]; then
      /usr/bin/apt-get -d $@ && cp /var/cache/apt/archives/*.deb /home/docker/workspace/.build/debs/ && apt-get -y $@
      exit
    else
      break
    fi
  fi
done

/usr/bin/apt-cmd $@
