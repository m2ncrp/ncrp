/**
 * Testing code for non-server environment
 * emulation of some m2o callbacks and methods
 */


local __handlers = {};

function addEventHandlerEx(event, cb) {
    if (event in __handlers) {
        return __handlers[event].push(cb);
    }

    __handlers[event] <- [cb];
}

function triggerServerEventEx(event, p1 = "_default", p2 = "_default", p3 = "_default", p4 = "_default") {
    if (event in __handlers) {
        foreach (idx, handler in __handlers[event]) {
            if (p4 != "_default") handler(p1, p2, p3, p4);
            else if (p3 != "_default") handler(p1, p2, p3);
            else if (p2 != "_default") handler(p1, p2);
            else if (p1 != "_default") handler(p1);
            else handler();
        }
    }
}

function removeEventHandlerEx(event, func) {
    __handlers[event].remove(__handlers[event].find(func));
}




class Request {
    data = null;
    signature = null;
    handler = null;

    constructor (data) {
        this.data = data;
        this.signature = this.getSign();
    }

    function getSign() {
        local set = {};
        
        set.a <- this.tostring();
        set.b <- this.data.tostring();
        set.a = set.a.slice(13, -1);
        set.b = set.b.slice(13, -1);

        this.signature = set.a + set.b;
        return this.signature;
    }

    function getData() {
        return this.data;
    }

    function send() {
        triggerServerEventEx("__networkRequest", this);
    }

    function clean() {
        this.handler = null;
        this.data = null;
        this.signature = null;
    }

    function onResponse(callback) {
        local self = this;

        self.handler = function(response) {
            // If result origin not equal to caller - exit
            if (self.signature == response.request.signature) {
                removeEventHandlerEx("__networkResponse", self.handler);
                callback(response);
                self.clean();
            }
        }

        addEventHandlerEx("__networkResponse", self.handler);
    }
};


class Response extends Request {
    request = null;

    constructor(data, request) {
        base.constructor(data);
        this.request = request;
    }

    function clean() {
        base.clean();
        this.request = null;
    }

    function send() {
        triggerServerEventEx("__networkResponse", this);
        this.clean();
    }
};
