__events <- {};

// saving old
local oldAddEventHandler = addEventHandler;
local oldClientTrigger   = triggerClientEvent;

original__addEventHandler <- addEventHandler;

/**
 * Method for proxying old events to new
 *
 * @param  {String} native
 * @param  {String} inner
 * @return {Booelan}
 */
function proxy(native, inner) {
    return oldAddEventHandler(native, function(...) {
        local args = clone vargv;

        args.insert(0, null);
        args.insert(1, inner);

        trigger.acall(args);
    });
}

/**
 * Register event handler
 *
 * @param  {String|Array<Strings>}   names
 * @param  {Function} callback
 * @return {Boolean}
 */
function event(names, callback) {
    if (typeof names != "array") {
        names = [names];
    }

    foreach (idx, name in names) {
        if (!(name in __events)) {
            __events[name] <- [];
        }

        __events[name].push(callback);
    }

    return true;
}

/**
 * Trigger server or client event
 * (if playerid is first argument, its a client event)
 *
 * For server event:
 * @param  {String} event name
 * [ @param  {Mixed} argument 1 ]
 * [ @param  {Mixed} argument 2 ]
 * ...
 * [ @param  {Mixed} argument N ]
 *
 * For client event:
 * @param  {Integer} playerid
 * @param  {String} event name
 * [ @param  {Mixed} argument 1 ]
 * [ @param  {Mixed} argument 2 ]
 * ...
 * [ @param  {Mixed} argument N ]
 *
 * @return {Boolean} if triggering succeded
 */
function trigger(...) {
    local args = clone vargv;
    args.insert(0, getroottable());

    // triggering client
    if (vargv.len() > 1 && typeof vargv[0] == "integer") {
        return oldClientTrigger.acall(args);
    }

    // triggering server event
    if (vargv.len() > 0 && typeof vargv[0] == "string") {
        if (vargv[0] in __events) {
            args.remove(1); // remove event name
            foreach (idx, callback in __events[vargv[0]]) {
                callback.acall(args);
            }

            return true;
        }
    }

    return false;
}

/**
 * Removes event listener by passed callback functions
 *
 * @param  {String} event
 * @param  {Function} func
 */
function removeEvent(event, func) {
    if (event in __events) {
        __events[event].remove(__events[event].find(func));
    }
}

/**
 * testing
 */

// evt("native:onPlayerConnect", function(p, a, s, d) {
//     print("called event with playerid: " + p + "\n");
// });

// evt("onCustom", function(p, a) {
//     print(p + a);
//     print("\n")
// });

// trigger(5, "onCustom", 5, 5);
// trigger("onCustom", 5, 4);

// proxy("onPlayerConnect", "native:onPlayerConnect");

// a["onPlayerConnect"](15, 1, 2, 3);

/**
 * Aliasing
 */
evt                  <- event;
addEventHandler      <- event;
addEventHandlerEx    <- event;
triggerServerEventEx <- trigger;
triggerClientEvent   <- trigger;
removeEventHandlerEx <- removeEvent;
