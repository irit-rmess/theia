FROM ubuntu:19.04

WORKDIR /theia

RUN apt update && apt install -y curl apt-transport-https gnupg

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ rc main" |  tee /etc/apt/sources.list.d/yarn.list


RUN apt update && \
    apt install -y --no-install-recommends yarn nodejs npm clang-tools-8 g++ make git &&\
    update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-8 100

RUN apt-get install -y python python3 python-pip python3-pip &&\
    python3 -m pip install -U pylint python-language-server --user

ENV NODE_OPTIONS=$NODE_OPTIONS--max-old-space-size=2098

RUN mkdir plugins && cd plugins && \
    curl https://marketplace.visualstudio.com/_apis/public/gallery/publishers/marus25/vsextensions/cortex-debug/0.3.1/vspackage -O -J --compressed && \
    curl https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/python/2019.6.22090/vspackage -O -J --compressed

COPY package.json package.json

RUN yarn
RUN yarn theia build
CMD ["yarn","start"]

EXPOSE 80
ENV SHELL /bin/bash
