const DEBUG_ENABLED = true;

/**
 * Function that logs to server console
 * provided any number of provided values
 *
 * @param  {...}  any number of arguments
 * @return none
 */
function log(...) {
    return ::print(JSONEncoder.encode(vargv).slice(2).slice(0, -2));
};


/**
 * Function that logs to server console
 * provided any number of provided values
 * NOTE: addes prefix [debug] in front of output
 *
 * @param  {...}  any number of arguments
 * @return none
 */
function dbg(...) {
    return DEBUG_ENABLED ? ::print("[debug] " + JSONEncoder.encode(vargv).slice(2).slice(0, -2)) : null;
}

