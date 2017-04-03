local module_log = require("./log");

module.exports = function(string, ...) {
    local params = vargv;

    params.insert(getroottable(), 0);
    params.insert(string, 1);

    module_log.acall(params);
};
