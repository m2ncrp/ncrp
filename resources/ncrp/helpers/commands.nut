_server_commands <- {};

local old__addCommandHandler = addCommandHandler;

function cmd(names, func)  {
    if (typeof names != "array") {
        names = [names];
    }
    foreach(name in names) {
        _server_commands[name] <- func;
        old__addCommandHandler(name, func);
    }
}

/**
 * Register an admin command
 */
function acmd(names, func)  {
    if (typeof names != "array") {
        names = [names];
    }
    foreach(name in names) {
        _server_commands[name] <- func;
        old__addCommandHandler(name, func);
    }
}


addCommandHandler = cmd;
