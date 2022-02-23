addEventHandler("setGPS", function(fx, fy, fz = 0.0, textId = "0050000023") {
    setGPSTarget(fx.tofloat(), fy.tofloat(), fz.tofloat(), textId);
});

/*
    game.navigation:RegisterIconPos("-126.2","264.5",1,4,"Nbrid",true)
    game.navigation:UnregisterIconPos(game.navigation:RegisterIconPos("-126.2","264.5",1,4,"Nbrid",true))
    game.navigation:DisableFarVisibility(game.navigation:RegisterIconPos("-126.2","264.5",1,4,"Nbrid",true))

    This command automatically gives a map a red icon and the red line path
    game.navigation:RegisterObjectivePos(-45.4, 724.9 ,game.quests:NewQuest("", "", true, "", ""):AddObjective(""))

*/

addEventHandler("removeGPS",function() {
    removeGPSTarget();
});

addEventHandler("hudCreateTimer", function(seconds, showed, started) {
    if(isHudTimerRunning()) {
        destroyHudTimer();
    }
    createHudTimer( seconds.tofloat() * 0.75, showed, started );
})

addEventHandler("hudDestroyTimer", function() {
    if(isHudTimerRunning()) {
        destroyHudTimer();
    }
});
