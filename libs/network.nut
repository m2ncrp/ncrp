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
        triggerServerEvent("__networkRequest", this);
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
                removeEventHandler("__networkResponse", self.handler);
                callback(response);
                self.clean();
            }
        }

        addEventHandler("__networkResponse", self.handler);
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
        triggerServerEvent("__networkResponse", this);
        this.clean();
    }
};
