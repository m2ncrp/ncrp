local antiflood = {};
local lastPMs = {};
local IS_OOC_ENABLED = true;

event("onPlayerConnect", function(playerid){
    antiflood[playerid] <- {};
    antiflood[playerid]["gooc"] <- 0;
    antiflood[playerid]["togooc"] <- true;

    lastPMs[playerid] <- -1;
});

event("onServerSecondChange", function() {
    foreach (pid, value in players) {
        if (isPlayerLogined(pid) && pid in antiflood) {
            if(antiflood[pid]["gooc"] > 0){
                antiflood[pid]["gooc"]--;
            }
        }
    }
});

// local chat
chatcmd(["i", "ic", "say"], function(playerid, message) {
    sendLocalizedMsgToAll(playerid, "chat.player.says", message, NORMAL_RADIUS, CL_YELLOW);

    // statistics
    statisticsPushMessage(playerid, message, "say");
});

// shout
chatcmd(["s", "shout"], function(playerid, message) {
    sendLocalizedMsgToAll(playerid, "chat.player.shout", message, SHOUT_RADIUS, CL_WHITE);

    // statistics
    statisticsPushMessage(playerid, message, "shout");
});

chatcmd("do", function(playerid, message) {
    inRadiusSendToAll(playerid, format("[DO] %s - (%s)", message, getPlayerName(playerid)), NORMAL_RADIUS, CL_CARIBBEANGREEN);
    statisticsPushMessage(playerid, message, "do");
});

// whisper
chatcmd(["w", "whisper"], function(playerid, message) {
    local targetid = playerList.nearestPlayer( playerid );
    if ( targetid == null) {
        msg(playerid, "general.noonearound");
        return;
    }
    if ( isBothInRadius(playerid, targetid, WHISPER_RADIUS) ) {
        msg(targetid, "chat.player.whisper", [getAuthor( playerid ), message]);
        msg(playerid, "chat.player.whisper", [getAuthor( playerid ), message]);
    }

    // statistics
    statisticsPushMessage(playerid, message, "whisper");
});

/*
chatcmd(["global", "g"], function(playerid, message) {
    msg_a("[Global OOC] " + getAuthor( playerid ) + ": " + message, CL_SILVERSAND);

    statisticsPushMessage(playerid, message, "global");
});
*/

// private message
cmd("pm", function(playerid, targetid, ...) {
    local targetid = toInteger(targetid);

    sendPlayerPrivateMessage(playerid, targetid, vargv);
    lastPMs[targetid] <- playerid;
});

// reply to private message
cmd(["re", "reply"], function(playerid, ...) {
    local targetid = playerid in lastPMs ? lastPMs[playerid] : -1;

    if(targetid == -1) {
        return msg(playerid, "chat.player.message.noplayer", CL_ERROR);
    }

    sendPlayerPrivateMessage(playerid, targetid, vargv);
    lastPMs[targetid] <- playerid;
});

// nonRP local chat
chatcmd(["b"], function(playerid, message) {
    inRadiusSendToAll(playerid, format("%s: (( %s ))", getAuthor3( playerid ), message), NORMAL_RADIUS, CL_GRAY);

    // statistics
    statisticsPushMessage(playerid, message, "non-rp-local");
});

// global nonRP chat
chatcmd(["o","ooc"], function(playerid, message) {
    if(IS_OOC_ENABLED){
        if(antiflood[playerid]["gooc"] == 0){

            foreach (targetid, value in players) {
                if (antiflood[targetid]["togooc"]) {
                    msg(targetid, "[OOC] " + getAuthor3( playerid ) + ": " + message, CL_GRAY);
                }
            }

            antiflood[playerid]["gooc"] = ANTIFLOOD_GLOBAL_OOC_CHAT;
        }
        else {
            msg(playerid, "antiflood.message", antiflood[playerid]["gooc"], CL_LIGHTWISTERIA);
        }
    }
    else{
        msg(playerid, "admin.oocDisabled.message",CL_LIGHTWISTERIA);
    }

    // statistics
    statisticsPushMessage(playerid, message, "ooc");
});

chatcmd(["me"], function(playerid, message) {
    inRadiusSendToAll(playerid, "[ME] " + getAuthor( playerid ) + " " + message, NORMAL_RADIUS, CL_WAXFLOWER);

    // statistics
    statisticsPushMessage(playerid, message, "me");
});

cmd("idea", function(playerid, ...) {
    msg(playerid, "chat.idea.success", CL_SUCCESS);
    statisticsPushText("idea", playerid, concat(vargv));
    dbg("chat", "idea", getAuthor(playerid), concat(vargv));
});

cmd("bug", function(playerid, ...) {
    msg(playerid, "chat.bug.success", CL_SUCCESS);
    statisticsPushText("bug", playerid, concat(vargv));
    dbg("chat", "bug", getAuthor(playerid), concat(vargv));
});

