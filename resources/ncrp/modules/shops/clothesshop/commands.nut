/**
 * Array with current market
 * @type {Array}
 */
local clothesPrices = [
    { skinid = 4 , price = 320, title = "shops.clothesshop.id4"    },  //
    { skinid = 6 , price = 350, title = "shops.clothesshop.id6"    },  //
    { skinid = 10, price = 300, title = "shops.clothesshop.id10"   },  //
    { skinid = 48, price = 290, title = "shops.clothesshop.id48"   },  //
    { skinid = 74, price = 150, title = "shops.clothesshop.id74"   },  //
    { skinid = 90, price = 400, title = "shops.clothesshop.id90"   },  //
    { skinid = 91, price = 250, title = "shops.clothesshop.id91"   },  //
    { skinid = 92, price = 370, title = "shops.clothesshop.id92"   },  //
];

translation("en", {
    "shops.clothesshop.gotothere"     : "If you want to buy clothes go to Vangel's clothing store in Midtown!"
    "shops.clothesshop.money.error"   : "Sorry, you don't have enough money."
    "shops.clothesshop.selectskin"    : "You can browse clothes and their prices by press E key."
    "shops.clothesshop.list.title"    : "Select clothes you like, and proceed to buying via: /skin buy skinID"
    "shops.clothesshop.list.entry"    : " - Skin #%d, '%s'. Cost: $%.2f"
    "shops.clothesshop.success"       : "Good choice! We look forward to welcoming you in our store!"

    "shops.clothesshop.id4"        : "Suit with hat"
    "shops.clothesshop.id6"        : "Suit with vest and a hat"
    "shops.clothesshop.id10"       : "Casual clothes"
    "shops.clothesshop.id48"       : "Suit (Asian)"
    "shops.clothesshop.id74"       : "Suit"
    "shops.clothesshop.id90"       : "Light coat with hat"
    "shops.clothesshop.id91"       : "Black cloak with hat"
    "shops.clothesshop.id92"       : "Black coat"

});



key("e", function(playerid) {

    if(!isPlayerInValidPoint(playerid, CLOTHES_SHOP_X, CLOTHES_SHOP_Y, CLOTHES_SHOP_DISTANCE)) {
        //return msg( playerid, "job.docker.letsgo", DOCKER_JOB_COLOR );
        return;
    }

    msg(playerid, "shops.clothesshop.list.title", CL_INFO);

    foreach (idx, skin in clothesPrices) {
        msg(playerid, "shops.clothesshop.list.entry", [skin.skinid, plocalize(playerid, skin.title), skin.price])
    }

    msg(playerid, "shops.clothesshop.list.title", CL_INFO);
});



/**
 * Attempt to by car model
 * Usage: /car buy
 */

cmd("skin", "buy", function(playerid, skinid = null) {
    local skinid = toInteger(skinid);

    if(!isPlayerInValidPoint(playerid, CLOTHES_SHOP_X, CLOTHES_SHOP_Y, CLOTHES_SHOP_DISTANCE)) {
        return msg(playerid, "shops.clothesshop.gotothere", getPlayerName(playerid), CL_WARNING);
    }

    if (!skinid || !getSkinBySkinId(skinid)) {
        return msg(playerid, "shops.clothesshop.selectskin");
    }

    local skin = getSkinBySkinId(skinid);

    if (!canMoneyBeSubstracted(playerid, skin.price)) {
        //triggerClientEvent(playerid, "hideCarShopGUI");
        return msg(playerid, "shops.clothesshop.money.error", CL_ERROR);
    }

    // take money
    subMoneyToPlayer(playerid, skin.price);

    setPlayerModel(playerid, skin.skinid, true)

    //triggerClientEvent(playerid, "hideCarShopGUI");
    return msg(playerid, "shops.clothesshop.success", CL_SUCCESS);
});



/**
 * Get car shop model by number id
 * @param  {Integer} modelid
 * @return {Table}
 */
function getSkinBySkinId(skinid) {
    foreach(idx, skin in clothesPrices) {
        if (skin.skinid == skinid.tointeger()) {
            return skin;
        }
    }

    return null;
}
