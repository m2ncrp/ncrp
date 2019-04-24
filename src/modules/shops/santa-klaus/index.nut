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
        dbg("chat", "idea", getAuthor(playerid), concat(vargv));
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

        if (players[playerid].getData("gift-ny18") == true || !players[playerid].inventory.canBeInserted(gift) ) {
            return msg(playerid, "santa.gift.alreadyget", CL_WARNING);
        }

        if (!players[playerid].inventory.isFreeVolume(gift)) {
            return msg(playerid, "inventory.volume.notenough", CL_ERROR);
        }

        players[playerid].inventory.push( gift );
        gift.save();
        players[playerid].inventory.sync();
        players[playerid].setData("gift-ny18", true);

        return msg( playerid, "santa.gift.get", CL_SUCCESS );
    }


});
