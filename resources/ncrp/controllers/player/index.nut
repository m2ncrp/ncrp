include("controllers/player/commands.nut");
include("controllers/player/PlayerList.nut");
include("controllers/player/functions.nut");
include("controllers/player/anticheat.nut");
include("controllers/player/respawn");
include("controllers/player/afk.nut");

players <- {};
xPlayers <- {};
playerList <- {};

const CHARACTER_DEFAULT_SKIN   = 10; // @deprecated
const CHARACTER_DEFAULT_MONEY  = 1.75; // @deprecated

const DEFAULT_SPAWN_SKIN = 4;
const DEFAULT_SPAWN_X    = -143.0;//-1027.02;
const DEFAULT_SPAWN_Y    = 1206.0;//1746.63;
const DEFAULT_SPAWN_Z    = 84.0;//10.2325;


// hospital
const HOSPITAL_X         = -393.429;
const HOSPITAL_Y         = 912.044;
const HOSPITAL_Z         = -20.0026;
const HOSPITAL_AMOUNT    = 4.99;

// jail
const JAIL_X = -1018.93;
const JAIL_Y = 1731.82;
const JAIL_Z = 10.3252;

default_spawns <- [
    [-555.251,  1702.31, -22.2408], // railway
    [-555.251,  1702.31, -22.2408], // railway
    // [-11.2921,  1631.85, -20.0296], // tmp bomj spawn
    // [ 100.421,  1776.41, -24.0068], // bomj style
    // [-402.282, -828.907, -21.7456]  // port
    [-344.028, -952.702, -21.7457], // new port
    [-344.028, -952.702, -21.7457], // new port
];

// PlayerStates <- [
//     "free",   // 0
//     "cuffed", // 1
//     "tased"   // 2
// ];

local defaultSkins = [
    10, 24, 42, 71, 72, 81, 149, 162
];
local ticker = null;

event("onServerStarted", function() {
    ticker = timer(function() {
        foreach (playerid, value in players) {

            if (isPlayerConnected(playerid)) {
                continue;
            }

            local pos = getPlayerPosition(playerid);

            if (pos && pos.len() != 3) {
                continue;
            }

            // check for falling players
            if (pos[2] < -75.0) {
                dbg("player", "falldown", playerid);
                trigger("onPlayerFallingDown", playerid);
            }

            // store position in-memory
            if (playerid in xPlayers) {
                local char = xPlayers[playerid];
                local pos  = getPlayerPosition(playerid);

                char.housex = pos[0];
                char.housey = pos[1];
                char.housez = pos[2];
                // char.y = pos[1];
                // char.z = pos[2];
            }
        }
    }, 500, -1);
});

event("onPlayerInit", function(playerid, name, ip, serial) {
    // reset screen data
    trigger(playerid, "resetPlayerIntroScreen");

    Character.findOneBy({ name = getPlayerName(playerid) }, function(err, char) {
        if (err || !char) {
            // create entity
            char = Character();

            // setup deafults
            char.name    = getPlayerName(playerid);
            char.spawnid = random(0, default_spawns.len() - 1);
            char.money   = randomf(5.0, 10.0);
            char.dskin   = defaultSkins[random(0, defaultSkins.len() - 1)];
            char.cskin   = char.dskin;
            char.health  = 720.0;

            // save first-time created entity
            char.save();
        }

        xPlayers[playerid] <- char;

        // legacy data binding
        // @deprecated
        playerList.addPlayer(playerid, name, ip, serial);
        players[playerid]                 <- {};
        players[playerid]["request"]      <- {}; // need for invoice to transfer money
        players[playerid]["job"]          <- (char.job.len() > 0) ? char.job : null;
        players[playerid]["money"]        <- char.money;
        players[playerid]["deposit"]      <- char.deposit;
        players[playerid]["default_skin"] <- char.dskin;  // skin which buy by player
        players[playerid]["skin"]         <- char.cskin;  // current skin
        players[playerid]["spawn"]        <- char.spawnid;
        players[playerid]["xp"]           <- char.xp;
        players[playerid]["housex"]       <- char.housex;
        players[playerid]["housey"]       <- char.housey;
        players[playerid]["housez"]       <- char.housez;
        players[playerid]["health"]       <- char.health;
        players[playerid]["toggle"]       <- false;
        players[playerid]["state"]        <- (char.state.len() > 0) ? char.state : "free";

        // notify all that client connected (and data loaded)
        trigger("onPlayerConnect", playerid, name, ip, serial);
        trigger("native:onPlayerSpawn", playerid);

        delayedFunction(1500, function() {
            trigger("onServerPlayerStarted", playerid);
            trigger(playerid, "onServerClientStarted", VERSION);
            trigger(playerid, "onServerIntefaceCharacter", getLocalizedPlayerJob(playerid, "en"), getPlayerLevel(playerid) );
            trigger(playerid, "onServerInterfaceMoney", getPlayerMoney(playerid));
            screenFadeout(playerid, 500);

            // try to undfreeze player
            freezePlayer(playerid, false);
            trigger(playerid, "resetPlayerIntroScreen");
            delayedFunction(1000, function() { freezePlayer(playerid, false); });
        });
    });
});

