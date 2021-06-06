key("e", function(playerid) {
    local kioskFound = isPlayerNearKiosk(playerid);
    if (!kioskFound) return;
    players[playerid].trigger("showShopGUI", selectShopAssortment("kiosk"), getPlayerLocale(playerid));
    players[playerid].inventory.show(playerid);
});

acmd("kiosk", function(playerid, id) {
    id = id.tointeger();
    local kioskPos = getKioskPosition(id);
    if (kioskPos) {
        setPlayerPosition(playerid, kioskPos[0], kioskPos[1], kioskPos[2]);
    }
})
