include("controllers/shops/carshop/commands.nut");
include("controllers/shops/carshop/functions.nut");

// constants
const CARSHOP_STATE_FREE = "free";
const CARSHOP_DISTANCE   = 5.0;

// translations
translation("en", {
    "shops.carshop.gotothere"     : "Hello there, %s! If you want to buy a car go to Diamond Motors!",
    "shops.carshop.welcome"       : "If you want to buy a car, you should first choose it via: /car list",
    "shops.carshop.nofreespace"   : "There is no free space near Parking. Please come again later!",
    "shops.carshop.money.error"   : "Sorry, you dont have enough money. Check your wallet with: /money",
    "shops.carshop.selectmodel"   : "You can browse vehicle models, and their prices via: /car list",
    "shops.carshop.list.title"    : "Select car you like, and proceed to buying via: /car buy <modelid>",
    "shops.carshop.list.entry"    : " - Model #%d, «%s». Cost: $%.2f",
    "shops.carshop.success"       : "Contratulations! You've successfuly bought a car. Fare you well!",
});

event("onServerStarted", function() {
    return carShopCreatePlace();
});

event("onPlayerVehicleEnter", function(playerid, vehiclid, seat) {
    return carShopFreeCarSlot(playerid, vehiclid);
});

event("onServerMinuteChange", function() {
    return carShopCheckFreeSpace();
});
