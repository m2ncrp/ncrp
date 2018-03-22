class NVC.KeyLock extends NVC
{
    static classname = "NVC.KeyLock";
    limit = 1;

    constructor(data = null) {
        base.constructor(data);

        if (this.data == null) {
            this.data = { code = generateHash(3) }
        }
    }

    function getCode() {
        return this.data.code;
    }

    function isUnlockableBy(character) {
        local code = this.getCode();

        return character.inventory
            .filter(@(item) (item instanceof Item.VehicleKey))
            .map(@(key) key.getCode() == code)
            .reduce(@(a,b) a || b)
    }
}

// key("q", function(playerid) {
//     if (!isPlayerInNVehicle(playerid)) return;
//     local vehicle = getPlayerNVehicle(playerid);

//     if (isPlayerHaveNVehicleKey(players[playerid], vehicle)) {
//         vehicle.getComponent(NVC.KeyLock).action();
//         vehicle.getComponent(NVC.Engine).setStatusTo(KeyLock.data.status);
//         vehicle.getComponent(NVC.Engine).correct();
//     }

// });
