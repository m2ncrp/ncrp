addEventHandler("givePlayerLockpick", function() {
    executeLua("game.game:GetActivePlayer():InventoryAddItem(36)");
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

addEventHandler("setSpeedLimiter", function(speed) {
    executeLua("game.game:GetActivePlayer():GetOwner():SetSpeedLimiter("+speed+")");
});

addEventHandler("setSpeedLimiterSpeed", function(speed) {
    executeLua("game.game:GetActivePlayer():GetOwner():SetSpeedLimiterSpeed("+speed+")");
});