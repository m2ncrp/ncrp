key("e", function(playerid) {
    local kioskFound = isPlayerNearKiosk(playerid);
    if (!kioskFound) return;
    players[playerid].trigger("showShopGUI", selectShopAssortment("kiosk"), getPlayerLocale(playerid));
    players[playerid].inventory.show(playerid);
});
