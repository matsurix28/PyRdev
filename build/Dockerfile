FROM python:latest as python

WORKDIR /

RUN pip install -U pip \
    && pip install pipenv \
    isort

FROM r-base:latest

ARG UID=1000
ARG GID=1000
ARG PSWD=pswd
ARG PY_VER=3

ENV USERID ${UID}
ENV GROUPID ${GID}
ENV PASSWORD ${PSWD}
ENV PYTHON_VER ${PY_VER}

RUN apt-get update \
    && apt-get install --no-install-recommends -y sudo \
    expat \
    git \
    && apt-get clean \
    && GROUP=`grep -E "^[^:]+:[^:]+:${GID}:" /etc/group` || true \
    && if [ -z "${GROUP}" ]; then groupadd -g ${GID} container-group; fi \
    && usermod -u ${UID} -g ${GID} docker \
    && gpasswd -a docker sudo \
    && echo "docker ALL=(ALL) ALL" >> /etc/sudoers \
    && echo "docker:${PSWD}" | chpasswd \
    && rm /var/log/apt/history.log

COPY --from=python /usr/local/bin /usr/local/bin
COPY --from=python /usr/local/lib /usr/local/lib
COPY --from=python /usr/local/include /usr/local/include

USER docker

RUN mkdir -p /home/docker/.cache/R/renv /home/docker/library

WORKDIR /home/docker/workspace

CMD echo ${PASSWORD} | sudo -S chown -R ${USERID}:${GROUPID} /home/docker/workspace \
    && umask 0002 \
    && bash /home/docker/workspace/build/container.sh
