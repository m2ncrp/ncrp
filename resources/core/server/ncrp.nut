local script = "Night City Role-Play";

const SCRIPT_ROOT = "resources/erp/server/";
const MODULES_DIR = "modules/";

function include(filename, fm = true) 
{
	local file = SCRIPT_ROOT + ((fm) ? MODULES_DIR : "") + filename + ".nut";
	return dofile(file, true);
}

function scriptInit()
{
	log( script + " Loaded!" );
	setGameModeText( "NCRP" );
	setMapName( "Empire Bay" );
}
addEventHandler( "onScriptInit", scriptInit );

function playerConnect( playerid, name, ip, serial )
{
	sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has joined the server.", 255, 204, 0 );
}
addEventHandler( "onPlayerConnect", playerConnect );

function playerDisconnect( playerid, reason )
{
	sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has left the server. (" + reason + ")", 255, 204, 0 );
}
addEventHandler( "onPlayerDisconnect", playerDisconnect );

function playerSpawn( playerid )
{
	setPlayerPosition( playerid, -1551.560181, -169.915466, -19.672523 );
	setPlayerHealth( playerid, 720.0 );

	sendPlayerMessage( playerid, "Welcome to " + script );
	
	triggerClientEvent( playerid, "serverEvent", script, "a test string" );
}
addEventHandler( "onPlayerSpawn", playerSpawn );

addEventHandler( "eventConfirm",
	function( playerid )
	{
		givePlayerWeapon( playerid, 10, 2500 );
		givePlayerWeapon( playerid, 11, 2500 );
		givePlayerWeapon( playerid, 12, 2500 );
	}
);

function playerDeath( playerid, killerid )
{
	if( killerid != INVALID_ENTITY_ID )
		sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has been killed by " + getPlayerName( killerid ) + ".", 255, 204, 0 );
	else
		sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has died.", 255, 204, 0 );
}
addEventHandler( "onPlayerDeath", playerDeath );