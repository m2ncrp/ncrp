const Discord   = require('discord.js');
const spawn     = require('child_process').spawn;
const path      = require('path');

// const express = require('express');
// const app     = express();

const bot = new Discord.Client();

// the token of your bot - https://discordapp.com/developers/applications/me
const token = 'MjYxNDcwMDcxNTY0NTMzNzYx.Cz1Y6g.WGYSbl5vCRjJQQUvVq6ns2PUDdE';
const AUTORESTART_TIME = 5000;

let restarts = [
    [05, 45],
    [11, 45],
    [17, 45],
    [23, 45],
];

let settings = {
    // player chats
    ooc_ru: "219565308007022592", // general-ru
    ooc_en: "260713962402742273", // general-en
    police: "260470624428752896", // police
    ooc:    "263939471614017546", // gamechat

    // stream for all logs
    console: "256102201187893248", // console
    nofitication: "254996128074825738", // dev-notfications

    // valid admin output chats
    output: [
        "219673733638389760", // dev-russian
        "220460332827672576", // dev-talks
        "256102201187893248", // console
    ]
};

let roles = {
    admin: "Administrators",
};

let started = false;
let ready = false;
let channels = [];

// the ready event is vital, it means that your bot will only start reacting to information
// from Discord _after_ ready is emitted.
bot.on('ready', () => {
    console.log('>> started Discord bot.');
    for (channel of bot.channels) {
        if (channel[1].type != "text") continue;

        // push text channels
        channels[channel[0].toString()] = channel[1];
    }

    ready = true;
});

function checkAutorestart() {
    var date = new Date();

    for (var i = restarts.length - 1; i >= 0; i--) {
        if (restarts[i][0] == date.getHours() && restarts[i][1] == date.getMinutes()) {
            if (m2o && m2o.stdin.writable) {
                m2o.stdin.write("sq planServerRestart(-1)\n");
                restarts = [];
            } else {
                console.log(">> tried to restart server, got non-writable stream");
            }
        }
    }
}

let m2o = startServer();

function startServer() {
    let server;
    let errorlog = [];
    started = true;

    let ticker = setInterval(function() {
        checkAutorestart();
        if (!errorlog || !errorlog.length) return;
        channels[settings.console].sendMessage("@everyone ERROR: " + errorlog.join("\n"));
        errorlog = [];
    }, 5000);

    if (process.platform == "darwin") {
        // do noting
    } else if (process.platform == "win32") {
        server = spawn(path.join(__dirname, "m2online-svr.exe"));
    } else {
        server = spawn("/usr/bin/wine", [path.join(__dirname, "m2online-svr.exe")]);
    }

    server.on('error', (err) => {
        return console.error(err);
    });

    // on data (logs)
    server.stdout.on('data', (data) => {
        data = data.toString().trim();

        console.log(data);

        if (data.indexOf("Script Error") != -1) {
            errorlog.push(data);
        }

        if (!ready) return;

        data = data.toString().slice(11).trim();
        if (!data.startsWith("[debug]")) return;
        data = data.slice(8).trim();

        // send message to log
        channels[settings.console].sendMessage(data);

        try {
            data = JSON.parse(data);
            if (!data || !data.length) return;

            let key = data[0];

            if (key == "chat") {
                if (data[1] == "global") {
                    data[1] = "ooc_en";
                }

                if (["idea", "report", "bug"].indexOf(data[1]) != -1) {
                    return channels[settings.nofitication].sendMessage(`New ${data[1]}:\n**${data[2]}**: ${data[3]}`);
                }

                // ooc/police chats
                if (settings.hasOwnProperty(data[1])) {
                    return channels[settings[data[1]]].sendMessage("**" + data[2] + "**" + ": " + data[3]);
                }

                return;
            }

            if (key == "server") {
                console.log(">> server", data[1]);
                channels[settings.console].sendMessage(data[1]);

                if (data[1] == "restart" && data[2] == "requested") {
                    try {
                        m2o.stdin.write("exit\n");
                        setTimeout(function() {
                            m2o = startServer();
                        }, AUTORESTART_TIME);
                    } catch (e) {
                        return channels[settings.nofitication].sendMessage("@everyone Could not write to sdtin for server restarting! Error: " + e.message);
                    }
                }

                return;
            }

            if (key == "admin") {
                let action = data[1];

                if (action == "list") {
                    if (!data[2]) return;

                    let cnt = 0;
                    let list = "**List of current players **:\n---------------------\n";
                    for (a in data[2]) {
                        list += " " + data[2][a] + " with id #" + a + "\n";
                        cnt++;
                    }

                    console.log("Total: " + cnt + " players.");

                    return channels[settings.console].sendMessage(list.trim());
                }

                console.log(data);

                if (action == "banned") {
                    return channels[settings.console].sendMessage(`banned ${data[2]} on ${data[3]} for ${data[4]}`);
                }

                if (action == "kicked") {
                    return channels[settings.console].sendMessage(`kicked ${data[2]} for ${data[3]}`);
                }

                if (action == "muted") {
                    return channels[settings.console].sendMessage(`muted ${data[2]} for ${data[3]}`);
                }

                if (action == "unmuted") {
                    return channels[settings.console].sendMessage(`unmuted ${data[2]}`);
                }

                if (action == "unban") {
                    return channels[settings.console].sendMessage(`unbanned ${data[2]}`);
                }

                if (action == "banlist") {
                    return channels[settings.console].sendMessage("current bans: " + data[2]);
                }
            }
        }
        catch (e) {
            console.log(">> could not parse debug expression: " + data);
            console.log(e.message);
        }
    });

    // on error (logs)
    server.stderr.on('data', (data) => {
        console.log(data.toString().trim());
        if (!ready) {
            return 0;
            // setTimeout(function() {
            //     arguments.callee(data); // call itself in 5 seconds
            // }, 5000);
        };

        // send message
        channels[settings.console].sendMessage(data.toString().trim());
    });

    // on finish (code 0 - success, other - error)
    server.on('close', (code) => {
        console.log("exited with code:", code);

        if (code != 0) {
             channels[settings.console].sendMessage("@everyone server has crashed, auto-restarting!");

            setTimeout(function() {
                m2o = startServer();
            }, AUTORESTART_TIME);
        }

        started = false;
        clearInterval(ticker);
    });

    return server;
}

