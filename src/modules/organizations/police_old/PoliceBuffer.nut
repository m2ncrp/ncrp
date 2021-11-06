/**
 * PoliceBuffer contain all police officers data if some of them has game crash or disconnected (for a small time in future).
 * Allow to keep data on the server and restore it if player back online.
 *
 * ATTENTION! All tha data stores now while server's online. After its reboot buffer will be empty.
 */
__police_buffer <- {}
local POLICE_BUFFER_SIZE = null;


function sendPoliceOfficerDataToBuffer(playerid) {
    __police_buffer[POLICE_BUFFER_SIZE++] <- {
	    name 		= getPlayerName(playerid),
	    rank 		= getLocalizedPlayerJob(playerid),
	    onDuty		= isOnPoliceDuty(playerid),
	    // invited 	= getPlayerWhoInvite(playerid);
	    // invitedate 	= Invite.getDate();
	};
    return POLICE_BUFFER_SIZE;
};


function isCharacterInBuffer(name) {
    foreach (idx, data in __police_buffer) {
        if (data.name == name) {
        	return {res = true, index = idx, duty = data.onDuty};
        }
    }
    return {res = false, index = null, duty = null};
}


event("onServerStarted", function() {
	POLICE_BUFFER_SIZE = 0;
});


event("onPlayerCharacterLoaded", function(playerid, character) {
	// get all the data
	local data = isCharacterInBuffer(getPlayerName(playerid));
	// if dat character's stored in buffer
	if ( data.res ) {
		// set up duty status
		policeSetOnDuty(playerid, data.duty);
		delete __police_buffer[data.index];
	}
});


/**
	If player disconnected transfer his data from police_online to __police_buffer.
*/
event("onPlayerDisconnect", function(playerid, reason) {
    if (playerid in police) {
        sendPoliceOfficerDataToBuffer(playerid);
        policeSetOnDuty(playerid, false);
        restorePlayerModel(playerid);
        delete police[playerid];
    }
});
