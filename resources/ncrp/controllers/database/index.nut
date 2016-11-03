// database code
local connection = null;

addEventHandler("onScriptInit", function() {
    ::log("[database] creating connection...");

    connection = sqlite("ncrp.db");

    // sendPlayerMessage = function(id, argument) {
    //     ::print(argument);
    // }

    // // testing
    // triggerServerEventEx("onPlayerConnect", 1, "John_Doe", "256.256.256.256", "SERIAL");
    // _server_commands["register"](1, "123456");
});

addEventHandlerEx("onServerStopped", function() {
    ::log("[database] stopping...");
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
