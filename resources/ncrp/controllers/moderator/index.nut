include("controllers/moderator/commands.nut");

const MAX_PLAYER_WARNS = 4;


function isPlayerHelper(playerid) {
    if (isPlayerAuthed(playerid)) {
   		if(getPlayerModeratorLvl(playerid) == 1){
   			return true;
   		}
   		return false;
	}
}

function isPlayerModerator(playerid) {
    if (isPlayerAuthed(playerid)) {
   		if(getAccount(playerid).moderator > 1){
   			return true;
   		}
   		return false;
	}
}

function getPlayerModeratorLvl (playerid) {
	if (isPlayerAuthed(playerid)) {
   		return getAccount(playerid).moderator;
	}
}
