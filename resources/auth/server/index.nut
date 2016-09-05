dofile("./resources/libs/index.nut", true);

local players = [];

function checkName(username) {
    local rx = regexp("([A-Za-z0-9]{1,32}_[A-Za-z0-9]{1,32})");
    return rx.match(username);
}

addEventHandler("onPlayerConnect", function(playerid, username, ip, serial) {
    if (!checkName(username)) { return kickPlayer(playerid); }

    Account.findOneBy({ username = username }, function(err, account) {
        sendPlayerMessage(playerid, "---------------------------------------------");
        sendPlayerMessage(playerid, "* " + "Welcome there " + username);

        if (account) {
            sendPlayerMessage(playerid, "* " + "Your account is registed");
            sendPlayerMessage(playerid, "*");
            sendPlayerMessage(playerid, "* " + "Please enter using /login [password]");
        } else {
            sendPlayerMessage(playerid, "* " + "This account is not registered");
            sendPlayerMessage(playerid, "*");
            sendPlayerMessage(playerid, "* " + "Please register using /register [password]");
        }
        
        sendPlayerMessage(playerid, "---------------------------------------------");
    });
});

addEventHandler("onPlayerDisconnect", function(playerid, reason) {
    players.remove(players.find(playerid));
});

addEventHandler("Player:hasLogined", function(id) {
    players.push(id);
})

addEventHandler("Player:isLogined", function(request) {
    // Response({ response = (request.data.id in players)}, request).send();
});

// will be disalbed in prod
triggerServerEvent("__resourceLoaded", "auth");
