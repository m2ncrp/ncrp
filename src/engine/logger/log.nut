local config = require("./config");

module.exports = function(string) {
    config.call("[log]" + string);
};
