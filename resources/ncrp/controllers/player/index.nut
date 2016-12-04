include("controllers/player/commands.nut");
include("controllers/player/PlayerList.nut");
include("controllers/player/functions.nut");

players <- {};
xPlayers <- {};
playerList <- {};

const CHARACTER_DEFAULT_SKIN   = 10;
const CHARACTER_DEFAULT_MONEY  = 1.75;
const CHARACTER_DEFAULT_LOCALE = "en";

const DEFAULT_SPAWN_SKIN = 10;
const DEFAULT_SPAWN_X    = -1684.52;
const DEFAULT_SPAWN_Y    = 981.397;
const DEFAULT_SPAWN_Z    = -0.473357;

// hospital
const HOSPITAL_X         = -393.429;
const HOSPITAL_Y         = 912.044;
const HOSPITAL_Z         = -20.0026;
const HOSPITAL_AMOUNT    = 15.0;

default_spawns <- [
    [-555.251,  1702.31, -22.2408], // railway
    [-11.2921,  1631.85, -20.0296], // tmp bomj spawn
    // [ 100.421,  1776.41, -24.0068], // bomj style
    // [-402.282, -828.907, -21.7456]  // port
    [-344.028, -952.702, -21.7457], // new port
    [-344.028, -952.702, -21.7457], // new port
];

local defaultSkins = [
    10, 24, 42, 71, 72, 81, 149, 162
];

event("onPlayerInit", function(playerid, name, ip, serial) {
    Character.findOneBy({ name = getPlayerName(playerid) }, function(err, char) {
        if (err || !char) {
            // create entity
            char = Character();

            // setup deafults
            char.name    = getPlayerName(playerid);
            char.spawnid = random(0, default_spawns.len() - 1);
            char.money   = randomf(5.0, 17.0);
            char.dskin   = defaultSkins[random(0, defaultSkins.len() - 1)];
            char.cskin   = char.dskin;
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
        trigger("native:onPlayerSpawn", playerid);

        delayedFunction(1500, function() {
            trigger("onServerPlayerStarted", playerid);
            trigger(playerid, "onServerClientStarted", VERSION);
            trigger(playerid, "onServerIntefaceCharacter", getLocalizedPlayerJob(playerid, "en"), getPlayerLevel(playerid) );
            trigger(playerid, "onServerInterfaceMoney", getPlayerMoney(playerid));
            screenFadeout(playerid, 500);
        });
    });
});

function trySavePlayer(playerid) {
    if (!(playerid in players) || !(playerid in xPlayers)) {
        return null;
    }

    // get instance
    local char   = xPlayers[playerid];
    local pos    = getPlayerPositionObj(playerid);

    // proxy data back to the model
    char.money   = players[playerid]["money"];
    char.deposit = players[playerid]["deposit"];
    char.dskin   = players[playerid]["default_skin"];
    char.cskin   = players[playerid]["skin"];
    char.spawnid = players[playerid]["spawn"];
    char.xp      = players[playerid]["xp"];
    char.housex  = pos.x;
    char.housey  = pos.y;
    char.housez  = pos.z;
    char.job     = (players[playerid]["job"]) ? players[playerid]["job"] : "";
    char.locale  = players[playerid]["locale"];

    // save it
    char.save();
}

event("native:onPlayerDisconnect", function(playerid, reason) {
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
});

addEventHandlerEx("onServerAutosave", function() {
    foreach (playerid, char in players) {
        trySavePlayer(playerid);
        trigger(playerid, "onServerIntefaceCharacter", getLocalizedPlayerJob(playerid, "en"), getPlayerLevel(playerid) );
    }
});

addEventHandlerEx("onServerMinuteChange", function() {
    foreach (playerid, char in players) { char.xp++; }
});

event("onPlayerMoneyChanged", function(playerid) {
    if (isPlayerLogined(playerid)) {
        trySavePlayer(playerid);
    }
});

event("onServerPlayerStarted", function(playerid) {
    local weaponlist = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 21];
    weaponlist.apply(function(id) {
        removePlayerWeapon( playerid, id );
    })
});

event("native:onPlayerSpawn", function(playerid) {
    // set player colour
    setPlayerColour(playerid, 0x99FFFFFF); // whity

    // player is not yet logined
    if (!(playerid in players)) {
        togglePlayerControls(playerid, true);

        setPlayerPosition(playerid, DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z);
        // setPlayerRotation(playerid, -99.8071, -0.000323891, -0.00024408);
        setPlayerModel(playerid, DEFAULT_SPAWN_SKIN);
        togglePlayerHud(playerid, true);

    } else {
        // check if player just dead
        if (isPlayerBeenDead(playerid)) {

            // repsawn at the hospital
            setPlayerPosition(playerid, HOSPITAL_X, HOSPITAL_Y, HOSPITAL_Z);

            // maybe deduct some money...
            if (canMoneyBeSubstracted(playerid, HOSPITAL_AMOUNT)) {
                subMoneyToPlayer(playerid, HOSPITAL_AMOUNT);
                msg(playerid, "hospital.money.deducted", [HOSPITAL_AMOUNT], CL_SUCCESS);
                setPlayerHealth(playerid, 730.0);
            } else {
                msg(playerid, "hospital.money.donthave", [HOSPITAL_AMOUNT], CL_ERROR);
                setPlayerHealth(playerid, 370.0);
            }

        } else if (players[playerid].housex != 0.0 && players[playerid].housey != 0.0) {

            // check if player has home
            setPlayerPosition(playerid,
                players[playerid].housex,
                players[playerid].housey,
                players[playerid].housez
            );

            setPlayerHealth(playerid, 730.0);

        } else {

            local spawnID = players[playerid]["spawn"];

            local x = default_spawns[spawnID][0];
            local y = default_spawns[spawnID][1];
            local z = default_spawns[spawnID][2];

            setPlayerPosition(playerid, x, y, z);
            setPlayerHealth(playerid, 730.0);
        }

        delayedFunction(calculateFPSDelay(playerid) + 1500, function() {
            screenFadeout(playerid, 1000);
        });

        togglePlayerControls(playerid, false);

        setPlayerModel(playerid, players[playerid].skin);

        trigger("onPlayerSpawn", playerid);
        trigger("onPlayerSpawned", playerid);
    }
});

event("native:onPlayerDeath", function(playerid, killerid) {
    // store state for respawning
    setPlayerBeenDead(playerid);
    trigger("onPlayerDeath", playerid);

    if (killerid != INVALID_ENTITY_ID) {
        trigger("onPlayerMurdered", playerid, killerid);
        trigger("onPlayerKill", killerid, playerid);
    }
});
