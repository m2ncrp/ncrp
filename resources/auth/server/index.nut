dofile("libs/index.nut", true);

/**
 * Storage for our sessions
 * no direct acess
 *
 * for access from remote resources use:
 *     Account.getSession(playerid, callback)
 *     Account.addSession(playerid)
 */
accounts <- {};

/**
 * Compiled regex object for
 * validation of usernames
 * @type {Object}
 */
local REGEX_USERNAME = regexp("([A-Za-z0-9]{1,32}_[A-Za-z0-9]{1,32})")

/**
 * On player connects we will
 * check his nickname for validity
 * and then we will show him
 * screen with different text
 * depending if he is logined or not
 */
addEventHandler("onPlayerConnect", function(playerid, username, ip, serial) {
    if (!REGEX_USERNAME.match(username)) { return kickPlayer(playerid); }

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

/**
 * On player disconnects
 * we will clean up all his data
 */
addEventHandler("onPlayerDisconnect", function(playerid, reason) {
    if (!(playerid in accounts)) return;

    // clean up data for GC
    accounts[playerid].clean();
    accounts[playerid] = null;

    delete accounts[playerid];
});

/**
 * Cross resource handling
 */
addEventHandlerEx("__networkRequest", function(request) {
    local data = request.data;

    // we are working with current resource
    if (!("destination" in data) || data.destination != "auth") return;

    if (data.method == "getSession") {
        ::log("- getting session for player #" + data.id + "\n");
        Response({result = data.id in accounts ? accounts[data.id] : null}, request).send();
    }

    if (data.method == "addSession") {
        ::log("- adding session for player #" + data.id + "\n");
        accounts[data.id] <- data.object;
    }
});


// database code
local connection = null;

addEventHandler("onScriptInit", function() {
    ::log("starting database");

    connection = sqlite("ncrp.db");

    // trigger creation of database tables
    Account().createTable().execute();

    // testing
    // triggerServerEventEx("onPlayerConnect", 1, "John_Doe", 1, 1);
    // _server_commands["register"](1, "123456");
});

addEventHandler("onScriptExit", function() {
    ::log("stopping database");
    connection.close();
});

/**
 * Main database handler
 * manages all database requrests
 */
addEventHandlerEx("__networkRequest", function(request) {
    if (!("destination" in request.data)) return;

    if (request.data.destination == "database") {
        local result = [];
        local tmp = connection.query(request.data.query);
        
        // manuanlly push sqlite forced last inserted id after insert
        if (request.data.query.slice(0, 6).toupper() == "INSERT") {
            tmp = connection.query("select last_insert_rowid() as id");
        }

        // override empty result
        if (!tmp) tmp = [];

        // override tmp indexes
        foreach (idx, value in tmp) {
            result.push(value);
        }

        // log query and result
        ::log("Incoming SQL request: " + request.data.query);
        dbg(result);

        Response({result = result}, request).send();
    }
});
