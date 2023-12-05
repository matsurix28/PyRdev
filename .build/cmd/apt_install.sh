#!/bin/bash

for arg in $@; do
  if [[ ! $arg =~ ^-.*$ ]]; then
    if [[ "$arg" == "install" ]]; then
      /usr/bin/apt-get -d $@ && cp /var/cache/apt/archives/*.deb ~/workspace/.build/debs/ && apt-get -y $@
      exit
    else
      break
    fi
  fi
done

/usr/bin/apt $@