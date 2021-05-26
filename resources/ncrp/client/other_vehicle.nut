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

addEventHandler("onServerClientStarted", function (version = null) {
    setVehicleAcradeDriving(0.0)

    // value from 0.0 to 1.0
    // setVehicleAcradeDriving(1.0)
})
