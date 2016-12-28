# ncrp

Hey there. If you see this - it means you are awesome!

## Installation

Clone the repo:

```
$ git clone git@github.com:Inlife/ncrp.git
```

Get the server (windows):

```
$ wget http://download.mafia2-online.com/versions/01-RC3/public/m2o_rc3_server_release.zip && unzip m2o_rc3_server_release.zip
```

Start it!

```sh
./m2online-svr.exe
```

## Database

Database is inside `/resources/ncrp/scriptfiles/ncrp.db` (SQLite).
All tables are created automatically.

If you want to swtich to MySQL, copy file `default.mysql` to `.mysql` and change settings in the new file. Also dont forget to create database! :D


## Environments

By default server is running in the "debug" environment. Which means that code inside can be checked with `if (DEBUG) {` statement, and can be branched accordingly.
If you want to switch server to "production" env, open file `.env` and change letter `d` to `p`, and save it. Now your server is in production env! :p
