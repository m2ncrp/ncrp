alternativeTranslate({

    "en|harryshop.hello"     :  "[ARMY NAVI] Who is that?"
    "ru|harryshop.hello"     :  "[ARMY NAVI] Кто это?"

    "en|harryshop.introduce" :  "Introduce yourself"
    "ru|harryshop.introduce" :  "Представься"

    "en|harryshop.comeon"    :  "[ARMY NAVI] Come on in"
    "ru|harryshop.comeon"    :  "[ARMY NAVI] Ну, заходи"

    "en|harryshop.getout"    :  "[ARMY NAVI] Get out of here!"
    "ru|harryshop.getout"    :  "[ARMY NAVI] Вали отсюда!"
});

//["onfoot",  "Enter",   -1292.64, 1608.74, 4.30491,      "harryShopEnter"],
//["onfoot",  "Exit",    -1293.31, 1608.81, 4.33968,      "harryShopExit"],

local harryShopCoordsEnter = [-1292.64, 1608.74, 4.30491];
local harryShopCoordsExit  = [-1293.31, 1608.81, 4.33968];
local ENTER_TIMEOUT = 30; // in seconds
local harry_COLOR = CL_CARIBBEANGREEN;
local timers = {};

event("onServerStarted", function() {
    createBlip(harryShopCoordsEnter[0], harryShopCoordsEnter[1], ICON_ARMY, 4000.0);
});

event("onServerPlayerStarted", function( playerid ){
    createPrivate3DText ( playerid, harryShopCoordsEnter[0], harryShopCoordsEnter[1], harryShopCoordsEnter[2]+0.35, "ARMY NAVY", rgb(240, 202, 144) );
    createPrivate3DText ( playerid, harryShopCoordsEnter[0], harryShopCoordsEnter[1], harryShopCoordsEnter[2]+0.20, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(150), 0.5 );
    createPrivate3DText ( playerid, harryShopCoordsExit[0], harryShopCoordsExit[1], harryShopCoordsExit[2]+0.20, [["Exit", "3dtext.job.press.E"], "%s | %s"], CL_WHITE.applyAlpha(150), 0.5 );
});


// Enter
key("e", function(playerid) {

    if(!isPlayerInValidPoint(playerid, harryShopCoordsEnter[0], harryShopCoordsEnter[1], 0.5)) {
        return;
    }

    local charId = getCharacterIdFromPlayerId(playerid);
    if ( ! (charId in timers) ) {
        timers[charId] <- null;
    }

    if (timers[charId] && timers[charId].IsActive()) {
        return;
    }

    msg(playerid, "harryshop.hello", CL_INFO);
    msg(playerid, "harryshop.introduce", CL_GRAY);

    freezePlayer(playerid, true);

    trigger(playerid, "hudCreateTimer", ENTER_TIMEOUT, true, true);

    timers[charId] = delayedFunction(ENTER_TIMEOUT*1000, function() {
        if (timers[charId].IsActive()) {
            msg(playerid, "harryshop.getout", CL_INFO);
            freezePlayer(playerid, false);
        }
    });

    requestUserInput(playerid, function(playerid, text) {
        trigger(playerid, "hudDestroyTimer");
        freezePlayer(playerid, false);
        timers[charId].Kill();

        if ( (text.find("Дэвид") != null && text.find("Джонсон") != null ) || ( text.find("David") != null && text.find("Johnson") != null ) ) {
            msg(playerid, "harryshop.comeon", CL_INFO);
            setPlayerPosition(playerid, harryShopCoordsExit[0], harryShopCoordsExit[1], harryShopCoordsExit[2]);
            return;
        }
        return msg(playerid, "harryshop.getout", CL_INFO);

    }, ENTER_TIMEOUT);

});

// Exit
key("e", function(playerid) {
    if(!isPlayerInValidPoint(playerid, harryShopCoordsExit[0], harryShopCoordsExit[1], 0.5)) {
        return;
    }
    setPlayerPosition(playerid, harryShopCoordsEnter[0], harryShopCoordsEnter[1], harryShopCoordsEnter[2]);

});
