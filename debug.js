'use strict';

const fs        = require('fs');
const spawn     = require('child_process').spawn;
const path      = require('path');
const chokidar  = require('chokidar')

fs.readFile('.env', function(err, data) {
    if (err) return console.error(err);
    if (data == 'p') return console.log("YOU SHOULD NOT run debug.js for product env! Exiting...");
    if (process.platform != "win32" && process.platform != "darwin") return console.log("You are trying to run debug on platform other then win32 or macos!");

    main();
});

function startServer() {
    let server = spawn(path.join(__dirname, "m2online-svr.exe"));

    server.on('error', (err) => {
        return console.error(err);
    });

    // on data (logs)
    server.stdout.on('data', (data) => {
        console.log(data.toString().trim());
    });

    // on error (logs)
    server.stderr.on('data', (data) => {
        console.log(data.toString().trim());
    });

    return server;
}

var walk = function(directoryName, callback) {
    fs.readdir(directoryName, function(e, files) {
        if (e) {
            console.log('Error: ', e);
            return;
        }
        files.forEach(function(file) {
            var fullPath = path.join(directoryName,file);
            fs.stat(fullPath, function(e, f) {
                if (e) {
                    console.log('Error: ', e);
                    return;
                }
                if (f.isDirectory()) {
                    walk(fullPath, callback);
                } else {
                    callback(fullPath);
                }
            });
        });
    });
};

function main() {
    console.log("starting debug mode for ncrp ...");

    let m2o = startServer();

    var stdin = process.stdin;

    // without this, we would only get streams once enter is pressed
    stdin.setRawMode( false );

    // resume stdin in the parent process (node app won't quit all by itself
    // unless an error or process.exit() happens)
    stdin.resume();

    // i don't want binary, do you?
    stdin.setEncoding( 'utf8' );

    // on any data into stdin
    stdin.on( 'data', function( data ){
        // // ctrl-c ( end of text )
        if ( key === '\u0003' ) {
            process.exit();
        }
        // write the key to stdout all normal like
        try {
            // if (m2o.stdin.writable) {

            m2o.stdin.write(data.trim() + "\n");

        } catch (e) {
            console.error("error writing to stream (try restarting debug.js). " + e.message);
        }
    });

    // let handler = function(filename) {
    //     console.log('chnaged', filename);

    //     if (filename && (filename.endsWith(".nut") || filename.endsWith(".xml"))) {
    //         console.log(">> saved file " + filename);
    //         console.log(">> restarting server due changes");
    //         m2o.write("exit\n");
    //         setTimeout(startServer, 1000);
    //     }
    // };

    // walk('./resources/ncrp', function(filename) {
    //     if (filename && filename.endsWith(".nut") || filename.endsWith(".xml")) {
    //         console.log('regiserting watch on', filename)
    //         fs.watch(filename, handler);
    //     }
    // })

    // watch(path.join(__dirname, 'resources', 'ncrp'), handler);
    chokidar.watch(path.join(__dirname, 'resources', 'ncrp')).on('change', (path, event) => {
        if (path && (path.indexOf(".nut") !== -1 || path.indexOf(".xml") !== -1)) {
            console.log(">> saved file " + path);
            console.log(">> restarting server due changes");
            m2o.stdin.write("exit\n");
            setTimeout(function() {
                m2o = startServer();
            }, 500);
        }
    });
}
