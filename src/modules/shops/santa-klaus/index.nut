local SANTA_X = -295.721;
local SANTA_Y = 317.091;
local SANTA_Z = 2.10796;
local SANTA_RADIUS = 2.0;

alternativeTranslate({
    "en|santa.goto"              :   "Go to Santa Claus Post in north-eastern part of a Lincoln Park"
    "ru|santa.goto"              :   "Почта Санта-Клауса находится в северо-восточной части Линкольн Парка"

    "en|santa.writemsg"          :   "Write a message for Santa Claus"
    "ru|santa.writemsg"          :   "Напишите письмо для Санта-Клауса"

    "en|santa.complete"          :   "Well! Your message will be sent to Santa Claus"
    "ru|santa.complete"          :   "Отлично! Ваше письмо было отправлено Санта-Клаусу"
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

    local text = (concat(vargv));
    if (text && strip(text).len() > 0) {
        msg(playerid, "santa.complete", CL_SUCCESS);
        statisticsPushText("santa", playerid, concat(vargv));
        dbg("chat", "idea", getAuthor(playerid), concat(vargv));
        return;
    }
    return msg(playerid, "santa.writemsg", CL_FLAMINGO);

});
