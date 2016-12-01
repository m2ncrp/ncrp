// create storage for commands
__commands <- {};

// define constants
const COMMANDS_DEFAULT = "__default";

// remap old addCommandHandler
local old__addCommandHandler = addCommandHandler;

/**
 * Register command handler for any given command name
 *     or array of command names (aliases)
 * Example: cmd("taxi", ... OR cmd(["taxi", "tx"], ...
 *
 * Second argument can be either callback (command handler)
 *     or array of strings, or single string, describing sequence for the command
 * Example:
 *     cmd("taxi", "call", ...
 *     cmd(["taxi"], ["call", "now"], ...
 *     cmd("taxi", function(....
 *
 * Third argument is null by default and sholud be a function
 * if second one was an array|string
 *
 *
 * @param  {array|string} aliases Can be string or array of strings
 * @param  {function|string|array} extensionOrCallback
 * @param  {function} callbackOrNull
 * @return {bool} true
 */
function advancedCommand(isAdmin, aliases, extensionOrCallback, callbackOrNull = null) {
    // create storage
    local cmdnames  = [];
    local extension = [];
    local callback  = null;

    // load aliases
    if (typeof aliases != "string") {
        if (typeof aliases == "array") {
            cmdnames = aliases.map(function(item) {
                return item.tostring();
            });
        } else {
            throw "cmd: First argument should be either 'string' or 'array' of 'strings'"
        }
    } else {
        cmdnames = [aliases];
    }

    // validate callback
    if (typeof extensionOrCallback != "function" && !callbackOrNull) {
        throw "cmd: Second argument should be either 'function' or 'array' + 'function'";
    }

    // load extension and callback
    if (typeof extensionOrCallback == "function") {
        callback = extensionOrCallback;
    } else if (typeof extensionOrCallback == "array") {
        callback  = callbackOrNull;
        extension = extensionOrCallback;
    } else if (typeof extensionOrCallback == "string") {
        callback  = callbackOrNull;
        extension = [extensionOrCallback];
    } else {
        throw "cmd: Second argument should be either 'function' or 'array' + 'function'";
    }

    // function to register new command
    local handler = function(cmdname, playerid, args) {
        local cursor = __commands[cmdname];
        local cmdlog = "/" + cmdname;

        // check if player is logined
        if (!isPlayerLogined(playerid)) {
            return msg(playerid, "auth.error.cmderror", CL_ERORR);
        }

        // if its admin command, and player is not admin - exit
        if (isAdmin && !isPlayerAdmin(playerid)) {
            return;
        }

        // iterate over arguments
        // and try to find appropriate sequence
        while (args.len() > 0 && args[0] in cursor) {
            cmdlog += " " + args[0];
            cursor = cursor[args[0]];
            args   = args.slice(1);
        }

        if (COMMANDS_DEFAULT in cursor && typeof cursor[COMMANDS_DEFAULT] == "function") {
            // apply custom arguments
            args.insert(0, getroottable());
            args.insert(1, playerid);

            // call registered handler
            cursor[COMMANDS_DEFAULT].acall(args);
        } else {
            log("[cmd] trying to call an undefined command: " + cmdlog);
        }
    };

    // iterate over commands and apply
    foreach (command in cmdnames) {
        if (!(command in __commands)) {
            __commands[command] <- {};

            // bind handler generator
            local subhandler = function(cmdvalue) {
                return function(playerid, ...) {
                    return handler(cmdvalue, playerid, vargv);
                }
            };

            // bind subhandler
            old__addCommandHandler(command, subhandler(command));
        }

        // create iterator
        local cursor = __commands[command];

        // iterate over nested structure
        foreach (level in extension) {
            if (!(level in cursor)) {
                cursor[level] <- {};
            }
            cursor = cursor[level];
        }

        // save callback
        cursor[COMMANDS_DEFAULT] <- callback;
    }

    // just true :p
    return true;
}

/**
 * Testing
 */

// asd <- {};
// old__addCommandHandler <- function(a, b) {
//     asd[a] <- b;
// }

// cmd("a1", function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });

// cmd(["a2"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });

// cmd(["a3", "a_3"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });



// cmd("a4", ["b1"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });

// cmd(["a5"], ["b2"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });

// cmd(["a6", "a_6"], ["b3"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });


// cmd("a7", ["b4", "c4"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });

// cmd(["a8"], ["b5", "c5"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });

// cmd(["a9", "a_9"], ["b6", "c6"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });


// cmd(["a10", "a_10"], ["b6", "c6", "a", "b", "c"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });

// cmd("a1", ["test"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });

// cmd("a1", ["dest"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });

// cmd("a1", ["test", "a"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });

// cmd("a1", ["test", "b"], function(playerid, test) {
//     print(format("command from %d with value: %s\n", playerid, test));
// });

// asd["a1"](15, "inl");
// asd["a2"](15, "inl");
// asd["a3"](15, "inl");
// asd["a_3"](15, "inl");
// asd["a4"](15, "b1", "inl");
// asd["a5"](15, "b2", "inl");
// asd["a6"](15, "b3", "inl");
// asd["a_6"](15, "b3", "inl");
// asd["a7"](15, "b4", "c4", "inl");
// asd["a8"](15, "b5", "c5", "inl");
// asd["a9"](15, "b6", "c6", "inl");
// asd["a_9"](15, "b6", "c6", "inl");

// asd["a10"](15, "b6", "c6", "a", "b", "c", "inl");
// asd["a_10"](15, "b6", "c6", "a", "b", "c", "inl");

// asd["a1"](15, "tzt");
// asd["a1"](15, "dest", "tzt");
// asd["a1"](15, "test", "tzt");
// asd["a1"](15, "test", "a", "tzt");
// asd["a1"](15, "test", "b", "tzt");
// // asd["a1"](15, "dest", "a", "tzt");

// default command
function cmd(...) {
    vargv.insert(0, getroottable());
    vargv.insert(1, false);
    advancedCommand.acall(vargv);
}

// admin command
function acmd(...) {
    vargv.insert(0, getroottable());
    vargv.insert(1, true);
    advancedCommand.acall(vargv);
}


simplecmd <- old__addCommandHandler;
addCommandHandler <- cmd;
