#!/bin/sh

TARGET="./resources/ncrp/scriptfiles/ncrp.db";
FILENAME="backup_"$(date +"%d%m%y_%H%M")".db.bak";
BACKUPS="./backups";

mkdir -p $BACKUPS;

cp $TARGET $BACKUPS$FILENAME;
