local antiflood = {};
local lastPMs = {};
local IS_OOC_ENABLED = true;

event("onPlayerConnect", function(playerid){
    antiflood[playerid] <- {};
    antiflood[playerid]["gooc"] <- 0;

    lastPMs[playerid] <- -1;

});

event("onServerPlayerStarted", function( playerid ){

    local account = getAccount(playerid);

    antiflood[playerid]["togooc"] <- true;
    antiflood[playerid]["togpm"] <- true;

    if (account.hasData("showOOC")) {
        local showOOC = account.getData("showOOC");
        antiflood[playerid]["togooc"] = showOOC;
        if (showOOC == false) {
            msg(playerid, "chat.togoocDisabledAlready", CL_WHITE);
        }
    }

    if (account.hasData("showPM")) {
        local showPM = account.getData("showPM");
        antiflood[playerid]["togpm"] = showPM;
        if (showPM == false) {
            msg(playerid, "chat.togpmDisabledAlready", CL_WHITE);
        }
    }

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
    sendLocalizedMsgToAll(playerid, "chat.player.says", [getPlayerName(playerid), message], NORMAL_RADIUS, CL_CHAT_IC);

    // statistics
    statisticsPushMessage(playerid, message, "say");
});

// shout
chatcmd(["s", "shout"], function(playerid, message) {
    sendLocalizedMsgToAll(playerid, "chat.player.shout", [getPlayerName(playerid), message], SHOUT_RADIUS, CL_CHAT_SHOUT);

    // statistics
    statisticsPushMessage(playerid, message, "shout");
});

chatcmd(["me"], function(playerid, message) {
    inRadiusSendToAll(playerid, "[ME] " + getPlayerName(playerid) + " " + message, NORMAL_RADIUS, CL_CHAT_ME);

    // statistics
    statisticsPushMessage(playerid, message, "me");
});

chatcmd("do", function(playerid, message) {
    inRadiusSendToAll(playerid, format("[DO] %s (%s)", message, getPlayerName(playerid)), NORMAL_RADIUS, CL_CHAT_DO);
    statisticsPushMessage(playerid, message, "do");
});


chatcmd("todo", function(playerid, message) {

    local lang = getPlayerLocale(playerid);
    if(lang == "ru") {
        message = str_replace_ex("!я", getPlayerName(playerid), message);
    } else {
        message = str_replace_ex("!me", getPlayerName(playerid), message);
    }

    local match = regexp(@"(.*)(\*)(.*)$").capture(message);

    if(match == null) {
        msg(playerid, "chat.player.todo.badformat1", CL_ERROR);
        return msg(playerid, "chat.player.todo.badformat2");
    }

    local messageBefore = strip(message.slice(match[1].begin, match[1].end));
    local messageAfter = strip(message.slice(match[3].begin, match[3].end));

    sendLocalizedMsgToAll(playerid, "chat.player.says", [getPlayerName(playerid), messageBefore], NORMAL_RADIUS, CL_CHAT_IC);
    inRadiusSendToAll(playerid, "[ME] " + messageAfter, NORMAL_RADIUS, CL_CHAT_ME);

    statisticsPushMessage(playerid, message, "todo");
});


