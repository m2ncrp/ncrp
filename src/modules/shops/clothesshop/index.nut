// constants
const CLOTHES_SHOP_DISTANCE = 3.0; // distance for command

const CLOTHES_SHOP_X = -252.327;
const CLOTHES_SHOP_Y =  -79.719;
const CLOTHES_SHOP_Z = -11.458;


include("modules/shops/clothesshop/commands.nut");

event("onServerStarted", function() {
    // Diamond Motors motors
    create3DText( CLOTHES_SHOP_X, CLOTHES_SHOP_Y, CLOTHES_SHOP_Z + 0.35, "VANGEL'S", CL_ROYALBLUE );
    create3DText( CLOTHES_SHOP_X, CLOTHES_SHOP_Y, CLOTHES_SHOP_Z + 0.20, "Press E", CL_WHITE.applyAlpha(150), CARSHOP_DISTANCE );

    createBlip  ( CLOTHES_SHOP_X, CLOTHES_SHOP_Y, ICON_CLOTH, ICON_RANGE_FULL );

});