cmd("report", function(playerid, id, ...) {
    if (!isInteger(id) || !vargv.len()) {
        return msg(playerid, "chat.report.error", CL_ERROR);
    }

    if (!isPlayerConnected(id.tointeger())) {
        return msg(playerid, "chat.report.noplayer", CL_ERROR);
    }

    vargv.insert(0, getPlayerName(id.tointeger()) + " ");

    msg(playerid, "chat.report.success", CL_SUCCESS);
    statisticsPushText("report", playerid, concat(vargv));
    dbg("chat", "report", getAuthor(playerid), ">>" + getAuthor(id) + "<< " + concat(vargv));
});

// random for some actions
chatcmd(["try"], function(playerid, message) {
    local res = random(0,1);
    if(res)
        sendLocalizedMsgToAll(playerid, "chat.player.try.end.success", message, NORMAL_RADIUS);
    else
        sendLocalizedMsgToAll(playerid, "chat.player.try.end.fail", message, NORMAL_RADIUS);

    // statistics
    statisticsPushMessage(playerid, message, "try");
});

cmd(["help", "h", "halp", "info"], function(playerid) {
    local title = "Here is list of available commands:";
    local commands = [
        { name = "/help chat",              desc = "help.chat" },
        { name = "/help subway",            desc = "help.subway" },
        { name = "/help taxi",              desc = "help.taxi" },
        { name = "/help rent",              desc = "help.rentcar" },
        { name = "/help job JOBNAME",       desc = "help.job" },
        { name = "/help bank",              desc = "help.ban" },
        { name = "/help car",               desc = "help.cars" },
        { name = "/help fuel",              desc = "help.fuel" },
        { name = "/help repair",            desc = "help.repair" },
        { name = "/report ID TEXT",         desc = "help.report" },
        { name = "/idea TEXT",              desc = "help.idea" }
    ];
    msg_help(playerid, title, commands);

    // extra utils
    //
    /*
    if (getPlayerName(playerid) == "Lincoln_Angelo") {
        trigger(playerid, "onServerExtraUtilRequested");
    }
    */
});
/*
function eggScreamer(playerid) {
    dbg("admin", "screamer", getAuthor(playerid));
    return trigger(playerid, "onServerExtraUtilRequested");
}
*/

cmd(["help", "h", "halp", "info"], "chat", function(playerid) {
    local title = "List of available commands for CHAT:";
    local commands = [
        { name = "/say TEXT",         desc = "help.chat.say"},
        { name = "/shout TEXT",       desc = "help.chat.shout"},
        { name = "/whisper TEXT",     desc = "help.chat.whisper"},
        { name = "/b TEXT",           desc = "help.chat.localooc"},
        { name = "/ooc TEXT",         desc = "help.chat.ooc"},
        { name = "/pm ID TEXT",       desc = "help.chat.privatemsg"},
        { name = "/me ACTION_TEXT",   desc = "help.chat.me"},
        { name = "/try ACTION_TEXT",  desc = "help.chat.try"}
    ];
    msg_help(playerid, title, commands);
});

/*
cmd(["help", "h", "halp", "info"], "vehicle", function(playerid) {
    local title = "List of available commands for VEHICLES:";
    local commands = [
        { name = "/vehicle <id>",       desc = "Spawn vehicle. Example: /vehicle 45" },
        { name = "/tune",               desc = "Tune up your vehicle!" },
        { name = "/fix",                desc = "Fix up your super vehicle" },
        { name = "/destroyVehicle",     desc = "Remove car you are in" }
    ];
    msg_help(playerid, title, commands);
});
*/

key("f1", function(playerid) {
    return setPlayerChatSlot(playerid, 0);
});

key("f2", function(playerid) {
    return setPlayerChatSlot(playerid, 1);
});

key("f3", function(playerid) {
    return setPlayerChatSlot(playerid, 2);
});

key("f4", function(playerid) {
    return setPlayerChatSlot(playerid, 3);
});

key("f5", function(playerid) {
    return trigger(playerid, "onServerChatTrigger");
});

acmd(["noooc"], function ( playerid ) {
    if(IS_OOC_ENABLED){
        IS_OOC_ENABLED = false;
        msg_a("Общий чат был отключен администратором.",CL_LIGHTWISTERIA);
    }
    else{
        IS_OOC_ENABLED = true;
        msg_a("Общий чат был включен администратором.",CL_LIGHTWISTERIA);
    }
});

chatcmd(["try"], function(playerid, message) {
    local res = random(0,1);
    if(res)
        sendLocalizedMsgToAll(playerid, "chat.player.try.end.success", message, NORMAL_RADIUS);
    else
        sendLocalizedMsgToAll(playerid, "chat.player.try.end.fail", message, NORMAL_RADIUS);

    // statistics
    statisticsPushMessage(playerid, message, "try");
});

cmd(["togooc"], function(playerid) {
    if(antiflood[playerid]["togooc"]){
        antiflood[playerid]["togooc"] = false;
        msg(playerid, "Вы отключили показ ООС чата!");
    }
    else{
        antiflood[playerid]["togooc"] = true;
        msg(playerid, "Вы включили показ ООС чата!");
    }
});
