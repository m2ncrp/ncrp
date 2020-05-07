class Item.Jerrycan extends Item.Abstract
{
    static classname = "Item.Jerrycan";
    volume      = 23.46;  // объём канистры снаружи
    //unitvolume  = 1; // вес 1 литра бензина 730 грамм
    capacity    = 5.3;  // количество галонов в канистре

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

        local gallons = 0;
        local needGallons = getVehicleFuelNeed(vehicleid);
        if(this.amount > needGallons) {
            gallons = needGallons;
        } else {
            gallons = this.amount;
        }
        setVehicleFuel(vehicleid, (getVehicleFuelEx(vehicleid) + gallons) * LITRES_PER_GALLON);
        this.amount -= gallons;
        this.save();
        local fuelInGallonsSpent = gallons;
        local fuelInGallonsLost = this.amount;
        msg(playerid, "canister.use.spent", [formatGallons(fuelInGallonsSpent), formatGallons(fuelInGallonsLost)], CL_SUCCESS);
        inventory.sync();
    }

    static function getType() {
        return "Item.Jerrycan";
    }
}
