class Item.Jerrycan extends Item.Abstract
{
    static classname = "Item.Jerrycan";
    volume      = 23.46;  // объём канистры снаружи
    //unitvolume  = 1; // вес 1 литра бензина 730 грамм
    capacity    = 20;  // количество литров в канистре

    //function calculateVolume () {
    //    return this.volume + this.unitvolume * this.amount;
    //}

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
        local fuelInGallonsSpent = fuel * GALLONS_PER_LITRE;
        local fuelInGallonsLost = this.amount * GALLONS_PER_LITRE;
        msg(playerid, "canister.use.spent", [fuelInGallons, formatGallons(fuelInGallonsSpent), fuelInGallonsLost, formatGallons(fuelInGallonsLost)], CL_SUCCESS);
        inventory.sync();
    }

    static function getType() {
        return "Item.Jerrycan";
    }
}