function trySavePlayer(playerid) {
    if (!(playerid in players) || !(playerid in xPlayers)) {
        return null;
    }

    // if player has crashed on spawn
    if (isInRadius(playerid, DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z, 5.0)) {
        char.x = HOSPITAL_X;
        char.y = HOSPITAL_Y;
        char.z = HOSPITAL_Z;
    }

    // get instance
    local char   = xPlayers[playerid];

    // proxy data back to the model
    char.money   = players[playerid]["money"];
    char.deposit = players[playerid]["deposit"];
    char.dskin   = players[playerid]["default_skin"];
    char.cskin   = players[playerid]["skin"];
    char.spawnid = players[playerid]["spawn"];
    char.xp      = players[playerid]["xp"];
    char.job     = (players[playerid]["job"]) ? players[playerid]["job"] : "";
    char.health  = getPlayerHealth(playerid);
    char.state   = getPlayerState(playerid);

    // save it
    char.save();
}

function removePlayer(playerid, reason = "") {
    dbg("player", "disconnect", getPlayerName(playerid));
    setPlayerAuthBlocked(playerid, true);

    if (!(playerid in players)) {
        return dbg(format("player %s exited without login", getPlayerName(playerid)));
    }

    // call events
    trigger("onPlayerDisconnect", playerid, reason);

    // save player after disconnect
    trySavePlayer(playerid);
    playerList.delPlayer(playerid);
    delete players[playerid];
    delete xPlayers[playerid];
}

event("native:onPlayerDisconnect", removePlayer);

addEventHandlerEx("onServerAutosave", function() {
    foreach (playerid, char in players) {
        trySavePlayer(playerid);
        trigger(playerid, "onServerIntefaceCharacter", getLocalizedPlayerJob(playerid, "en"), getPlayerLevel(playerid) );
    }
});

// prevent nickname spoofing
event("native:onPlayerChangeNick", function(playerid, newname, oldnickname) {
    kick(-1, playerid, "nick change is not allowed in game.");
});

addEventHandlerEx("onServerMinuteChange", function() {
    foreach (playerid, char in players) { char.xp++; }
});

event("onPlayerMoneyChanged", function(playerid) {
    if (isPlayerLogined(playerid)) {
        trySavePlayer(playerid);
    }
});

event("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    trySavePlayer(playerid);
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    trySavePlayer(playerid);
});

// key("f", function(playerid) {
//     if (isPlayerInVehicle(playerid)) {
//         dbg("player", "save on exit from vehicle");
//         trySavePlayer(playerid);
//     }
// }, KEY_DOWN);

event("onPlayerConnectInit", function(playerid, name, ip, serial) {
    // set player colour
    setPlayerColour(playerid, 0x99FFFFFF); // whity
});

