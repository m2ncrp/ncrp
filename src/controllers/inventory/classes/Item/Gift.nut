class Item.Gift extends Item.Abstract
{
    static classname = "Item.Gift";

    constructor () {
        base.constructor();
        // this.container.sizeX = this.container.sizeY = 1;
        this.volume = 13.5;
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

        local charid = getCharacterIdFromPlayerId(playerid);

        switch (charid) {
            case 293:
                item = Item.VehicleKey();
                item.setData("id", __vehicles[getVehicleByPlateText("LA-454")].entity.id);
            break;
            case 695:
            case 2607:
            case 1443:
                item = Item.Burger();
            break;
            default:
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
