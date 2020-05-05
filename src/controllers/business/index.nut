include("controllers/business/fuelStations");

local businesses = {};

function loadBusiness(business) {
    businesses[business.id] <- business;

    if(business.subtype == "FuelStation") {
        loadFuelStation(business);
    }
}

function getBusiness() {
    return businesses;
}

function getPlayerBizCount(playerid) {
    local charid = getCharacterIdFromPlayerId(playerid);
    local count = 0;
    foreach(idx, biz in businesses) {
        if (biz.ownerid == charid) count++;
    }
    return count;
}