class Item.Jerrycan extends Item.Abstract
{
    static classname = "Item.Jerrycan";
    capacity = 20.0;

    function calculateWeight () {
        return this.weight * this.amount;
    }

    function use(playerid, inventory) {
        if(isPlayerInVehicle(playerid)) return msg(playerid, "Leave the car");
        if(this.amount <= 0) return msg(playerid, "Jerrycan is empty.");

        local vehicleid = getNearestVehicleForPlayer(playerid, 3.0);

        if(vehicleid < 0) {
            return msg(playerid, "no neear car");
        }

        if(!isVehicleFuelNeeded(vehicleid)) {
            return msg(playerid, "shops.fuelstations.fueltank.full");
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
        msg(playerid, "Zalito: "+fuel+" litres.");
    }

    static function getType() {
        return "Item.Jerrycan";
    }
}
