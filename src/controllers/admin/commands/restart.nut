local isRestarting = false;
local isRestartPlanned = false;
local isRestartWhenNoOnline = false;

function isRestartPlanned() {
    return isRestartPlanned;
}

// Приёмник данных из ноды
nnListen(function(sourceData) {
    local data = JSONParser.parse(sourceData);

    if(data.type == "server" && data.action == "plan-restart" ) {
        planServerRestart(-1);
        dbg("server", "planServerRestart called, success");
    }
});

event("native:onPlayerConnect", function(playerid, name, ip, serial) {
    if(isRestarting) kickPlayer( playerid );
});

event("native:onPlayerDisconnect", function(playerid, reason) {
    if(isRestartWhenNoOnline) {
      delayedFunction(1000, function() {
        if(getPlayerCount() == 0) {
          isRestarting = true;

          kickAll();

          delayedFunction(1000, function() {
              // request restart
              dbg("server", "restart", "requested");
          });
        }
      });
    }
});

function planServerRestart(playerid) {
    isRestartPlanned = true;
    msga("autorestart.15min", [], CL_RED);
    dbg("server", "autorestart 15min");

    delayedFunction(5*60*1000, function() {
        msga("autorestart.10min", [], CL_RED);
        dbg("server", "autorestart 10min");
    });

    delayedFunction(10*60*1000, function() {
        msga("autorestart.5min", [], CL_RED);
        dbg("server", "autorestart 5min");
    });

    delayedFunction(14*60*1000, function() {
        msga("autorestart.1min", [], CL_RED);
        dbg("server", "autorestart 1min");
    });

    delayedFunction(14*60*1000+30000, function() {
        msga("autorestart.30sec", [], CL_RED);
        dbg("server", "autorestart 30sec");
    });

    delayedFunction(15*60*1000, function() {
        msga("autorestart.3sec", [], CL_RED);
        dbg("server", "autorestart 3sec");

        // kick all
        kickAll();

        isRestarting = true;

        delayedFunction(4000, function() {

            trigger("native:onServerShutdown");

            msga("autorestart.now", [], CL_RED);

            delayedFunction(1000, function() {
                // request restart
                nano({
                    "path": "server",
                    "type": "restart",
                    "action": "request",
                });
                dbg("server", "autorestart now, send nanomsg to node");
            });
        });
    });
}

function planFastServerRestart(playerid) {
    msga("autorestart.1min", [], CL_RED);
    dbg("server", "autorestart 1min");

    delayedFunction(30*1000, function() {
        msga("autorestart.30sec", [], CL_RED);
        dbg("server", "autorestart 30sec");
    });

    delayedFunction(57*1000, function() {
        msga("autorestart.3sec", [], CL_RED);
        dbg("server", "autorestart 3sec");

        // kick all
        kickAll();

        isRestarting = true;

        delayedFunction(4000, function() {

            trigger("native:onServerShutdown");
            msga("autorestart.now", [], CL_RED);

            delayedFunction(1000, function() {
                // request restart
                dbg("server", "restart", "requested");
                dbg("server", "^^^ maybe its not work");
            });
        });
    });
}

function planNowServerRestart(playerid) {
    msga("autorestart.3sec", [], CL_RED);
    dbg("server", "autorestart 3sec");

    delayedFunction(300, function() {
        // kick all
        kickAll();

        isRestarting = true;

        delayedFunction(4000, function() {

            trigger("native:onServerShutdown");

            msga("autorestart.now", [], CL_RED);

            delayedFunction(1000, function() {
                // request restart
                dbg("server", "restart", "requested");
                dbg("server", "^^^ maybe its not work");
            });
        });
    });
}

function planZeroServerRestart(playerid) {
    isRestartWhenNoOnline = true;
    msg(playerid, "Restart (when online will be 0) has been planned.")
}

alternativeTranslate({
    "en|autorestart.15min"  : "[AUTO-RESTART] Server will be restarted in 15 minutes. Please, complete all your jobs. Thanks!"
    "ru|autorestart.15min"  : "[АВТО-РЕСТАРТ] Сервер будет перезагружен через 15 минут. Пожалуйста, завершите все свои задания. Спасибо!"
    "en|autorestart.10min"  : "[AUTO-RESTART] Server will be restarted in 10 minutes. Please, complete all your jobs. Thanks!"
    "ru|autorestart.10min"  : "[АВТО-РЕСТАРТ] Сервер будет перезагружен через 10 минут. Пожалуйста, завершите все свои задания. Спасибо!"
    "en|autorestart.5min"   : "[AUTO-RESTART] Server will be restarted in 5 minutes."
    "ru|autorestart.5min"   : "[АВТО-РЕСТАРТ] Сервер будет перезагружен через 5 минут."
    "en|autorestart.1min"   : "[AUTO-RESTART] Server will be restarted in 1 minute."
    "ru|autorestart.1min"   : "[АВТО-РЕСТАРТ] Сервер будет перезагружен через 1 минуту."
    "en|autorestart.30sec"  : "[AUTO-RESTART] Server will be restarted in 30 seconds. Please, disconnect!"
    "ru|autorestart.30sec"  : "[АВТО-РЕСТАРТ] Сервер будет перезагружен через 30 секунд. Пожалуйста, отключитесь от сервера!"
    "en|autorestart.3sec"   : "[AUTO-RESTART] Server will be restarted in 3 seconds. See you soon ;)"
    "ru|autorestart.3sec"   : "[АВТО-РЕСТАРТ] Сервер будет перезагружен через 3 секунды. До скорой встречи ;)"
    "en|autorestart.now"    : "[AUTO-RESTART] Restarting now!"
    "ru|autorestart.now"    : "[AВТО-РЕСТАРТ] Поехали!"
});


mcmd(["admin.restart"], "restart", planServerRestart);
mcmd(["admin.restart"], "fastrestart", planFastServerRestart);
mcmd(["admin.restart"], "nowrestart", planNowServerRestart);
mcmd(["admin.restart"], "zerorestart", planZeroServerRestart);
