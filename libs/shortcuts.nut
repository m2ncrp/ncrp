_server_commands <- {};

function cmd(names, func)  {
    if (typeof names != "array") {
        names = [names];
    }
    foreach(name in names) {
        _server_commands[name] <- func;
        addCommandHandler(name, func);
    }
}
