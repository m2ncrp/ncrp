// constants
const CLOTHES_SHOP_DISTANCE = 3.0; // distance for command

const CLOTHES_SHOP_X = -252.327;
const CLOTHES_SHOP_Y =  -79.719;
const CLOTHES_SHOP_Z = -11.458;


include("modules/shops/clothesshop/commands.nut");

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
    create3DText( CLOTHES_SHOP_X, CLOTHES_SHOP_Y, CLOTHES_SHOP_Z + 0.35, "VANGEL'S", CL_ROYALBLUE );
    create3DText( CLOTHES_SHOP_X, CLOTHES_SHOP_Y, CLOTHES_SHOP_Z + 0.20, "Press E", CL_WHITE.applyAlpha(150), CARSHOP_DISTANCE );

    createBlip  ( CLOTHES_SHOP_X, CLOTHES_SHOP_Y, ICON_CLOTH, ICON_RANGE_FULL );

});
