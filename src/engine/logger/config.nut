local settings = {
    callback = function(data) { ::print(data + "\n"); },
};

module.exports = {
    use = function(callback) {
        settings.callback = callback;
    },

    call = function(data) {
        return settings.callback(data);
    },
};
