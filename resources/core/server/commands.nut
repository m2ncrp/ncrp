dofile("dependencies/Shortcuts/shortcuts.nut", true);
dofile("resources/core/server/color.nut");
dofile("resources/core/server/tools.nut");
dofile("resources/core/server/ncrp.nut");


cmd(["help"], function(playerid) {
	local commands = [
        { name = "/spawn",          	desc = "Teleport to spawn" },
        { name = "/weapons",        	desc = "Give yourself some damn guns!" },
        { name = "/heal",           	desc = "Restore your precious health points :p"},
        { name = "/die",            	desc = "If you dont wanna live there anymore" },
        { name = "/vehicle <id>",   	desc = "Spawn vehicle, example /vehicle 45" },
        { name = "/tune",           	desc = "Tune up your vehicle!" },
        { name = "/fix",            	desc = "Fix up your super vehicle" },
        { name = "/destroyVehicle", 	desc = "Remove car you are in" },
        { name = "/skin <id>",      	desc = "Change your skin :O. Example: /skin 63" },
        { name = "/say <text>",			desc = "Put your text in local RP chat"},
        { name = "/shout <text>",		desc = "Your message could be heard far enough :)"},
        { name = "/b <text>", 			desc = "Local nonRP chat"},
        { name = "/ooc <text>", 		desc = "Global nonRP chat"},
        { name = "/me <action text>",	decs = "Some action of your person"},
        { name = "/try <action text>", 	desc = "Any action simulation that could be failed"}
    ];

    sendPlayerMessage(playerid, "");
    sendPlayerMessage(playerid, "==================================", 200, 100, 100);
    sendPlayerMessage(playerid, "Here is list of available commands:", 200, 200, 0);

    foreach (idx, CMD in commands) {
        local text = " * Command: " + CMD.name + "   -   " + CMD.desc;
        if ((idx % 2) == 0) {
            sendPlayerMessage(playerid, text, 200, 230, 255);
        } else {
            sendPlayerMessage(playerid, text);
        }
    }
});



cmd(["spawn"], function(playerid) {
    setPlayerPosition( playerid, -1551.560181, -169.915466, -19.672523 );
    setPlayerHealth( playerid, 720.0 );
});


cmd(["weapons"], function(playerid) {
    givePlayerWeapon( playerid, 10, 2500 );
    givePlayerWeapon( playerid, 11, 2500 );
    givePlayerWeapon( playerid, 12, 2500 );
});


cmd(["heal"], function( playerid ) {
	setPlayerHealth( playerid, 720.0 );
});


cmd(["die"], function( playerid ) {
    setPlayerHealth( playerid, 0.0 );
});


cmd(["vehicle"], function( playerid, id ) {
	local pos = getPlayerPosition( playerid );
	local vehicle = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
	
	local colour = getVehicleColour ( vehicle );

	log ( "Primary Colour: "+colour[0]+", "+colour[1]+", "+colour[2] );
	log ( "Secondary Colour: "+colour[3]+", "+colour[4]+", "+colour[5] );
	
	setVehicleColour ( vehicle, 255, 0, 255, 0, 255, 255 );
});


cmd(["tune"], function( playerid ) {
	if( isPlayerInVehicle( playerid ) )
	{
		local vehicleid = getPlayerVehicle( playerid );
		setVehicleTuningTable( vehicleid, 3 );
		
		setVehicleWheelTexture( vehicleid, 0, 11 );
		setVehicleWheelTexture( vehicleid, 1, 11 );
	}
});


cmd(["fix"], function( playerid ) {
	if( isPlayerInVehicle( playerid ) )
	{
		local vehicleid = getPlayerVehicle( playerid );
		repairVehicle( vehicleid );
	}
});


cmd(["destroyVehicle"], function( playerid ) {
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        destroyVehicle( vehicleid );
    }
});


cmd(["skin"], function( playerid, id ) {
	setPlayerModel( playerid, id.tointeger() );
});



/* 
				CHAT BITCH 
*/
function inRadius(message, sender, radius, color = 0)
{
	local players = playerList.getPlayers();
	foreach(player in players) {
		if (getDistance(sender, player) <= radius) {
			sendPlayerMessage(player, text, CL_WHITE.r, CL_WHITE.g, CL_WHITE.b);
		}
	}
}

// local chat 
cmd(["i","say"], function( playerid, ... ) {  
	local text = concat(vargv);
	sendPlayerMessageToAll(text);
});


// shout 
cmd(["s","shout"], function( playerid, ... ) {
	local text = concat(vargv);
	sendPlayerMessageToAll(text, CL_WHITE.r, CL_WHITE.g, CL_WHITE.b);
});


// nonRP local chat
cmd(["b"], function( playerid, ... ) {  	
	local text = concat(vargv);
	sendPlayerMessageToAll(text, CL_GRAY.r, CL_GRAY.g, CL_GRAY.b);
});


// global nonRP chat
cmd(["o","ooc"], function( playerid, ... ) {  	
	local text = concat(vargv);
	sendPlayerMessageToAll(text, CL_GRAY.r, CL_GRAY.g, CL_GRAY.b);
});


cmd("me", function( playerid, ... ) {
	local text = concat(vargv);
	sendPlayerMessageToAll("[ME] " + getPlayerName( playerid ) + text, CL_YELLOW.r, CL_YELLOW.g, CL_YELLOW.b);
});


// random for some actions
cmd("try", function(playerid, ...) { 
	local text = getPlayerName( playerid ) + "[TRY] " + concat(vargv);

	local res = random(0,1);
	if(res == 1)
		sendPlayerMessageToAll( text + " (success).");
	else
		sendPlayerMessageToAll( text + " (failed).");	
});