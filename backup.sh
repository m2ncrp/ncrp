#!/bin/sh

TARGET="/resources/ncrp/scriptfiles/ncrp.db";
FILENAME="backup_"$(date +"%d%m%y_%H%M")".db.bak";
BACKUPS="/backups/";
BASEDIR=$(dirname "$0")

mkdir -p $BASEDIR$BACKUPS;
cp $BASEDIR$TARGET $BASEDIR$BACKUPS$FILENAME;

echo "created backup $FILENAME";
