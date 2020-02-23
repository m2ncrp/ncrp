mcmd(["admin.restart"], "uc", function(playerid, status) {
    setSettingsValue("isUnderConstruction", status);
    return msg(playerid, "Технический перерыв %s", [status == "true" ? "начат" : "завершён"])
});