class Item.Jerrycan extends Item.Abstract
{
    static classname = "Item.Jerrycan";
    capacity = 20.0;
    weight = 0.25;

    function calculateWeight () {
        return this.weight * this.amount;
    }

    function use(playerid, inventory) {
        if(isPlayerInVehicle(playerid)) return msg(playerid, "canister.use.leavethecar", CL_THUNDERBIRD);
        if(this.amount <= 0) return msg(playerid, "canister.use.empty", CL_THUNDERBIRD);

        local vehicleid = getNearestVehicleForPlayer(playerid, 3.0);

        if(vehicleid < 0) {
            return msg(playerid, "canister.use.farfromvehicle", CL_THUNDERBIRD);
        }

        if(!isVehicleFuelNeeded(vehicleid)) {
            return msg(playerid, "canister.use.fueltankfull", CL_THUNDERBIRD);
        }

        local fuel = 0;
        local needFuel = getVehicleFuelNeed(vehicleid);
        if(this.amount > needFuel) {
            fuel = needFuel;
        } else {
            fuel = this.amount;
        }
        setVehicleFuel(vehicleid, getVehicleFuelEx(vehicleid) + fuel);
        this.amount -= fuel;
        this.save();
        msg(playerid, "canister.use.spent", [fuel, this.amount], CL_SUCCESS);
    }

    static function getType() {
        return "Item.Jerrycan";
    }
}
