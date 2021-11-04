acmd("streamer", function(playerid, type, state) {
        if (((type != "vehicles") && (type != "players")) || ((state != "true") && (state != "false"))) return msg(playerid, "Некорректное значение", CL_THUNDERBIRD);
        local setting = getSettingsValue(type + "Drawer");
        if (setting.tostring() == state) {
            return msg(playerid, "Такое значение для отрисовки %s уже установлено", type, CL_THUNDERBIRD)
        } else {
            setting = ((state == "true") ? true : false);
            dbg(setting);
        }
        foreach (targetid, name in players) {
            triggerClientEvent(targetid, "toggle" + type.slice(0,1).toupper() + type.slice(1) + "Drawer", setting);
            setSettingsValue(type + "Drawer", setting);
        }
        msg(playerid, "Установлено значение %s для отрисовки %s", [setting.tostring(), type], (setting ? CL_SUCCESS : CL_CHESTNUT2));
});

event("onServerPlayerStarted", function(playerid) {
    local vehicles = getSettingsValue("vehiclesDrawer")
    local players = getSettingsValue("playersDrawer")
    triggerClientEvent(playerid, "toggleVehiclesDrawer", vehicles);
    triggerClientEvent(playerid, "togglePlayersDrawer", players);
});
