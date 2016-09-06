dofile("libs/index.nut", true);

local connection = null;

addEventHandler("onScriptInit", function() {
    log("starting database");

    connection = sqlite("ncrp.db");

    // trigger creation of database tables
    Account().createTable();
});

addEventHandler("onScriptExit", function() {
    log("stopping database");
    connection.close();
});

addEventHandler("__networkRequest", function(request) {
    if (request.data.destination == "database") {
        local result = connection.query(request.data.query);
        Response({result = result}, request).send();
    }
});
