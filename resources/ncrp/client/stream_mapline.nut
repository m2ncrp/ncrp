addEventHandler("activateStreamMapLine", function () {
    log("load " + executeLua("game.sds:ActivateStreamMapLine(\"marker_load\")"));
});