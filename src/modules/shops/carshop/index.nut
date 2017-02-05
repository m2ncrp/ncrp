// constants
const CARSHOP_STATE_FREE = "free";
const CARSHOP_DISTANCE   = 5.0; // distance for command

const DIAMOND_CARSHOP_X = -204.324;
const DIAMOND_CARSHOP_Y =  826.917;
const DIAMOND_CARSHOP_Z = -20.8854;

const BADGUY_CARSHOP_X  = -632.584;
const BADGUY_CARSHOP_Y  =  959.446;
const BADGUY_CARSHOP_Z  = -19.0542;

include("modules/shops/carshop/commands.nut");
include("modules/shops/carshop/functions.nut");

// translations
translation("en", {
    "shops.carshop.gotothere"     : "If you want to buy a car go to Diamond Motors or to Bad Guy Motors!"
    "shops.carshop.welcome"       : "Hello there, %s! If you want to buy a car, you should first choose it via: /car list"
    "shops.carshop.nofreespace"   : "There is no free space near Parking. Please come again later!"
    "shops.carshop.money.error"   : "Sorry, you dont have enough money."
    "shops.carshop.selectmodel"   : "You can browse vehicle models, and their prices via: /car list"
    "shops.carshop.list.title"    : "Select car you like, and proceed to buying via: /car buy MODELID"
    "shops.carshop.list.entry"    : " - Model #%d, '%s'. Cost: $%.2f"
    "shops.carshop.success"       : "Contratulations! You've successfuly bought a car. Fare you well!"
    "shops.carshop.help.title"    : "List of available commands for CAR SHOP:"
    "shops.carshop.help.list"     : "Lists cars which are available to buy"
    "shops.carshop.help.buy"      : "Attempt to buy car by provided modelid"
});

event("onServerStarted", function() {
    // Diamond Motors motors
    create3DText( DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, DIAMOND_CARSHOP_Z + 0.35, "DIAMOND MOTORS", CL_ROYALBLUE );
    create3DText( DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, DIAMOND_CARSHOP_Z + 0.20, "/car", CL_WHITE.applyAlpha(75), CARSHOP_DISTANCE );

    createBlip  ( DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, ICON_GEAR, ICON_RANGE_FULL );

    // Badbuy Motors
    create3DText( BADGUY_CARSHOP_X, BADGUY_CARSHOP_Y, BADGUY_CARSHOP_Z + 0.35, "BAD GUY MOTORS", CL_ROYALBLUE );
    create3DText( BADGUY_CARSHOP_X, BADGUY_CARSHOP_Y, BADGUY_CARSHOP_Z + 0.20, "/car", CL_WHITE.applyAlpha(75), CARSHOP_DISTANCE );

    createBlip  ( BADGUY_CARSHOP_X, BADGUY_CARSHOP_Y, ICON_GEAR, ICON_RANGE_FULL );

    /**
     * Decorations
     */
    local decorations = {
        // bad guy
        owner = createVehicle(10, -636.462, 974, -18.8841, 179.847, -0.177159, 0.506108), // isw_508 (its like owners car)
        truck = createVehicle(4,  -621.439, 978.502, -18.5955, -89.51, 0.508353, -0.0252226), // truck (its like some truck or whatever)
        les69 = createVehicle(15, -626.467, 968.901, -18.8009, -89.6654, 0.517828, -0.130615), // lesisier69 car, just for fun
    };

    // paint lesisier69 black
    setVehicleColour( decorations.les69, 33, 33, 35, 33, 33, 35 );

    foreach (idx, vehicleid in decorations) {
        setVehicleOwner(vehicleid, VEHICLE_OWNER_CITY);
        setVehicleDirtLevel(vehicleid, 0.0);
    }
});

event("onPlayerVehicleEnter", function(playerid, vehiclid, seat) {
    return carShopFreeCarSlot(playerid, vehiclid);
});

event("onServerMinuteChange", function() {
    return carShopCheckFreeSpace();
});
