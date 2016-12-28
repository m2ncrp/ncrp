include("controllers/database/migrations.nut");

// database code
local connection = null;
local settings = {};

// debug settings
IS_DATABASE_DEBUG   <- false;
IS_MYSQL_ENABLED    <- false;

addEventHandler("onScriptInit", function() {
    ::log("[database] trying to read mysql settings...")
    IS_MYSQL_ENABLED = readMysqlSettings();

    if (IS_MYSQL_ENABLED && !("mysql_connect" in getroottable())) {
        dbg("database", "mysql failed to load. skipping .mysql settings and falling back to sqlite");
        IS_MYSQL_ENABLED = false;
    }

    ::log("[database] creating connection...");
    if (IS_MYSQL_ENABLED) {
        dbg("database", "mysql", "connecting with settings", settings);
        connection = mysql_connect(settings.hostname, settings.username, settings.password, settings.database);

        if (mysql_ping(connection)) {
            intializeMySQLDDrivers();
        } else {
            IS_MYSQL_ENABLED <- false;
            dbg("database", "mysql", "failed to connect, falling back to sqlite");
        }
    }

    if (!IS_MYSQL_ENABLED) {
        dbg("database", "sqlite", "connecting");
        connection = sqlite("ncrp.db");
        intializeSQLiteDrivers();
    }

    applyMigrations(connection);
});

addEventHandlerEx("onServerStopped", function() {
    ::log("[database] stopping...");
    if (IS_MYSQL_ENABLED) {
        connection.close();
    } else {
        mysql_close(connection);
    }
});

function intializeSQLiteDrivers() {
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
            dbg("database", "sql", queryString);
            dbg("database", "result", tmp);
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
}

function intializeMySQLDDrivers() {
    /**
     * Setting up ORM proxier
     * All db requests will be forwarded to database resource
     *
     * @param  {String} queryString compiled request string
     * @param  {Function} callback which will be called
     */
    ORM.Driver.setProxy(function(queryString, callback) {
        local result = [];
        local query = mysql_query(connection, queryString);

        // log query and result
        if (IS_DATABASE_DEBUG) {
            dbg("database", "sql", queryString);
        }

        local row = {};

        // // manuanlly push sqlite forced last inserted id after insert
        if (queryString.slice(0, 6).toupper() == "INSERT") {
            result.push({ id = mysql_insert_id(connection) });
        } else {
            while(row = mysql_fetch_assoc(query)) {
                result.push(row);
            }
        }

        // Free the results
        mysql_free_result( query );

        return callback ? callback(null, result) : null;
    });

    ORM.Driver.configure({
        provider = "mysql"
    });
}

/**
 * Try to read mysql settings for the file
 * ".mysql" into global "settings" variable
 * @return {Boolean} [description]
 */
function readMysqlSettings() {
    try {
        local myblob = file(".mysql", "r");
        local buffer = "";
        local key;

        // try to read data from version
        for (local i = 1; i < myblob.len() + 1; ++i) {
            local symbol = myblob.readn('b').tochar();

            if (symbol == '='.tochar()) {
                key = buffer;
                buffer = "";
            } else if (symbol == '\n'.tochar()) {
                settings[key] <- buffer;
                buffer = "";
            } else {
                buffer += symbol;
            }

            myblob.seek(i);
        }

        myblob.close();

        return (
            "hostname" in settings && "username" in settings &&
            "password" in settings && "database" in settings
        );
    }
    catch (e) {
        return false;
    }
}



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
