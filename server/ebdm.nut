local script = "Empire Bay Death Match";

function scriptInit()
{
	log( script + " Loaded!" );
	setGameModeText( "EBDM" );
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

addCommandHandler( "vehicle",
	function( playerid, id )
	{
		local pos = getPlayerPosition( playerid );
		local vehicle = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
		
		local colour = getVehicleColour ( vehicle );
	
		log ( "Primary Colour: "+colour[0]+", "+colour[1]+", "+colour[2] );
		log ( "Secondary Colour: "+colour[3]+", "+colour[4]+", "+colour[5] );
		
		setVehicleColour ( vehicle, 255, 0, 255, 0, 255, 255 );
	}
);

addCommandHandler( "tune",
	function( playerid )
	{
		if( isPlayerInVehicle( playerid ) )
		{
			local vehicleid = getPlayerVehicle( playerid );
			setVehicleTuningTable( vehicleid, 3 );
			
			setVehicleWheelTexture( vehicleid, 0, 11 );
			setVehicleWheelTexture( vehicleid, 1, 10 );
		}
	}
);

addCommandHandler( "fix",
	function( playerid )
	{
		if( isPlayerInVehicle( playerid ) )
		{
			local vehicleid = getPlayerVehicle( playerid );
			repairVehicle( vehicleid );
		}
	}
);

addCommandHandler( "heal",
	function( playerid )
	{
		setPlayerHealth( playerid, 720.0 );
	}
);

addCommandHandler( "siren",
	function( playerid )
	{
		local vehicle = getPlayerVehicle( playerid );
		setVehicleSirenState( vehicle, !getVehicleSirenState( vehicle ) );
	}
);

addCommandHandler( "model",
	function( playerid, id )
	{
		setPlayerModel( playerid, id.tointeger() );
	}
);

addCommandHandler( "lock",
	function( playerid )
	{
		togglePlayerControls ( playerid, false );
	}
);

addCommandHandler( "unlock",
	function( playerid )
	{
		togglePlayerControls ( playerid, true );
	}
);