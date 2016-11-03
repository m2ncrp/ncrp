// initialize libraries
dofile("resources/ncrp/libraries/index.nut", true);

// load classes
include("traits/Colorable.nut");
include("models/Color.nut");
include("models/Account.nut");
include("models/Vehicle.nut");
include("models/TeleportPosition.nut");
include("models/TimestampStorage.nut");

// load helpers
include("helpers/array.nut");
include("helpers/function.nut");
include("helpers/string.nut");
include("helpers/math.nut");
include("helpers/distance.nut");
include("helpers/commands.nut");
include("helpers/color.nut");

// load controllers
include("controllers/database");
include("controllers/time");
include("controllers/auth");
include("controllers/chat");
include("controllers/weather");
include("controllers/world");
include("controllers/money");
include("controllers/jobs");
include("controllers/metro");
include("controllers/police");
include("controllers/government");
include("controllers/player");
include("controllers/vehicle");
include("controllers/utils");
include("controllers/screen");
include("controllers/admin");

// initialize global values
local script = "Night City Role-Play";

playerList <- null;

class PlayerList
{
    players = null;

    constructor () {
        this.players = {};
    }

    function getPlayers()
    {
        return this.players;
    }

    function addPlayer(id, name, ip, serial)
    {
        this.players[id] <- id;
    }

    function delPlayer(id)
    {
        local t = this.players[id];
        delete this.players[id];
        return t;
    }

    function getPlayer(id)
    {
        return this.players[id];
    }

    function each(callback)
    {
        foreach (idx, playerid in this.players) {
            callback(playerid);
        }
    }

    function nearestPlayer( playerid )
    {
        local min = null;
        local str = null;
        foreach(target in this.getPlayers()) {
            local dist = getDistance(playerid, target);
            if(dist < min || !min) {
                min = dist;
                str = target;
            }
        }
        return str;
    }
}

addEventHandler("onScriptInit", function() {
    log("[core] starting initialization...");

    // setup default values
    setGameModeText( "NCRP" );
    setMapName( "Empire Bay" );

    // creating playerList storage
    playerList = PlayerList();

    // triggerring load events
    triggerServerEventEx("onServerStarted");
});


addEventHandler("onScriptExit", function() {
    triggerServerEventEx("onServerStopping");
    triggerServerEventEx("onServerStopped");
});

addEventHandler("onServerShutdown", function() {
    triggerServerEventEx("onServerStopping");
    triggerServerEventEx("onServerStopped");
});

addEventHandler( "onPlayerConnect", function( playerid, name, ip, serial ) {
    sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has joined the server.", 255, 204, 0 );
    playerList.addPlayer(playerid, name, ip, serial);
});

addEventHandler( "onPlayerDisconnect", function( playerid, reason ) {
    sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has left the server. (" + reason + ")", 255, 204, 0 );
    playerList.delPlayer(playerid);
});


addEventHandler( "onPlayerSpawn", function( playerid ) {
    setPlayerPosition( playerid, -350.47, -726.722, -15.4205 );
    setPlayerHealth( playerid, 720.0 );
    sendPlayerMessage( playerid, "Welcome to " + script );
});


addEventHandler( "onPlayerDeath", function( playerid, killerid ) {
    if( killerid != INVALID_ENTITY_ID )
        sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has been killed by " + getPlayerName( killerid ) + ".", 255, 204, 0 );
    else
        sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has died.", 255, 204, 0 );
});