// create an event listener for messages
bot.on('message', msg => {
    // Set the prefix
    let prefix = "/";

    // Exit and stop if it's not there
    if(!msg.content.startsWith(prefix)) return;

    // Exit if any bot
    if (msg.author.bot) return;
    // exit if not in guild
    if (!msg.member) return;

    if (msg.content.startsWith(prefix + "ping")) {
        msg.channel.sendMessage("pong!");
    }

    // if (msg.content.startsWith(prefix + "ooc")) {
    //     console.log("sending ooc message", msg.content.slice(4).trim());
    // }

    // ADMIN COMMANDS

    // delete command if not admin
    if (msg.member.highestRole.name != roles.admin) {
        return msg.delete();
    }

    // delete command if wrong chnannel
    if (settings.output.indexOf(msg.channel.id) == -1) {
        return msg.delete();
    }

    if (msg.channel.id !== settings.console) {
        msg.reply("check output in #dev-nofications or #randomshiet");
    }

    try {

        if (!m2o) {
            return msg.reply("m2o not loaded!");
        }

        if (!m2o.stdin.writable) {
            console.log(">>", "m2o stdin not writable!");
            return msg.reply("@everyone ALERT! m2o stdin stream not writable");
        }

        // Usage: /list
        if (msg.content.startsWith(prefix + "list")) {
            console.log(">>", msg.member.user.username, "reqeusted", "list");
            return m2o.stdin.write("list\n");
        }

        // Usage: /adm Hello everyone!
        if (msg.content.startsWith(prefix + "adm")) {
            let content = msg.content.slice(4).trim();
            console.log(">>", msg.member.user.username, "reqeusted", "adm", content);
            return m2o.stdin.write("adm " + content + "\n");
        }

        // Usage: /pm id Hello mate!
        if (msg.content.startsWith(prefix + "pm")) {
            let content = msg.content.slice(4).trim().split(' ');
            console.log(">>", msg.member.user.username, "reqeusted", "pm", content);
            return m2o.stdin.write("sq msg(" + content.shift() + ",\"[ADMIN][PM] " + content.join(' ') + "\", CL_RED)\n");
        }

        // Usage: /sq getPlayerMoney(0)
        if (msg.content.startsWith(prefix + "sq")) {
            let content = msg.content.slice(3).trim();
            console.log(">>", msg.member.user.username, "reqeusted", "sq", content);
            return m2o.stdin.write("sq " + content + "\n");
        }

        // Usage: /restart
        if (msg.content.startsWith(prefix + "restart")) {
            console.log(">>", msg.member.user.username, "reqeusted", "restart");
            m2o.stdin.write("exit\n");
            setTimeout(function() {
                m2o = startServer();
            }, AUTORESTART_TIME);
            return;
        }

        // Usage: /stop
        if (msg.content.startsWith(prefix + "stop")) {
            console.log(">>", msg.member.user.username, "reqeusted", "stop");
            if (!started) {
                return msg.reply("the server is not started!");
            }

            m2o.stdin.write("exit\n");
            return;
        }

        // Usage: /start
        if (msg.content.startsWith(prefix + "start")) {
            console.log(">>", msg.member.user.username, "reqeusted", "start");
            if (started) {
                return msg.reply("the server is already started!");
            }

            m2o = startServer();
            return;
        }

        let controls = ["ban", "kick", "mute", "unmute", "banlist", "unban"];
        for (ctrl of controls) {
            if (!msg.content.startsWith(prefix + ctrl)) continue;
            let content = msg.content.slice(1).trim();
            console.log(">>", msg.member.user.username, "reqeusted", "admin", content);
            return m2o.stdin.write("admin " + content + "\n");
        }
    } catch (e) {
        msg.reply("@everyone ALERT! Exception writing to m2o stdin " + e.message);
        console.log(">>", "cannot write to stdin", e.message);
    }
});

bot.login(token);

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
    if ( data === '\u0003' ) {
        process.exit();
    }
    // write the key to stdout all normal like
    try {
        // if (m2o.stdin.writable) {

        m2o.stdin.write(data.trim() + "\n");

    } catch (e) {
        console.error(">>error writing to stream (try restarting debug.js). " + e.message);
    }
});

process.on('exit', function () {
    //handle your on exit code
    console.log(">>Exiting, have a nice day");
    m2o.stdin.write("exit\n");
});

