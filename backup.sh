#!/bin/sh

FILENAME="backup_"$(date +"%d%m%y_%H%M")".gz";
BACKUPS="/backups/";
BASEDIR=$(dirname "$0")

mkdir -p $BASEDIR$BACKUPS;
/usr/bin/mysqldump -u root -p"y9Dt6^f2fNU;8RLU4{xP" ncrp | gzip -v > $FILENAME;

echo "created backup $FILENAME";
