class Item.RepairKit extends Item.Abstract
{
    static classname = "Item.RepairKit";
    volume = 100.0;

    function use(playerid, inventory) {
        if(isPlayerInVehicle(playerid) && isPlayerVehicleMoving(playerid)) return msg(playerid, "vehicle.stop", CL_THUNDERBIRD);

        local vehicleid = getNearestVehicleForPlayer(playerid, 3.0);

        if(vehicleid == false) return;

        local veh = getVehicleEntity(vehicleid);

        if(veh == null) return;

        triggerClientEvent(playerid, "setMotorDamageByVehicleId", vehicleid, 99);

        msg(playerid, format("Вы применили %s. Что вышло, то вышло :)", plocalize(playerid, this.classname)));
        inventory.remove(this.slot).remove();
        inventory.sync();
    }

    static function getType() {
        return "Item.RepairKit";
    }
}
