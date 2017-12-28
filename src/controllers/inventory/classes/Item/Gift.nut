class Item.Gift extends Item.Abstract
{
    static classname = "Item.Gift";

    constructor () {
        base.constructor();
        // this.container.sizeX = this.container.sizeY = 1;
        this.weight = 0.10;
        this.default_decay = 0;
    }

    function pick(playerid, inventory) {
        msg(playerid, "inventory.pickedup", [ plocalize(playerid, this.classname )], CL_SUCCESS);
        players[playerid].setData("gift-ny18", true);
    }

    function use(playerid, inventory) {
        //if (players[playerid].getData("gift-ny18")) {
        //    msg(playerid, "inventory.gift.alreadyget", CL_WARNING);
        //    return false;
        //}

        inventory.remove(this.slot);

        local item;

        if (getCharacterIdFromPlayerId(playerid) == 293) {
            item = Item.VehicleKey();
            item.setData("id", __vehicles[getVehicleByPlateText("LA-454")].entity.id);
        } else {
            item = Item.Money();
        }

        inventory.set(this.slot, item);
        inventory.sync();
        this.remove();
    }

    static function getType() {
        return "Item.Gift";
    }
}
