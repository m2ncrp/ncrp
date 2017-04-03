local module_log = require("./log");

module.exports = function(string, ...) {
    local params = vargv;

    params.insert(0, getroottable());
    params.insert(1, string);

    module_log(format.acall(params));
};
