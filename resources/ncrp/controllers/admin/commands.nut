// /**
//  * Ban player account for some time.    <-------------------- Currently not working properly
//  * @param  {uint}   cheaterID
//  * @param  {String} reason    Explonation why player is cheater
//  * @param  {Number} adminID   Pass -1 by default if send ban from console
//  * @param  {Number} banDays   Pass 0 for permanent ban
//  * @return {void}
//  */
// function banPlayerAccount( cheaterID, reason = "", adminID = -1, banDays = 1 ) {
//     local banTime = banDays * 86400;
//     return banPlayer( cheaterID, adminID, banTime, reason );
// }


// /**
//  * Ban player account for some time
//  * @param  {uint}   cheaterID
//  * @param  {String} reason    Explonation why player is cheater
//  * @param  {Number} adminID   Pass -1 by default if send ban from console
//  * @param  {Number} banDays   Pass 0 for permanent ban
//  * @return {void}
//  */
// function banPlayerSerial( cheaterID, reason = "", adminID = -1, banDays = 1 ) {
//     local banTime = banDays * 86400;
//     local serial = getPlayerSerial( cheaterID );
//     return banSerial( serial, adminID, banTime, reason);
// }

acmd("name", function(playerid, targetid) {
    if (isPlayerConnected(playerid)) {
        msg(playerid, "Info: " + getIdentity(targetid.tointeger()), CL_MEDIUMPURPLE);
    } else {
        msg(playerid, "Player is not connected", CL_MEDIUMPURPLE);
    }
});

acmd("list", function(playerid) {
    msg(playerid, "Current player list:", CL_MEDIUMPURPLE);
    foreach (pid, value in getPlayers()) {
        msg(playerid, "Info: " + getIdentity(pid));
    }
});

acmd(["admin", "adm", "a"], function(playerid, ...) {
    if(getPlayerName(playerid) == "Fernando_Fabbri"){
        return sendPlayerMessageToAll("Anonymous: " + concat(vargv), CL_MEDIUMPURPLE.r, CL_MEDIUMPURPLE.g, CL_MEDIUMPURPLE.b);
    }
    else{
        return sendPlayerMessageToAll("[A] "+getAccountName(playerid)+": " + concat(vargv), CL_MEDIUMPURPLE.r, CL_MEDIUMPURPLE.g, CL_MEDIUMPURPLE.b);
    }
});

key("o", function(playerid) {
    if (isPlayerAdmin(playerid)) {
        trigger(playerid, "onServerToggleBlip", "v");
    }
});

key("i", function(playerid) {
    if (isPlayerAdmin(playerid)) {
        trigger(playerid, "onServerToggleBlip", "p");
    }
});

// acmd(["admin", "adm", "a"], "kick", function(playerid, targetid, ...) {
//     local targetid = targetid.tointeger();
//     local reason = concat(vargv);
//     dbg(reason);
//     log( getAuthor(playerid) + "'s kick " + getAuthor(targetid) + " for: " + reason);
//     freezePlayer( targetid, true );
//     stopPlayerVehicle( targetid );
//     msg(targetid, format("You has been kicked for: %s", reason), CL_RED);
//     delayedFunction(5000, function () {
//         kickPlayer( targetid );
//     });
// });




// acmd(["admin", "adm", "a"], "ban", function(playerid, targetid, srok, type, ...) {
//     local targetid = targetid.tointeger();

//     local srok = srok.tointeger();
//     local time = null;
//         local srok_title = "";
//     if (type == null) {
//         time = srok * 60;
//     }

//     else if (type == "year" || type == "years") {
//         time = srok * 31104000; srok_title = "year";
//     }

//     else if (type == "month" || type == "months") {
//         time = srok * 2592000; srok_title = "month";
//     }

//     else if (type == "day" || type == "day") {
//         time = srok * 86400; srok_title = "day";
//     }

//     else if (type == "hour" || type == "hours") {
//         time = srok * 3600; srok_title = "hour";
//     }

//     else if (type == "minute" || type == "minutes" || type == "min" || type == "mins") {
//         time = srok * 60; srok_title = "minute";
//     }

//     if (srok > 1) { srok_title = srok_title+"s";  }

//     local reason = concat(vargv);
//         dbg(reason);
//     log( getAuthor(playerid) + "'s banned " + getAuthor(targetid) + " for " + srok + " "+srok_title+". Reason: " + reason);
//     freezePlayer( targetid, true );
//     stopPlayerVehicle( targetid );
//     msg(targetid, format("You has been banned for: %s", reason), CL_RED);

//     delayedFunction(5000, function () {
//         banPlayerSerial( targetid, reason, playerid, time );
//     });
// });

function planServerRestart(playerid) {
    msga("Auto-Restart: Server will be restart in 15 minutes. Please, complete all your jobs. Thanks!", CL_RED);

    delayedFunction(5*60*1000, function() {
        msga("Auto-Restart: Server will be restarted in 10 minutes.", CL_RED);
    });

    delayedFunction(10*60*1000, function() {
        msga("Auto-Restart: Server will be restarted in 5 minutes.", CL_RED);
    });

    delayedFunction(14*60*1000, function() {
        msga("Auto-Restart: Server will be restarted in 1 minute.", CL_RED);
    });

    delayedFunction(15*60*1000, function() {
        msga("Auto-Restart: Server will be restarted in 5 seconds. See you soon ;)", CL_RED);

        delayedFunction(5000, function() {
            msga("Auto-Restart: Restarting now!", CL_RED);

            // kick all dawgs
            foreach (idx, value in getPlayers()) {
                if (isPlayerLoaded(idx)) {
                    players[idx].save();
                }

                kickPlayer(idx);
            }

            // request restart
            dbg("server", "restart", "requested");
        });
    });
}

acmd("restart", planServerRestart);
