#!/bin/bash

if [ ! -d  "plugins" ];
then
    mkdir plugins
fi

cd plugins && \
curl https://marketplace.visualstudio.com/_apis/public/gallery/publishers/marus25/vsextensions/cortex-debug/latest/vspackage -O -J --compressed && \
curl https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/python/latest/vspackage -O -J --compressed
