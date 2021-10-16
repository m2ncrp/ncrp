addEventHandler("givePlayerLockpick", function() {
    executeLua("game.game:GetActivePlayer():InventoryAddItem(36)");
});

addEventHandler("removePlayerLockpick", function() {
    executeLua("game.game:GetActivePlayer():InventoryRemoveItem(36)");
});

addEventHandler("setVehicleSteer", function(deg) {
    executeLua("game.game:GetActivePlayer():GetOwner():SetAddSteer("+deg+")");
});

addEventHandler("setVehicleDamage", function(dmg) {
    executeLua("game.game:GetActivePlayer():GetOwner():SetCarDamage("+dmg+")");
});

addEventHandler("setVehicleWheelsProtected", function(protected) {
    local value = protected == "0" ? "false" : "true";
    executeLua("game.game:GetActivePlayer():GetOwner():SetWheelsProtected("+value+")");
});

addEventHandler("onServerClientStarted", function (version = null) {
    setVehicleAcradeDriving(0.0)

    // value from 0.0 to 1.0
    // setVehicleAcradeDriving(1.0)
});

addEventHandler("setSpeedLimiter", function(speed) {
    executeLua("game.game:GetActivePlayer():GetOwner():SetSpeedLimiter("+speed+")");
});

addEventHandler("setSpeedLimiterSpeed", function(speed) {
    executeLua("game.game:GetActivePlayer():GetOwner():SetSpeedLimiterSpeed("+speed+")");
});
addEventHandler("setVehicleDoorLocked", function(...) {
    local vehicleid = vargv[0];

    if(vargv.len() == 3) {
        setVehicleDoorLocked(vehicleid, vargv[1], vargv[2]);
    } else {
        for (local i = 0; i <=3; i++) {
            setVehicleDoorLocked(vehicleid, i, vargv[1]);
        }
    }
});
