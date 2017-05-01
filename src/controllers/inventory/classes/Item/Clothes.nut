class Item.Clothes extends Item.Abstract
{
    static classname = "Item.Clothes";

    weight = 0.4;

    function use(playerid, inventory) {
        if(isPlayerInVehicle(playerid)) return msg(playerid, "inventory.leavethecar", CL_THUNDERBIRD);
        local model = getPlayerModel(playerid);
        if(getDefaultPlayerModel(playerid) != model) {
            return msg(playerid, "inventory.clothes.work", CL_THUNDERBIRD);
        }
        setPlayerModel(playerid, this.amount, true);
        msg(playerid, "inventory.clothes.use", [ plocalize(playerid, "shops.clothesshop.id"+this.amount) ] );
        this.amount = model;
        this.save();
        inventory.sync();
    }

    static function getType() {
        return "Item.Clothes";
    }
}
