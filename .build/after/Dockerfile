FROM python:latest as python

WORKDIR /

RUN pip install -U pip \
    && pip install pipenv \
    isort

FROM ubuntu:22.04
ARG UID=1000
ARG GID=1000
ARG PSWD=pswd

ENV USERID ${UID}
ENV GROUPID ${GID}
ENV PASSWORD ${PSWD}

COPY ./.build/debs/ /debs
COPY --from=python /usr/local/bin /usr/local/bin
COPY --from=python /usr/local/lib /usr/local/lib
COPY --from=python /usr/local/include /usr/local/include

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt install --no-install-recommends -y /debs/*.deb \
    && rm -rf /debs \
    && GROUP=`grep -E "^[^:]+:[^:]+:${GID}:" /etc/group` || true \
    && if [ -z "${GROUP}" ]; then groupadd -g ${GID} container-group; fi \
    && useradd -u ${UID} -g ${GID} docker \
    && mkdir /home/docker \
    && gpasswd -a docker sudo \
    && echo "docker ALL=(ALL) ALL" >> /etc/sudoers \
    && echo "docker:${PSWD}" | chpasswd \
    && mv /usr/bin/apt /usr/bin/apt-cmd \
    && mkdir -p /home/docker/workspace/.build/bin \
    && ln -s /home/docker/workspace/.build/.bashrc /home/docker/.bashrc \
    && ln -s /home/docker/workspace/.build/cmd/save.sh /usr/bin/save \
    && ln -s /home/docker/workspace/.build/cmd/apt-install.sh /usr/bin/apt \
    && ln -s /home/docker/workspace/.build/cmd/sync-env.sh /usr/bin/sync-env \
    && chown -R ${UID}:${GID} /home/docker    

USER docker

WORKDIR /home/docker/workspace

CMD bash /home/docker/workspace/.build/container.sh
