local handlers = {};
local commands = {};

function addEventHandler(event, cb) {
    handlers[event] <- cb; 
}

function triggerEvent(event, data) {
    if (event in handlers) {
        handlers[event](data);
    }
}

function removeEventHandler(event, func) {
    delete handlers[event];
}

function addCommandHandler(name, callback) {
    commands[name] <- callback;
}
