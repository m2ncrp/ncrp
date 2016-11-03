include("controllers/time/commands.nut");

// number of senconds from 01.01.2012
const DEFAULT_TIMESTAMP     = 1325368800;
const DEFAULT_SHAPSHOT_ID   = 1;
const DEFAULT_SAVE_INTERVAL = 10;

// create storage
local ticker = null;
local entity = null;
local CURRENT_TIMESTAMP = DEFAULT_TIMESTAMP;
local CURRENT_OPERATION = 0;

// registering handlers
addEventHandler("onScriptInit", function() {
    log("[time] starting time ...");

    TimestampStorage.findOneBy({ id = DEFAULT_SHAPSHOT_ID }, function(err, result) {
        if (err || !result) {
            return log("[time] no time results are stored, creating new entry...");
        }

        CURRENT_TIMESTAMP = result.timestamp;
        CURRENT_OPERATION = result.operation;

        entity = result;
    });

    // validate
    if (!entity) {
        entity = TimestampStorage();
    }

    // crate objects
    ticker = timer(onTimestampTick, 1000, -1);
});

addEventHandlerEx("onServerStopping", function() {
    saveCurrentTimestampTick();

    // reset objects
    ticker.Kill();
    ticker = null;
});

/**
 * Time ticker
 */
function onTimestampTick() {
    CURRENT_TIMESTAMP++;
    CURRENT_OPERATION = 0;

    if ((CURRENT_TIMESTAMP % DEFAULT_SAVE_INTERVAL) == 0) {
        saveCurrentTimestampTick();
    }

    return true;
}

/**
 * Saving current ticks
 */
function saveCurrentTimestampTick() {
    entity.timestamp = CURRENT_TIMESTAMP;
    entity.operation = CURRENT_OPERATION;
    entity.save();
};

/**
 * Return current timestamp
 * in seconds
 *
 * Started from (01.01.2012)
 *
 * @return {integer}
 */
function getTimestamp() {
    return CURRENT_TIMESTAMP;
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
