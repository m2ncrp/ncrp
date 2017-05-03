/**
 * Array with current market
 * @type {Array}
 */
local clothesPrices = [
   /* { skinid = 4 , price = 350, title = "shops.clothesshop.id4"    },  //
    { skinid = 6 , price = 380, title = "shops.clothesshop.id6"    },  //
    { skinid = 10, price = 320, title = "shops.clothesshop.id10"   },  //*/
    { skinid = 48,  price = 350, title = "shops.clothesshop.id48"   },  //
    { skinid = 74,  price = 350, title = "shops.clothesshop.id74"   },  //
    { skinid = 90,  price = 430, title = "shops.clothesshop.id90"   },  //
    { skinid = 93,  price = 450, title = "shops.clothesshop.id93"   },  //
    { skinid = 95,  price = 420, title = "shops.clothesshop.id95"   },  //
    { skinid = 92,  price = 390, title = "shops.clothesshop.id92"   },  //
    { skinid = 89,  price = 370, title = "shops.clothesshop.id89"   },  //
    { skinid = 86,  price = 370, title = "shops.clothesshop.id86"   },  //
    { skinid = 96,  price = 440, title = "shops.clothesshop.id96"   },  //
    { skinid = 117, price = 430, title = "shops.clothesshop.id96"   },  //
];

alternativeTranslate({
    "en|shops.clothesshop.gotothere"     : "If you want to buy clothes go to Vangel's clothing store in Midtown!"
    "en|shops.clothesshop.money.error"   : "Sorry, you don't have enough money."
    "en|shops.clothesshop.selectskin"    : "You can browse clothes and their prices by press E key."
    "en|shops.clothesshop.list.title"    : "Select clothes you like, and proceed to buying via: /skin buy skinID"
    "en|shops.clothesshop.list.entry"    : " - Skin #%d, '%s'. Cost: $%.2f"
    "en|shops.clothesshop.success"       : "Good choice! We look forward to welcoming you in our store!"

    "ru|shops.clothesshop.gotothere"     : "Если вы хотите купить одежду, отправляйтесь в магазин одежды Vangel's в Мидтауне!"
    "ru|shops.clothesshop.money.error"   : "К сожалению, у вас недостаточно денег."
    "ru|shops.clothesshop.selectskin"    : "Вы можете посмотреть одежду и цены на неё, нажав клавишу E."
    "ru|shops.clothesshop.list.title"    : "Выберите одежду, которая вам нравится, и купите её, используя: /skin buy skinID"
    "ru|shops.clothesshop.list.entry"    : " - Модель #%d, '%s'. Цена: $%.2f"
    "ru|shops.clothesshop.success"       : "Отличный выбор! Ждём Вас снова в нашем магазине!"


    "en|shops.clothesshop.id4"        : "Suit with hat"
    "ru|shops.clothesshop.id4"        : "Костюм с шляпой"

    "en|shops.clothesshop.id6"        : "Suit with vest and a hat"
    "ru|shops.clothesshop.id6"        : "Костюм с жилеткой и шляпой"

    "en|shops.clothesshop.id10"       : "Casual clothes"
    "ru|shops.clothesshop.id10"       : "Повседневная одежда"



    "en|shops.clothesshop.id48"        : "Suit for asian man"
    "ru|shops.clothesshop.id48"        : "Костюм для китайца"

    "en|shops.clothesshop.id50"        : "Suit with hat for old chinesse man"
    "ru|shops.clothesshop.id50"        : "Костюм с шляпой для пожилого китайца"

    "en|shops.clothesshop.id74"        : "Suit"
    "ru|shops.clothesshop.id74"        : "Костюм"

    "en|shops.clothesshop.id83"        : "Leather jacket for Irish"
    "ru|shops.clothesshop.id83"        : "Кожаная куртка для ирландца"

    "en|shops.clothesshop.id86"        : "Suit with vest for Irish"
    "ru|shops.clothesshop.id86"        : "Костюм с жилеткой для ирландца"

    "en|shops.clothesshop.id89"        : "Gray suit with hat for old man"
    "ru|shops.clothesshop.id89"        : "Серый костюм с шляпой для пожилого мужчины"

    "en|shops.clothesshop.id90"        : "Light coat with hat"
    "ru|shops.clothesshop.id90"        : "Светлое пальто с шляпой"

    "en|shops.clothesshop.id91"        : "Black cloak with hat"
    "ru|shops.clothesshop.id91"        : "Чёрный плащ с шляпой"

    "en|shops.clothesshop.id92"        : "Black coat"
    "ru|shops.clothesshop.id92"        : "Чёрное пальто"

    "en|shops.clothesshop.id93"        : "Dark coat with hat"
    "ru|shops.clothesshop.id93"        : "Тёмное пальто с шляпой"

    "en|shops.clothesshop.id95"        : "Gray coat"
    "ru|shops.clothesshop.id95"        : "Серое пальто"

    "en|shops.clothesshop.id96"        : "Suit with gray hat"
    "ru|shops.clothesshop.id96"        : "Костюм с серой шляпой"

    "en|shops.clothesshop.id99"        : "Gray suit with suspenders and a hat"
    "ru|shops.clothesshop.id99"        : "Серый костюм с подтяжками и шляпой"

    "en|shops.clothesshop.id111"       : "White shirt with green vest"
    "ru|shops.clothesshop.id111"       : "Белая рубашка с зелёной жилеткой"

    "en|shops.clothesshop.id117"       : "Gray coat with a hat for old man"
    "ru|shops.clothesshop.id117"       : "Серое пальто с шляпой для пожилого мужчины"

    "en|shops.clothesshop.id124"       : "Leather jacket with jeans"
    "ru|shops.clothesshop.id124"       : "Кожаная куртка с джинсами"

    "en|shops.clothesshop.id126"       : "Leather jacket with jeans and racing glasses"
    "ru|shops.clothesshop.id126"       : "Кожаная куртка с джинсами и гоночными очками"

    "en|shops.clothesshop.id127"       : "Leather jacket with jeans and a cap"
    "ru|shops.clothesshop.id127"       : "Кожаная куртка с джинсами и фуражкой"





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

    if(players[playerid].inventory.freelen() <= 0) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local skin = getSkinBySkinId(skinid);

    if (!canMoneyBeSubstracted(playerid, skin.price)) {
        //triggerClientEvent(playerid, "hideCarShopGUI");
        return msg(playerid, "shops.clothesshop.money.error", CL_ERROR);
    }

    // take money
    subMoneyToPlayer(playerid, skin.price);
    addMoneyToTreasury(skin.price);
    msg(playerid, "shops.clothesshop.success", CL_SUCCESS);
    local clothes = Item.Clothes();
    clothes.amount = skin.skinid;
    players[playerid].inventory.push( clothes );
    clothes.save();
    players[playerid].inventory.sync();

    //setPlayerModel(playerid, skin.skinid, true);
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
