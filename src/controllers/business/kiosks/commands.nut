key("e", function(playerid) {
    local kiosk = isPlayerNearKiosk(playerid);
    if (!kiosk) return;
    players[playerid].trigger("showShopGUI", selectShopAssortment("kiosk"), getPlayerLocale(playerid), kiosk.name);
    players[playerid].inventory.show(playerid);
});

acmd("kiosk", function(playerid, id) {
    id = id.tointeger() - 1;
    local kioskPos = getKioskPosition(id);
    if (kioskPos) {
        setPlayerPosition(playerid, kioskPos.public[0], kioskPos.public[1], kioskPos.public[2]);
    }
})
