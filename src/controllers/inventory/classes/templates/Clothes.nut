class Item.Clothes extends Item.Abstract
{
    static classname = "Item.Clothes";

    volume = 0.4;

    function use(playerid, inventory) {
        if(isPlayerInVehicle(playerid)) return msg(playerid, "inventory.leavethecar", CL_THUNDERBIRD);
        if(getCharacterIdFromPlayerId(playerid) in getCharsAnims()) return msg(playerid, "inventory.using", CL_THUNDERBIRD);
        if (getSkinData(this.amount)["sex"] != players[playerid].sex) return msg(playerid, format("inventory.clothes.wrongsex-%d", random(1, 3)), CL_THUNDERBIRD);
        if (getSkinData(this.amount)["race"] != players[playerid].race) return msg(playerid, "inventory.clothes.wrongrace", CL_THUNDERBIRD);
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
    function pick(playerid, inventory) {
        if (inventory instanceof PlayerHandsContainer) {
            msg(playerid, "inventory.pickupinhands", [ plocalize(playerid, "shops.clothesshop.id"+this.amount) ], CL_SUCCESS);
        }
        else if (inventory instanceof PlayerItemContainer) {
            msg(playerid, "inventory.pickedup", [ plocalize(playerid, "shops.clothesshop.id"+this.amount) ], CL_SUCCESS);
        }
    }

    function drop(playerid, inventory) {
        msg(playerid, "inventory.dropped", [ plocalize(playerid, "shops.clothesshop.id"+this.amount) ], CL_SUCCESS);
    }

    static function getType() {
        return "Item.Clothes";
    }
}