// whisper
chatcmd(["w", "whisper"], function(playerid, message) {
    local targetid = playerList.nearestPlayer( playerid );
    if ( targetid == null) {
        msg(playerid, "general.noonearound");
        return;
    }
    if ( isBothInRadius(playerid, targetid, WHISPER_RADIUS) ) {
        msg(targetid, "chat.player.whisper", [getAuthor( playerid ), message], CL_CHAT_WHISPER);
        msg(playerid, "chat.player.whisper", [getAuthor( playerid ), message], CL_CHAT_WHISPER);
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

    if(!antiflood[targetid]["togpm"]){
        return  msg(playerid, "chat.playerTogPm", CL_ERROR);
    }

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
    inRadiusSendToAll(playerid, format("%s: %s", getAuthor( playerid ), message), NORMAL_RADIUS, CL_CHAT_B);

    // statistics
    statisticsPushMessage(playerid, message, "non-rp-local");
});

// global nonRP chat
chatcmd(["o","ooc"], function(playerid, message) {

    // is global chat enabled and user writing this message
    // did not disable his global chat
    if (IS_OOC_ENABLED && antiflood[playerid]["togooc"])
    {
        // matybe he has some time to be antiflooded yet
        if(antiflood[playerid]["gooc"] == 0)
        {
            // send message to all enabled chat
            foreach (targetid, value in players) {
                if (antiflood[targetid]["togooc"]) {
                    msg(targetid, "[Global OOC] " + getAuthor( playerid ) + ": " + message, CL_CHAT_OOC);
                }
            }

            // statistics
            statisticsPushMessage(playerid, message, "ooc_");
            antiflood[playerid]["gooc"] = ANTIFLOOD_GLOBAL_OOC_CHAT;
        }
        else {
            msg(playerid, "antiflood.message", antiflood[playerid]["gooc"], CL_CHAT_B);
        }
    }
    else {
        // msg(playerid, "admin.oocDisabled.message",CL_CHAT_B);
        // forward to /b
        inRadiusSendToAll(playerid, format("[Local nonRP] %s: (( %s ))", getAuthor( playerid ), message), NORMAL_RADIUS, CL_CHAT_B);

        // statistics
        statisticsPushMessage(playerid, message, "non-rp-local");
    }

});


cmd(["text"], function(playerid, r, g, b) {
    msg(playerid, "Тестовое сообщение - Test message - 987654321", rgb(r.tointeger(), g.tointeger(), b.tointeger()));
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

cmd(["help", "h", "halp", "info"], function(playerid) {
    local title = "Here is list of available commands:";
    local commands = [
        { name = "/help chat",              desc = "help.chat" },
        { name = "/help subway",            desc = "help.subway" },
     // { name = "/help taxi",              desc = "help.taxi" },
        { name = "/help rent",              desc = "help.rentcar" },
        { name = "/help job JOBNAME",       desc = "help.job" },
        { name = "/help bank",              desc = "help.ban" },
        { name = "/help car",               desc = "help.cars" },
    //  { name = "/report ID TEXT",         desc = "help.report" },
    //  { name = "/idea TEXT",              desc = "help.idea" }
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
        { name = "/ic text",     desc = "help.chat.say"},
        { name = "/s text",      desc = "help.chat.shout"},
        { name = "/w text",      desc = "help.chat.whisper"},
        { name = "/b text",      desc = "help.chat.localooc"},
        { name = "/ooc text",    desc = "help.chat.ooc"},
        { name = "/pm id text",  desc = "help.chat.privatemsg"},
        { name = "/me text",     desc = "help.chat.me"},
        { name = "/try text",    desc = "help.chat.try"}
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

//key("f4", function(playerid) {
//    return setPlayerChatSlot(playerid, 3);
//});

key("f5", function(playerid) {
    return trigger(playerid, "onServerChatTrigger");
});

acmd(["noooc"], function ( playerid ) {
    if(IS_OOC_ENABLED){
        IS_OOC_ENABLED = false;
        msg_a("admin.oocDisabled.message", CL_LIGHTWISTERIA);
    }
    else{
        IS_OOC_ENABLED = true;
        msg_a("admin.oocEnabled.message", CL_LIGHTWISTERIA);
    }
});

chatcmd(["try"], function(playerid, message) {
    local res = random(0,1);
    if(res)
        sendLocalizedMsgToAll(playerid, "chat.player.try.end.success", [getPlayerName(playerid), message], SHOUT_RADIUS, CL_CHAT_TRY_SUCCESS);
    else
        sendLocalizedMsgToAll(playerid, "chat.player.try.end.fail", [getPlayerName(playerid), message], SHOUT_RADIUS, CL_CHAT_TRY_FAILED);

    // statistics
    statisticsPushMessage(playerid, message, "try");
});

cmd(["togooc"], function(playerid) {

    local account = getAccount(playerid);

    if(antiflood[playerid]["togooc"]){
        antiflood[playerid]["togooc"] = false;
        account.setData("showOOC", false);
        msg(playerid, "chat.togoocDisabled");
    }
    else{
        antiflood[playerid]["togooc"] = true;
        account.setData("showOOC", true);
        msg(playerid, "chat.togoocEnabled");
    }
    account.save();
});


cmd(["togpm"], function(playerid) {

    local account = getAccount(playerid);

    if(antiflood[playerid]["togpm"]){
        antiflood[playerid]["togpm"] = false;
        account.setData("showPM", false);
        msg(playerid, "chat.togpmDisabled");
    }
    else{
        antiflood[playerid]["togpm"] = true;
        account.setData("showPM", true);
        msg(playerid, "chat.togpmEnabled");
    }
    account.save();
});


function getPlayerOOC(playerid) {
    return antiflood[playerid]["togooc"];
}

function setPlayerOOC(playerid, value = true) {
    antiflood[playerid]["togooc"] = value;
}

function isPlayerOOCEnabled(playerid) {
    return (antiflood[playerid]["togooc"]) ? true : false;
}
