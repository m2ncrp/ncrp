_server_commands <- {};
_server_admin_commands <- {};

function cmd(names, func)  {
    if (typeof names != "array") {
        names = [names];
    }
    foreach(name in names) {
        _server_commands[name] <- func;
        addCommandHandler(name, func);
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
        _server_admin_commands[name] <- func;
        addCommandHandler(name, func);
    }
}
