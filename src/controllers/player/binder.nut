local playersInfo = {};

function getPlayerBinderState(playerid,) {
  return playersInfo[getCharacterIdFromPlayerId(playerid)];
}

function setPlayerBinderState(playerid, state) {
  playersInfo[getCharacterIdFromPlayerId(playerid)] <- state;
}

function clearPlayerBinderState(playerid) {
  playersInfo[getCharacterIdFromPlayerId(playerid)] <- null;
}
