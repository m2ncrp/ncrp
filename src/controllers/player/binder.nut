local playersInfo = {};

function getPlayerBinderState(playerid) {
  local charid = getCharacterIdFromPlayerId(playerid);
  return (charid in playersInfo) ? playersInfo[charid] : false;
}

function setPlayerBinderState(playerid, state) {
  playersInfo[getCharacterIdFromPlayerId(playerid)] <- state;
}

function clearPlayerBinderState(playerid) {
  playersInfo[getCharacterIdFromPlayerId(playerid)] <- null;
}
