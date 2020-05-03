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