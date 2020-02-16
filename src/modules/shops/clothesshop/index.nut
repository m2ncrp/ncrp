// constants
const CLOTHES_SHOP_DISTANCE = 3.0; // distance for command

const CLOTHES_SHOP_X = -252.327;
const CLOTHES_SHOP_Y =  -79.719;
const CLOTHES_SHOP_Z = -11.458;


include("modules/shops/clothesshop/commands.nut");

event("onServerStarted", function() {
    create3DText( CLOTHES_SHOP_X, CLOTHES_SHOP_Y, CLOTHES_SHOP_Z + 0.35, "VANGEL'S", CL_ROYALBLUE );

    createBlip  ( CLOTHES_SHOP_X, CLOTHES_SHOP_Y, ICON_CLOTH, ICON_RANGE_VISIBLE );
});

event("onServerPlayerStarted", function(playerid) {
    createPrivate3DText( playerid, CLOTHES_SHOP_X, CLOTHES_SHOP_Y, CLOTHES_SHOP_Z + 0.20, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(150), CARSHOP_DISTANCE );
});
