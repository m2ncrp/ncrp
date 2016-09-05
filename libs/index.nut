try { return _IS_LOADED; } catch (e) { _IS_LOADED <- true; }

/**
 * Updated module includer script version
 * throws exceptions if module was not found
 * returns true if module was loaded
 * @param  {String} path
 * @return {Boolean}
 */
local function inlcude(path) {
    try {
        dofile(__FILE__.slice(0, -9) + path, true);
        return true;
    } catch (e) {
        throw "System: File inclusion error (wrong filename or error in the file): " + __FILE__.slice(0, -9) + path;
    }
}

// load libs
inlcude("squirrel-orm/lib/index.nut");
inlcude("network.nut");
inlcude("shortcuts.nut");

// load models
inlcude("models/account.nut");

// testing (mac)
inlcude("test.nut");

/**
 * Setting up ORM proxier
 * All db requests will be forwarded to database resource
 * 
 * @param  {String} queryString compiled request string
 * @param  {Function} callback which will be called
 */
ORM.Driver.setProxy(function(queryString, callback) {
    local request = Request({ destination = "database", query = queryString });

    request.onResponse(function(response) {
        return callback ? callback( null, response.data.result ) : null;
    });

    return request.send();
});
