include("controllers/database/migrations.nut");

// database code
local connection = null;

// debug settings
const IS_DATABASE_DEBUG = false;

addEventHandler("onScriptInit", function() {
    ::log("[database] creating connection...");

    connection = sqlite("ncrp.db");

    applyMigrations(connection);

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
 * Setting up ORM proxier
 * All db requests will be forwarded to database resource
 *
 * @param  {String} queryString compiled request string
 * @param  {Function} callback which will be called
 */
ORM.Driver.setProxy(function(queryString, callback) {
    local result = [];
    local tmp = connection.query(queryString);

    // log query and result
    if (IS_DATABASE_DEBUG) {
        ::log("Incoming SQL request: " + queryString);
        dbg(tmp);
    }

    // manuanlly push sqlite forced last inserted id after insert
    if (queryString.slice(0, 6).toupper() == "INSERT") {
        tmp = connection.query("select last_insert_rowid() as id");
    }

    // override empty result
    if (!tmp) tmp = [];

    // override tmp indexes
    foreach (idx, value in tmp) {
        result.push(value);
    }

    return callback ? callback(null, result) : null;
});

ORM.Driver.configure({
    provider = "sqlite"
});



// /**
//  * Setting up ORM proxier
//  * All db requests will be forwarded to database resource
//  *
//  * @param  {String} queryString compiled request string
//  * @param  {Function} callback which will be called
//  */
// ORM.Driver.setProxy(function(queryString, callback) {
//     local request = Request({ destination = "database", query = queryString });

//     request.onResponse(function(response) {
//         return callback ? callback( null, response.data.result ) : null;
//     });

//     return request.send();
// });

// ORM.Driver.configure({
//     provider = "sqlite"
// });

// /**
//  * Main database handler
//  * manages all database requrests
//  */
// addEventHandlerEx("__networkRequest", function(request) {
//     if (!("destination" in request.data)) return;

//     if (request.data.destination == "database") {
//         local result = [];
//         local tmp = connection.query(request.data.query);

//         // log query and result
//         if (IS_DATABASE_DEBUG) {
//             ::log("Incoming SQL request: " + request.data.query);
//             dbg(tmp);
//         }

//         // manuanlly push sqlite forced last inserted id after insert
//         if (request.data.query.slice(0, 6).toupper() == "INSERT") {
//             tmp = connection.query("select last_insert_rowid() as id");
//         }

//         // override empty result
//         if (!tmp) tmp = [];

//         // override tmp indexes
//         foreach (idx, value in tmp) {
//             result.push(value);
//         }

//         Response({result = result}, request).send();
//     }
// });
