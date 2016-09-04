local handlers = {};

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

dofile("debug.nut", true);
dofile("network.nut", true);


addEventHandler("__networkRequest", function(request) {
    if (request.data.destination == "database") {
        local result = "abababa" + request.data.query;
        Response({result = result}, request).send();
    }
});
function callback(d, a) {
::print(a);
}

function run() {
    local request = Request({ destination = "database", query = "___das" });

    request.onResponse(function(response) {
        if (callback) {
            callback( null, response.data.result );
        }
    });

    return request.send();
}

run();
