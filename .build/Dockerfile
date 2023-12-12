FROM python:latest as python

WORKDIR /

RUN pip install -U pip \
    && pip install pipenv \
    isort

FROM ubuntu:22.04
ARG UID=1000
ARG GID=1000
ARG PSWD=pswd
ARG PY_VER=3
ARG R_VER=4.3.2

ENV USERID ${UID}
ENV GROUPID ${GID}
ENV PASSWORD ${PSWD}
ENV PYTHON_VER ${PY_VER}

RUN apt-get update \
    && apt-get install --no-install-recommends -d -y \
    sudo \
    git \
    openssh-server \
    libxml2-dev \
    software-properties-common \
    dirmngr \
    wget \
    make \
    build-essential \
    && mkdir -p /debs \
    && mv /var/cache/apt/archives/*.deb /debs/ \
    && apt-get install --no-install-recommends -y /debs/*.deb \
    && GROUP=`grep -E "^[^:]+:[^:]+:${GID}:" /etc/group` || true \
    && if [ -z "${GROUP}" ]; then groupadd -g ${GID} container-group; fi \
    && useradd -u ${UID} -g ${GID} docker \
    && mkdir /home/docker \
    && gpasswd -a docker sudo \
    && echo "docker ALL=(ALL) ALL" >> /etc/sudoers \
    && echo "docker:${PSWD}" | chpasswd \
    && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
    && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" -y \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install --no-install-recommends -d -y r-base \
    && mv /var/cache/apt/archives/*.deb /debs/ \
    && apt-get install --no-install-recommends -y /debs/*.deb \
    && Rlang_ver=`apt-cache madison r-base-core | grep $R_VER |  awk -F '\|' 'NR==1 {print $2}' | sed 's/ //g'` \
    && apt-get install --no-install-recommends --allow-downgrades -d -y r-base-core=$Rlang_ver \
    && cp /var/cache/apt/archives/*.deb /debs/ \
    && apt-get install --no-install-recommends --allow-downgrades -y /var/cache/apt/archives/*.deb \
    && apt-mark hold r-base-core \
    && mv /debs /home/docker/ \
    && chown -R ${UID}:${GID} /home/docker \
    && apt clean

COPY --from=python /usr/local/bin /usr/local/bin
COPY --from=python /usr/local/lib /usr/local/lib
COPY --from=python /usr/local/include /usr/local/include

USER docker

RUN mkdir -p ~/.cache/R/renv ~/library

WORKDIR /home/docker/workspace

CMD bash ~/workspace/.build/container.sh
