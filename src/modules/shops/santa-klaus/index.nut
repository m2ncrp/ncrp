local SANTA_X = -295.721;
local SANTA_Y = 317.091;
local SANTA_Z = 2.10796;
local SANTA_RADIUS = 2.0;

alternativeTranslate({
    "en|santa.goto"                  :  "Go to Santa Claus Post in north-eastern part of a Lincoln Park."
    "ru|santa.goto"                  :  "Почта Санта-Клауса находится в северо-восточной части Линкольн Парка."

    "en|santa.writemsg"              :  "Write a message for Santa Claus."
    "ru|santa.writemsg"              :  "Напишите письмо для Санта-Клауса."

    "en|santa.complete"              :  "Well! Your message will be sent to Santa Claus."
    "ru|santa.complete"              :  "Отлично! Ваше письмо было отправлено Санта-Клаусу."

    "en|santa.sorry"                 :  "You are late. Santa has already gone for gifts."
    "ru|santa.sorry"                 :  "Ты припозднился. Санта уже отправился за подарками."

    "en|santa.returned"              :  "Santa returned with gifts. Get your: /gift"
    "ru|santa.returned"              :  "Санта вернулся с подарками. Получи свой: /gift"

    "en|santa.gaveout"               :  "Santa gave out all gifts :("
    "ru|santa.gaveout"               :  "Санта раздал все подарки :("

    "en|santa.gift.alreadyget"       :  "You have already received the gift."
    "ru|santa.gift.alreadyget"       :  "Вы уже получили свой подарок."

    "en|santa.gift.goto"             :  "You can receive the gift from Santa Claus in north-eastern part of a Lincoln Park."
    "ru|santa.gift.goto"             :  "Получить подарок от Санта-Клауса можно в северо-восточной части Линкольн Парка."

    "en|santa.gift.get"              :  "You received the gift."
    "ru|santa.gift.get"              :  "Вы получили подарок."
});

event("onServerStarted", function() {
    create3DText (SANTA_X, SANTA_Y, SANTA_Z+0.35, "SANTA CLAUS POST", CL_FLAMINGO );
    create3DText (SANTA_X, SANTA_Y, SANTA_Z+0.20, "/santa", CL_WHITE.applyAlpha(150), SANTA_RADIUS );

    createBlip(SANTA_X, SANTA_Y, [ 0, 9 ], 4000.0);
 });

local timestampStart = 1640415800; // суббота, 25 декабря 2021 г., 12:00:00 GMT+03:00
local timestampExchangeEnd =  1641232800 // понедельник, 3 января 2022 г., 21:00:00 GMT+03:00

event("onServerSecondChange", function() {
    local currentTimestamp = getTimestamp() + 10800; // GMT+3

    if(currentTimestamp == timestampStart) {
        dbg("spawn first 30 items");
        // send msg to all online players
    }

    local h = floor(currentTimestamp % 86400 / 3600 );
    local m = floor(currentTimestamp % 3600 / 60);
    local s = floor(currentTimestamp % 3600 % 60);

    dbg(format("%d:%d:%d", h, m, s))


});

cmd("santa", function(playerid, ...) {
    if(!isPlayerInValidPoint(playerid, SANTA_X, SANTA_Y, SANTA_RADIUS)) {
        return msg( playerid, "santa.goto", CL_FLAMINGO );
    }


    if( (getDay() >= 30 && getMonth() == 12 && getYear() == 1951) || (getDay() <= 8 && getMonth() == 1 && getYear() == 1952) ) {
        return msg( playerid, "santa.returned", CL_SUCCESS );
    }

    if(getDay() >= 27 && getMonth() == 12 && getYear() == 1951) {
        return msg( playerid, "santa.sorry", CL_WARNING );
    }

    local text = (concat(vargv));
    if (text && strip(text).len() > 0) {
        msg(playerid, "santa.complete", CL_SUCCESS);
        statisticsPushText("santa", playerid, concat(vargv));
        //dbg("chat", "idea", getAuthor(playerid), concat(vargv));
        return;
    }
    return msg(playerid, "santa.writemsg", CL_FLAMINGO);

});



cmd("gift", function(playerid, ...) {
    if(!isPlayerInValidPoint(playerid, SANTA_X, SANTA_Y, SANTA_RADIUS)) {
        return msg( playerid, "santa.gift.goto", CL_FLAMINGO );
    }

    if( (getDay() >= 30 && getMonth() == 12 && getYear() == 1951) || (getDay() <= 8 && getMonth() == 1 && getYear() == 1952) ) {

        local gift = Item.Gift();

        if (players[playerid].getData("gift-ny22") == true || !players[playerid].inventory.canBeInserted(gift) ) {
            return msg(playerid, "santa.gift.alreadyget", CL_WARNING);
        }

        if (!players[playerid].inventory.isFreeVolume(gift)) {
            return msg(playerid, "inventory.volume.notenough", CL_ERROR);
        }

        players[playerid].inventory.push( gift );
        gift.save();
        players[playerid].inventory.sync();
        players[playerid].setData("gift-ny22", true);

        return msg( playerid, "santa.gift.get", CL_SUCCESS );
    }


});


local giftPoints = [
  [-668.33, -216.72, -3.33],
  [-182.42, 180.43, -10.56],
  [-4.41, -230.97, -13.09],
  [68.31, -323.82, -20.16],
  [340.03, -111.53, -6.76],
  [636.98, -232.72, -11.65],
  [713.6, -395.77, -18.47],
  [428.55, -426.14, -20.16],
  [266.99, -507.73, -22.7],
  [147.19, -734.91, -15.39]
];

function getGiftPosition(id) {
    return id in giftPoints ? giftPoints[id] : null;
}

acmd("ny", function(playerid, id) {
    id = id.tointeger();
    local pointPos = getGiftPosition(id);
    if (pointPos) {
        setPlayerPosition(playerid, pointPos[0], pointPos[1], pointPos[2]);
    }
})