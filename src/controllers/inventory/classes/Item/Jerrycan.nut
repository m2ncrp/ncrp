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
        local fuelLevel = getVehicleFuelEx(vehicleid);
        local newFuelLevel = fuelLevel + gallons;
        setVehicleFuelEx(vehicleid, newFuelLevel);
        this.amount -= gallons;
        this.save();
        local fuelInGallonsSpent = gallons;
        local fuelInGallonsLost = this.amount;
        msg(playerid, "canister.use.spent", [formatGallons(fuelInGallonsSpent), formatGallons(fuelInGallonsLost)], CL_SUCCESS);
        logger.logf(
            join(["[VEHICLE JERRYCAN FUEL UP]", "%s [%d] (%s)", "%s - %s (model: %d, vehid: %d)", "%s", "coords: [%.5f, %.5f, %.5f]", "haveKey: %s", "%.2f + %.2f = %.2f gallons"], "\n"),
                getPlayerName(playerid),
                playerid,
                getAccountName(playerid),
                getVehiclePlateText(vehicleid),
                getVehicleNameByModelId(getVehicleModel(vehicleid)),
                getVehicleModel(vehicleid),
                vehicleid,
                getNearestTeleportFromVehicle(vehicleid).name,
                getVehiclePositionObj(vehicleid).x,
                getVehiclePositionObj(vehicleid).y,
                getVehiclePositionObj(vehicleid).z,
                isVehicleOwned(vehicleid) ? (isPlayerHaveVehicleKey(playerid, vehicleid) ? "true" : "false") : "city_ncrp",
                fuelLevel,
                gallons,
                newFuelLevel
        );
        inventory.sync();
    }

    static function getType() {
        return "Item.Jerrycan";
    }
}
