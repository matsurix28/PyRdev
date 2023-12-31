#!/bin/bash

Ubuntu_ver=22.04

USER_ID=$(id -u)
GROUP_ID=$(id -g)

# For Rootless Docker
if [ -n "$(docker info 2>&1 | grep 'rootless')" ]; then
  ROOTLESS=true
  # Add rootless-docker group
  SUBGID=`grep "^${USER}:" /etc/subgid | grep -oE ":[0-9]+:" | sed "s/://g"`
  CONTAINER_GID=$(( $SUBGID + $USER_ID - 1 ))
  
  # Check group already exists
  if [ -z "$(grep -E "^[^:]+:[^:]+:$CONTAINER_GID:" /etc/group)" ]; then
    echo "Create Rootless-docker group"
    GNAME=rootless-$USER
    sudo groupadd -g $CONTAINER_GID $GNAME
  else
    GNAME=`grep -E "^[^:]+:[^:]+:$CONTAINER_GID:" /etc/group | grep -oE "^[^:]+"`
  fi
  if [ -z "$(id -G | grep $CONTAINER_GID)" ]; then
    echo "Add Rootless-docker group to use docker bind mount."
    sudo gpasswd -a $USER $GNAME
  fi
else
  ROOTLESS=false
fi

ROOT=$(cd $(dirname $0)/..; pwd)
PARENT=$(cd $(dirname $0)/../..; pwd)

# Set Ubuntu version
FIRST=true
read -p "Enter Ubuntu vsersion (default: $Ubuntu_ver): " UBU_VER

while true; do
  if ! "$FIRST"; then
    echo "Error, couldn't pull ubuntu:$UBU_VER. "
    read -p "Retype Ubuntu version: " UBU_VER
  fi
  FIRST=false
  if [[ "$UBU_VER" == "" ]]; then
    UBU_VER="$Ubuntu_ver"
  fi
  docker pull -q ubuntu:$UBU_VER && break
done

# Set Python version
FIRST=true
read -p "Enter Python vsersion (default: latest): " PY_VER

while true; do
  if ! "$FIRST"; then
    echo "Error, couldn't pull python:$PY_VER. "
    read -p "Retype Python version: " PY_VER
  fi
  FIRST=false
  if [[ "$PY_VER" == "" ]]; then
    PY_VER="latest"
  fi
  docker pull -q python:$PY_VER && break
done

# Set R version
FIRST=true
read -p "Enter R vsersion (default: latest): " R_VER

while true; do
  if ! "$FIRST"; then
    echo "Error, couldn't pull r-base:$R_VER. "
    read -p "Retype R version: " R_VER
  fi
  FIRST=false
  if [[ "$R_VER" == "" ]]; then
    R_VER="latest"
  fi
  docker pull -q r-base:$R_VER && break
done

# Set Project name
read -p "Enter Project Name: " ProjName
while [[ ! $ProjName =~ ^[a-zA-Z0-9]+([a-zA-Z0-9]|-|_)*[a-zA-Z0-9]+$ ]] || [[ $ProjName =~ .*(-_|_-).* ]]; do
  echo "$ProjName: Invalid reference format. Only '-' or '_' is allowed."
  read -p "Retype Project Name: " ProjName
done

while true; do
  # Check directory
  while [ -e $PARENT/${ProjName} ]; do
    echo "Directory $ProjName already exists."
    read -p "Enter New Project Name: " ProjName
  done

  # Check docker container
  CONTAINER=$(docker container ls -a -q -f name="^${ProjName,,}-r-[0-9]*$")
  if [ -n "$CONTAINER" ]; then
    echo "Container $ProjName already exists."
    read -p "Do you want to overwrite container? [y/N]: " yn
    case "$yn" in
      [yY]*) echo "Removing container..."
             docker stop $CONTAINER
             docker container rm $CONTAINER
             docker rmi ${ProjName,,}-r
             break;;
      *) read -p "Enter New Project Name: " ProjName;;
    esac
  else
    break
  fi
done

ProjDir=$PARENT/$ProjName
cp -r $ROOT $ProjDir
rm -rf $ProjDir/.git $ProjDir/README.md
mv $ProjDir/.build/after/README.md $ProjDir/README.md
sed -i"" -e "s/FROM ubuntu.*$/FROM ubuntu:$UBU_VER/" $ProjDir/.build/Dockerfile
sed -i"" -e "s/FROM python.*$/FROM python:$PY_VER as python/" $ProjDir/.build/Dockerfile
sed -i"" -e "s/FROM python.*$/FROM python:$PY_VER as python/" $ProjDir/.build/after/Dockerfile

# Generate .env file
echo "Setting UID, GID and Project name."
echo "UID=$USER_ID" > $ProjDir/.env
echo "GID=$GROUP_ID" >> $ProjDir/.env
echo "COMPOSE_PROJECT_NAME=${ProjName,,}" >> $ProjDir/.env
echo "PY_VER=$PY_VER" >> $ProjDir/.env
echo "R_VER=$R_VER" >> $ProjDir/.env

# Initial setting
if [ -z "$(docker volume ls -q -f name='renv')" ]; then
  echo "Create renv volume."
  docker volume create renv
fi

# Start docker container
cd $ProjDir
echo "Compose up."
echo "Initializing renv..."
docker compose up
docker container rm ${ProjName,,}-dev-1
docker rmi ${ProjName,,}-dev
echo "Add write permission to working directory."
if "$ROOTLESS"; then
  sudo chmod -R g+w $ProjDir
fi
git config --global --add safe.directory $ProjDir
echo "Setup is complete. Please restart shell to reflect groupadd."
