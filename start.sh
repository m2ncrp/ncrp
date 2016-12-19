#!/bin/sh

BASEDIR=$(dirname "$0");
TARGET="m2online-svr.exe";

c=1;
while [ $c -le 5 ]; do
    /usr/bin/wine $BASEDIR"/"$TARGET
    sleep 1;
done