event("onServerPlayerStarted", function(playerid) {
    local weaponlist = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 21];
    weaponlist.apply(function(id) {
        removePlayerWeapon( playerid, id );
    })

    if (getPlayerName(playerid) == "Inlife") {
        setPlayerColour(playerid, 0x99FF3333); // admin
    }
    if (getPlayerName(playerid) == "Klo_Douglas") {
        setPlayerColour(playerid, 0x99FF3333); // admin
    }

    // clear chat
    for (local i = 0;i < 14; i++) {
        msg(playerid, "", CL_BLACK);
    }

    if (getPlayerName(playerid) == "nightm4re") {
        msg(playerid, "[ADMIN][AUTOMATED] Hello, nightm4re. We saw your suggestion about translation.", CL_MEDIUMPURPLE);
        msg(playerid, "[ADMIN][AUTOMATED] And we think its a good idea. Please, contact us at: bit.ly/tsoeb.", CL_MEDIUMPURPLE);
    }
});

event("native:onPlayerSpawn", function(playerid) {
    local position = {};

    // player is not yet logined
    if (!(playerid in players)) {
        // togglePlayerControls(playerid, true);

        position = {x = DEFAULT_SPAWN_X, y = DEFAULT_SPAWN_Y, z = DEFAULT_SPAWN_Z};
        setPlayerPosition(playerid, position.x, position.y, position.z);
        trigger(playerid, "setPlayerIntroScreen");
        setPlayerModel(playerid, DEFAULT_SPAWN_SKIN);
        togglePlayerHud(playerid, true);

        return;

    } else {
        if (getPlayerState(playerid) == "jail") {
            return setPlayerPosition(playerid, JAIL_X, JAIL_Y, JAIL_Z);
        }
        // check if player just dead
        if (isPlayerBeenDead(playerid)) {

            // repsawn at the hospital
            position = {x = HOSPITAL_X, y = HOSPITAL_Y, z = HOSPITAL_Z};

            // maybe deduct some money...
            if (canMoneyBeSubstracted(playerid, HOSPITAL_AMOUNT)) {
                subMoneyToPlayer(playerid, HOSPITAL_AMOUNT);
                msg(playerid, "hospital.money.deducted", [HOSPITAL_AMOUNT], CL_SUCCESS);
                setPlayerHealth(playerid, 730.0);
            } else {
                msg(playerid, "hospital.money.donthave", [], CL_ERROR);
                setPlayerHealth(playerid, 370.0);
            }

        } else if (players[playerid].housex != 0.0 && players[playerid].housey != 0.0) {

            // spawn player at coords of exit
            position = {x = players[playerid].housex, y = players[playerid].housey, z = players[playerid].housez};
            setPlayerHealth(playerid, players[playerid].health);

        } else {

            local spawnID = players[playerid]["spawn"];

            local x = default_spawns[spawnID][0];
            local y = default_spawns[spawnID][1];
            local z = default_spawns[spawnID][2];

            position = {x = x, y = y, z = z};
            setPlayerHealth(playerid, players[playerid].health);
        }

        delayedFunction(calculateFPSDelay(playerid) + 1500, function() {
            screenFadeout(playerid, 1000);
        });

        togglePlayerControls(playerid, false);

        setPlayerModel(playerid, players[playerid].skin);

        trigger("onPlayerSpawn", playerid);
        trigger("onPlayerSpawned", playerid);

        setPlayerPosition(playerid, position.x, position.y, position.z);
    }
});

event("native:onPlayerDeath", function(playerid, killerid) {
    // store state for respawning
    setPlayerBeenDead(playerid);
    trigger("onPlayerDeath", playerid);
    dbg("player", "death", getAuthor(playerid), (killerid != INVALID_ENTITY_ID) ? getAuthor(killerid) : "self");

    if (killerid != INVALID_ENTITY_ID) {
        trigger("onPlayerMurdered", playerid, killerid);
        trigger("onPlayerKill", killerid, playerid);
    }
});



event("onPlayerStateChange", function(playerid) {
    // WIP
    trySavePlayer(playerid);
})
