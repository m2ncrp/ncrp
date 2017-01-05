include("controllers/time/commands.nut");

local CURRENT_OPERATION = 0;

/**
 * Return current timestamp
 * in seconds
 *
 * @return {integer}
 */
function getTimestamp() {
    return time();
}

/**
 * Return current timestamp
 * in seconds.operations
 *
 * Started from (01.01.2012)
 *
 * @return {float}
 */
function getTimestampMili() {
    return (getTimestamp().tostring() + (++CURRENT_OPERATION * 0.001).tostring().slice(1));
}
