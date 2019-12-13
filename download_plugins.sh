#!/bin/bash

if [ ! -d  "plugins" ];
then
    mkdir plugins
if

cd plugins && \
curl https://marketplace.visualstudio.com/_apis/public/gallery/publishers/marus25/vsextensions/cortex-debug/0.3.4/vspackage -O -J --compressed && \
curl https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/python/2019.11.50794/vspackage -O -J --compressed
