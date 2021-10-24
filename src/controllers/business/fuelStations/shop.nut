local JERRYCAN_COST = 14.0;
local TOOLKIT_COST = 14.0;
local MINI_MARKET_BUY_RADIUS = 4.0;

local coords = getFuelStationsCoords();

event("onServerPlayerStarted", function(playerid) {
    foreach (name, station in coords) {
        createPrivate3DText(playerid, station.shop[0], station.shop[1], station.shop[2]+0.35, plocalize(playerid, "MINI-MARKET"), CL_RIPELEMON, MINI_MARKET_BUY_RADIUS);
        createPrivate3DText(playerid, station.shop[0], station.shop[1], station.shop[2]+0.20, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(150), 1.0);
    }
});

function fuelStationMiniMarket(playerid) {
    dbg("fuelStationMiniMarket")
    local station = isPlayerNearFuelStation(playerid);
    if (!station) return;
    players[playerid].trigger("showShopGUI", selectShopAssortment("fuelStation"), getPlayerLocale(playerid), station.name);
    players[playerid].inventory.show(playerid);
}
