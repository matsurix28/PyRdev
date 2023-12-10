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

ENV USERID ${UID}
ENV GROUPID ${GID}
ENV PASSWORD ${PSWD}
ENV PYTHON_VER ${PY_VER}

COPY ./.build/debs/ /debs
COPY --from=python /usr/local/bin /usr/local/bin
COPY --from=python /usr/local/lib /usr/local/lib
COPY --from=python /usr/local/include /usr/local/include

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt install --no-install-recommends -y /debs/*.deb \
    && GROUP=`grep -E "^[^:]+:[^:]+:${GID}:" /etc/group` || true \
    && if [ -z "${GROUP}" ]; then groupadd -g ${GID} container-group; fi \
    && useradd -u ${UID} -g ${GID} docker \
    && mkdir /home/docker \
    && chown -R ${UID}:${GID} /home/docker \
    && gpasswd -a docker sudo \
    && echo "docker ALL=(ALL) ALL" >> /etc/sudoers \
    && echo "docker:${PSWD}" | chpasswd \
    && mv /usr/bin/apt /usr/bin/apt-cmd \
    && rm -rf /debs \
    && apt-get clean

USER docker

RUN mkdir -p ~/.cache/R/renv ~/library

WORKDIR /home/docker/workspace

CMD bash ~/workspace/.build/container.sh
