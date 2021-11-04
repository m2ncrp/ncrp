acmd("draw", function(playerid, type) {
		if ((type != "vehicles") && (type != "players")) return msg(playerid, "Некорректное значение", CL_THUNDERBIRD);
        local setting = getSettingsValue(type + "Drawer");
        local color = CL_CHESTNUT2;
        if (setting){
        	setting = false
        } else {
        	setting = true;
        	color = CL_SUCCESS;
        }
        foreach (targetid, name in players) {
        	triggerClientEvent(targetid, "toggle" + type.slice(0,1).toupper() + type.slice(1) + "Drawer", setting);
        	setSettingsValue(type + "Drawer", setting);
        }
        msg(playerid, "Установлено значение %s для отрисовки %s", [setting.tostring(), type], color);
});

event("onServerPlayerStarted", function(playerid) {
    local vehicles = getSettingsValue("vehiclesDrawer")
    local players = getSettingsValue("playersDrawer")
    triggerClientEvent(playerid, "toggleVehiclesDrawer", vehicles);
    triggerClientEvent(playerid, "togglePlayersDrawer", players);
});