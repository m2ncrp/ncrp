class Item.Jerrycan extends Item.Abstract
{
    static classname = "Item.Jerrycan";
    weight      = 0.5;
    unitweight  = 0.2;
    capacity    = 20.0;

    function calculateWeight () {
        return this.weight + this.unitweight * this.amount;
    }

    function use(playerid, inventory) {
        if(isPlayerInVehicle(playerid)) return msg(playerid, "inventory.leavethecar", CL_THUNDERBIRD);
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
        inventory.sync();
    }

    static function getType() {
        return "Item.Jerrycan";
    }
}
