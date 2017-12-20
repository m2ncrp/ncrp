 addEventHandler("simpleShake", function(speed, strength, duration) {
    simpleShake(speed.tofloat(), strength.tofloat(), duration.tofloat());
 });


 addEventHandler("setPlayerDrunkLevel", function(level) {
    setPlayerDrunkLevel(level.tointeger());
 });
 // not working
 addEventHandler("resetPlayerDrunkLevel", function() {
    resetPlayerDrunkLevel();
 });
