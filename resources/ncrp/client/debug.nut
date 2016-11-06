addEventHandler("onServerScriptEvaluate", function(code) {
    log("[debug] trying to evaluate script code;");
    log("[debug] code: " + code);

    local result = compilestring(format("return %s;", code))();

    log(result);
    sendMessage(result);
});
