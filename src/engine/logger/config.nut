local settings = {
    callback = function(data) { ::print(data + "\n"); },
};

module.exports = {
    use = function(callback) {
        setting.callback = callback;
    },

    call = function(data) {
        return callback(data);
    },
};
