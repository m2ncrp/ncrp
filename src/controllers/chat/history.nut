local history = {};
local messagePosition = {};
const MESSAGE_STEP = 5;
const MESSAGE_COUNT = 15;

event("onPlayerConnect", function(playerid){
    local charId = getCharacterIdFromPlayerId(playerid);
    if (!(charId in history)) {
        history[charId] <- [];
    }
});

function addMessageToChatHistory(playerid, message, color) {
    local charId = getCharacterIdFromPlayerId(playerid);
    history[cherId].push([message, color]);
    messagePosition[charId] += 1;
}

function showChatHistory(charId) {
    for(local i = messagePosition[charId]; i < messagePosition[charId] + MESSAGE_COUNT; i++){
        local color = history[i][1];
        sendPlayerMessage(playerid, history[charId][i][0], color.r, color.g, color.b);
    }
}

key("page_up", function(playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);
    if(messagePosition[charId] - MESSAGE_STEP < 0) return;
    messagePosition[charId] -= MESSAGE_STEP;

    showChatHistory(charId);
});

key("page_down", function(playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);
    if(messagePosition[charId] + MESSAGE_STEP > history[charId].length - MESSAGE_COUNT) return;
    messagePosition[charId] += MESSAGE_STEP;

    showChatHistory(charId);
});
