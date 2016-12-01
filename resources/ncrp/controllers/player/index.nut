include("controllers/player/commands.nut");
include("controllers/player/PlayerList.nut");
include("controllers/player/functions.nut");

players <- {};
xPlayers <- {};
playerList <- {};

const CHARACTER_DEFAULT_SKIN   = 10;
const CHARACTER_DEFAULT_MONEY  = 1.75;
const CHARACTER_DEFAULT_LOCALE = "en";

default_spawns <- [
    [-555.251,  1702.31, -22.2408], // railway
    [-11.2921,  1631.85, -20.0296], // tmp bomj spawn
    // [ 100.421,  1776.41, -24.0068], // bomj style
    // [-402.282, -828.907, -21.7456]  // port
    [-344.028, -952.702, -21.7457], // new port
];

event("onPlayerInit", function(playerid, name, ip, serial) {
    Character.findOneBy({ name = getPlayerName(playerid) }, function(err, char) {
        if (err || !char) {
            // create entity
            char = Character();

            // setup deafults
            char.name    = getPlayerName(playerid);
            char.spawnid = random(0, default_spawns.len());
            char.money   = CHARACTER_DEFAULT_MONEY;
            char.dskin   = CHARACTER_DEFAULT_SKIN;
            char.cskin   = CHARACTER_DEFAULT_SKIN;
            char.locale  = CHARACTER_DEFAULT_LOCALE;

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
        players[playerid]["locale"]       <- char.locale;

        // notify all that client connected (and data loaded)
        trigger("onPlayerConnect", playerid, name, ip, serial);

        delayedFunction(2000, function() {
            trigger(playerid, "onServerClientStarted", "0.0.458");
            trigger(playerid, "onServerIntefaceCharacter", getLocalizedPlayerJob(playerid, "en"), getPlayerLevel(playerid) );
            trigger(playerid, "onServerInterfaceMoney", getPlayerMoney(playerid));
            screenFadeout(playerid, 1000);
        });
    });
});

function trySavePlayer(playerid) {
    if (!(playerid in players) || !(playerid in xPlayers)) {
        return null;
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
    char.housex  = players[playerid]["housex"];
    char.housey  = players[playerid]["housey"];
    char.housez  = players[playerid]["housez"];
    char.job     = (players[playerid]["job"]) ? players[playerid]["job"] : "";
    char.locale  = players[playerid]["locale"];

    // save it
    char.save();
}

event("native:onPlayerDisconnect", function(playerid, reason) {
    // call events
    trigger("onPlayerDisconnect", playerid, reason);

    // save player after disconnect
    trySavePlayer(playerid);
    playerList.delPlayer(playerid);
    delete players[playerid];
    delete xPlayers[playerid];
});

addEventHandlerEx("onServerAutosave", function() {
    foreach (playerid, char in players) {
        trySavePlayer(playerid);
        trigger(playerid, "onServerIntefaceCharacter", getLocalizedPlayerJob(playerid, "en"), getPlayerLevel(playerid) );
    }
});

addEventHandlerEx("onServerMinuteChange", function() {
    foreach (playerid, char in players) {
        char.xp++;
    }
});

addEventHandler("native:onPlayerSpawn", function(playerid) {
    if (!(playerid in players)) {
        return dbg("[error] no playerid in players array " + playerid);
    }

    // check if player has home
    if (players[playerid].housex != 0.0 && players[playerid].housey != 0.0) {
        setPlayerPosition(playerid, players[playerid].housex, players[playerid].housey, players[playerid].housez);
    } else {
        local spawnID = players[playerid]["spawn"];
        local x = default_spawns[spawnID][0];
        local y = default_spawns[spawnID][1];
        local z = default_spawns[spawnID][2];
        setPlayerPosition(playerid, x, y, z);
    }

    setPlayerHealth(playerid, 730.0);
    setPlayerColour(playerid, 0x99FFFFFF); // whity
    setPlayerModel(playerid, players[playerid].skin);

    trigger("onPlayerSpawn", playerid);
    trigger("onPlayerSpawned", playerid);
});

addEventHandler("native:onPlayerDeath", function(playerid, killerid) {
    if (killerid != INVALID_ENTITY_ID) {
        sendPlayerMessageToAll("~ " + getPlayerName(playerid) + " has been killed by " + getPlayerName(killerid) + ".", 255, 204, 0);
    } else {
        sendPlayerMessageToAll("~ " + getPlayerName(playerid) + " has died.", 255, 204, 0 );
    }

    trigger("onPlayerDeath", playerid, killerid);
});
