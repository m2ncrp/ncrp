/**
 * Testing code for non-server environment
 * emulation of some m2o callbacks and methods
 */

local handlers = {};
local commands = {};

function addEventHandler(event, cb) {
    handlers[event] <- cb;
}

function triggerServerEvent(event, p1 = null, p2 = null, p3 = null, p4 = null) {
    if (event in handlers) {
        if (p4) handlers[event](p1, p2, p3, p4);
        else if (p3) handlers[event](p1, p2, p3);
        else if (p2) handlers[event](p1, p2);
        else if (p1) handlers[event](p1);
        else handlers[event]();
    }
}

function removeEventHandler(event, func) {
    delete handlers[event];
}

function addCommandHandler(name, callback) {
    commands[name] <- callback;
}

function triggerCommand(name, p1 = null, p2 = null, p3 = null, p4 = null) {
    ::print("- calling command /" + name + "\n");
    if (p4) commands[name](p1, p2, p3, p4);
    else if (p3) commands[name](p1, p2, p3);
    else if (p2) commands[name](p1, p2);
    else if (p1) commands[name](p1);
    else commands[name]();
}

function sendPlayerMessage(playerid, text) {
    ::print(text + "\n");
}

function kickPlayer(id) {
    ::print("player kicked\n");
}

function getPlayerName(playerid) {
    return "Some_Name";
}

local queries = {};

queries["SELECT * FROM `tbl_accounts` WHERE `username` = 'Some_Name'"] <- null; // undergisted
// queries["SELECT * FROM `tbl_accounts` WHERE `username` = 'Some_Name'"] <- [{ _uid = 1, _entity = "Account", username = "Some_Name", password = "123123" }];
queries["INSERT INTO `tbl_accounts` (`_entity`,`password`,`username`) VALUES ('Account','123123','Some_Name'); SELECT LAST_INSERT_ID() as id;"] <- [{ id = 1}];

addEventHandler("__networkRequest", function(request) {
    if (request.data.destination == "database") {
        ::print("- incoming query: " + request.data.query + "\n");
        Response({result = (request.data.query in queries ? queries[request.data.query] : null) }, request).send();
    }
});

addEventHandler("__resourceLoaded", function(a) {
    dofile("resources/auth/server/commands.nut", true);
    // debug
    triggerServerEvent("onPlayerConnect", 1, "Some_Name", 1, 1);
    // triggerCommand("register", 1, "123123");
    // triggerCommand("login", 1, "123123");
});
