local history = {};
local minPosition = {};
const MESSAGE_STEP = 4;

event("onPlayerConnect", function(playerid){
    local charId = getCharacterIdFromPlayerId(playerid);
    if (!(charId in history)) {
        history[charId] <- [];
				minPosition[charId] <- 0;
    }
});

function addMessageToChatHistory(playerid, message, color) {
    local charId = getCharacterIdFromPlayerId(playerid);
		if(!charId) return;
    history[charId].push([message, color]);
}

function showChatHistory(playerid, posStart) {
		local charId = getCharacterIdFromPlayerId(playerid);
		if(!charId) return;
    for(local i = minPosition[charId]; i < maxPosition[charId]; i++){
        local color = history[charId][i][1];
        sendPlayerMessage(playerid, history[charId][i][0], color.r, color.g, color.b);
    }
}

function getMaxPositionMessage(playerid) {
		local charId = getCharacterIdFromPlayerId(playerid);
		if(!charId) return 0;

		return maxPosition[charId];
}

function getHistoryLength(playerid) {
		local charId = getCharacterIdFromPlayerId(playerid);
		if(!charId) return 0;

		return history[charId].len();
}

key("page_up", function(playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);
    if(minPosition[charId] - MESSAGE_STEP < 0) return;

		minPosition[charId] -= MESSAGE_STEP;

    showChatHistory(playerid, posStart);
});

key("page_down", function(playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);

    if(minPosition[charId] + MESSAGE_STEP > history[charId].len()) return;

		minPosition[charId] += MESSAGE_STEP;

    showChatHistory(playerid, posStart);
});

