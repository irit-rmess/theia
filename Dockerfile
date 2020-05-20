FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /root/theia

RUN apt update && apt install -y curl apt-transport-https gnupg make git

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ rc main" |  tee /etc/apt/sources.list.d/yarn.list

RUN curl -sS https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster main" > /etc/apt/sources.list.d/llvm.list

RUN apt update

RUN apt install -y --no-install-recommends yarn nodejs npm

RUN apt install -y --no-install-recommends \
        clang-tools-11 \
        clangd-11 \
        clang-tidy-11 && \
    ln -s /usr/bin/clangd-11 /usr/bin/clangd && \
    ln -s /usr/bin/clang-tidy-11 /usr/bin/clang-tidy

RUN apt install -y python3 python3-pip && \
    update-alternatives --install /usr/bin/python python /usr/bin/python2 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 2 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 2 && \
    pip install -U pylint python-language-server

RUN rm -rf /var/lib/apt/lists/*

COPY package.json package.json

RUN yarn --cache-folder ./ycache && rm -rf ./ycache && \
     NODE_OPTIONS="--max_old_space_size=4096" yarn theia build ; \
    yarn theia download:plugins

EXPOSE 80
ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/root/theia/plugins

ENTRYPOINT ["yarn", "theia", "start", "--hostname=0.0.0.0", "--port=80"]
