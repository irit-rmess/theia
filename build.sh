#!/bin/bash
./download_plugins.sh

DOCKER="docker build . -t iritrmess/theia"
if [ $USER != "root" ];
then
    sudo $DOCKER
else
    $DOCKER
fi
