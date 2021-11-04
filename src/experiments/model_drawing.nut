acmd("streamer", function(playerid, type, state) {
        if(["vehicles", "players"].find(type) == null || ["true", "false"].find(state) == null) return msg(playerid, "Некорректное значение", CL_THUNDERBIRD);
        local setting = getSettingsValue(type + "Drawer");
        if (setting.tostring() == state) {
            return msg(playerid, "Такое значение для отрисовки %s уже установлено", type, CL_THUNDERBIRD);
        };
        setting = ((state == "true") ? true : false);
        foreach (targetid, name in players) {
            triggerClientEvent(targetid, "toggle" + type.slice(0,1).toupper() + type.slice(1) + "Drawer", setting);
            setSettingsValue(type + "Drawer", setting);
        }
        msg(playerid, "Установлено значение %s для отрисовки %s", [state, type], (setting ? CL_SUCCESS : CL_CHESTNUT2));
});

event("onServerPlayerStarted", function(playerid) {
    triggerClientEvent(playerid, "toggleVehiclesDrawer", getSettingsValue("vehiclesDrawer"));
    triggerClientEvent(playerid, "togglePlayersDrawer", getSettingsValue("playersDrawer"));
});
