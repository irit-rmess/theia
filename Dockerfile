FROM ubuntu:disco

WORKDIR /theia

RUN apt update && apt install -y curl apt-transport-https gnupg

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ rc main" |  tee /etc/apt/sources.list.d/yarn.list


RUN apt update && \
    apt install -y --no-install-recommends yarn nodejs npm clang-tools-8 g++ make git &&\
    update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-8 100

RUN apt-get install -y python3 python3-pip && \
    update-alternatives --install /usr/bin/python python /usr/bin/python2 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 2 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 2 && \
    pip install -U pylint python-language-server

ENV NODE_OPTIONS=$NODE_OPTIONS--max-old-space-size=2098

COPY package.json package.json

RUN yarn
RUN yarn theia build

COPY plugins plugins

CMD ["yarn","start"]

EXPOSE 80
ENV SHELL /bin/bash
