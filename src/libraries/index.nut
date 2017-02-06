try { return _IS_LOADED; } catch (e) { _IS_LOADED <- true; }
__DEBUG__EXPORT <- false;

/**
 * Updated module includer script version
 * throws exceptions if module was not found
 * returns true if module was loaded
 *
 * If ".nut" was not found in the path,
 * "/index.nut" will be concatenated to path
 *
 * @param  {String} path
 * @return {Boolean}
 */
function include(path) {
    if (!path.find(".nut")) {
        path += "/index.nut";
    }

    try {
        return dofile("src/" + path, true) || true;
    } catch (e) {
        throw "\n============================\nSystem: File inclusion error\n(wrong filename or error in the file): " + path;
    }
}

// load libs
include("libraries/squirrel-orm.nut");
// include("libraries/network.nut");
include("libraries/JSONEncoder.class.nut");
include("libraries/JSONParser.class.nut");
include("libraries/debug.nut");

if (__DEBUG__EXPORT) {
    addEventHandler <- function(...) {};
    addCommandHandler <- function(...) {};
    createVehicle <- function(...){};
}
