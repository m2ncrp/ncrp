dofile("libs/index.nut", true);

accounts <- {};

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
    if (!(playerid in accounts)) return;

    // clean up data for GC
    accounts[playerid].clean();
    accounts[playerid] = null;

    delete accounts[playerid];
});

addEventHandler("Player:hasLogined", function(id) {
    players.push(id);
});

addEventHandler("__networkRequest", function(request) {
    local data = request.data;

    // we are working with current resource
    if (!("destination" in data) || data.destination != "auth") return;

    if (data.method == "getSession") {
        ::print("- getting session for " + data.id + "\n");
        Response({result = data.id in accounts ? accounts[data.id] : null}, request).send();
    }

    if (data.method == "addSession") {
        ::print("- adding session for " + data.id + "\n");
        accounts[data.id] <- data.object;
    }
});



// will be disalbed in prod
triggerServerEvent("__resourceLoaded", "auth");

