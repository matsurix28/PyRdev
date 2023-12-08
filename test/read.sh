#!/bin/bash

while read line; do
  package=${line%%,*}
  version=${line##*,}
  echo package
  echo $package
  echo version
  echo $version
done < ~/PyRdev/test/apt_install.csv