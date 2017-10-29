local closedplaces = [];
local closedplaces_respawn = {};
local coords_a = null;
local coords_b = null;
local coords_r = null;

acmd("cl", "a", function(playerid) {
    coords_a = getPlayerPosition(playerid);
    msg(playerid, "Point 1 has been added. Add point 2 and create place: /cl b");
});


acmd("cl", "b", function(playerid) {
    coords_b = getPlayerPosition(playerid);
    msg(playerid, "Point 2 has been added. Go to respawn point and create place: /cl add NAME");
});


acmd("cl", "add", function(playerid, name = null) {
    coords_r = getPlayerPosition(playerid);
    if(coords_a == null || coords_b == null || coords_r == null) return msg(playerid, "Before set point 1 and point 2: /cl a");
    if(!name) return msg(playerid, "Need enter name.");
    local nameCreate = "closed_"+name;
    if(closedplaces.find(nameCreate)) return msg(playerid, "This name already exists. Need unique name.");


    createPlace(nameCreate, coords_a[0], coords_a[1], coords_b[0], coords_b[1]);
    closedplaces.push(nameCreate);
    closedplaces_respawn[nameCreate] <- coords_r;

    msg(playerid, format("Place %s has been created.", name));

    coords_a = null;
    coords_b = null;
    coords_r = null;
});


acmd("cl", "del", function(playerid, name = null) {
    if(!name) return msg(playerid, "Need enter name.");
    local nameDelete = "closed_"+name;
    local check = closedplaces.find(nameDelete);
    if(check == null) return msg(playerid, "This name doesn't exists.");
    removePlace(nameDelete);
    closedplaces.remove(check);
    closedplaces_respawn[nameDelete].clear();
    msg(playerid, format("Place %s has been deleted.", name));
});


acmd("cl", "list", function(playerid) {
    if(closedplaces.len() == 0) return msg(playerid, "No closed place.");
    msg(playerid, "====== List of closed places =====");
    foreach (idx, value in closedplaces) {
        local visname = str_replace("closed_", "", value);
        msg(playerid, format("#%d. %s", idx, visname));
    }
});


event("onPlayerPlaceEnter", function(playerid, name) {
    if(name.find("closed_") == null) return;

    if (isPlayerInVehicle(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
        setVehiclePosition(vehicleid, closedplaces_respawn[name][0], closedplaces_respawn[name][1], closedplaces_respawn[name][2]+0.5 );
    } else {
        setPlayerPosition(playerid, closedplaces_respawn[name][0], closedplaces_respawn[name][1], closedplaces_respawn[name][2]);
    }
    msg(playerid, "closedplaces.thisis", CL_RED);
});


local translations = {
    "en|closedplaces.thisis"               :   "[WARNING] This place is temporarily closed"
    "ru|closedplaces.thisis"               :   "[ВНИМАНИЕ] Доступ на данную территорию временно закрыт!"
}
alternativeTranslate(translations);
