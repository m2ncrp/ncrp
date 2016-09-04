local connection = null;

addEventHandler("onScriptInit", function() {
    log("starting database");
    connection = sqlite("ncrp.db");
});

addEventHandler("__networkRequest", function() {
    if (request.data.destination == "database") {
        local result = connection.query(request.data.query);
        Response({result: result}, request).send();
    }
});

addEventHandler("onScriptExit", function() {
    log("stopping database");
    connection.close();
});
