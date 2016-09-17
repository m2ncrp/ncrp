try { return _IS_LOADED; } catch (e) { _IS_LOADED <- true; }

/**
 * Updated module includer script version
 * throws exceptions if module was not found
 * returns true if module was loaded
 * @param  {String} path
 * @return {Boolean}
 */
local function loadDep(path) {
    try {
        return dofile("dependencies/" + path, true) || true;
    } catch (e) {
        throw "System: File inclusion error (wrong filename or error in the file): dependencies/" + path;
    }
}

function include(path) {
    try {
        return dofile("resources/ncrp/" + path, true) || true;
    } catch (e) {
        throw "System: File inclusion error (wrong filename or error in the file): ncrp/" + path;
    }
}

// load libs
loadDep("squirrel-orm.nut");
loadDep("network.nut");
loadDep("Shortcuts/shortcuts.nut");

// load traits
loadDep("Traits/Colorable.nut");

// load models
loadDep("InternalModels/Account.nut");
loadDep("InternalModels/Character.nut");
loadDep("InternalModels/Vehicle.nut");

// testing (mac)
loadDep("debug.nut");

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

ORM.Driver.configure({
    provider = "sqlite"
});
