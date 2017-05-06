class Item.FirstAidKit extends Item.Abstract
{
    static classname = "Item.FirstAidKit";

    weight = 0.75;
    unitweight = 0.25;
    amount = 4;

    function calculateWeight () {
        return this.weight + this.unitweight * this.amount;
    }

    function use(playerid, inventory) {
        if(isPlayerInVehicle(playerid) && isPlayerVehicleMoving(playerid)) return msg(playerid, "vehicle.stop", CL_THUNDERBIRD);

        local targetid = playerList.nearestPlayer( playerid );

        if(targetid == null) return msg(playerid, "general.noonearound", CL_THUNDERBIRD);

        if(this.amount == 0) return msg(playerid, "inventory.firstaidkit.use.bad.over", CL_THUNDERBIRD);

        local health = getPlayerHealth(targetid);

        if(health >= 700.0) return msg(playerid, "inventory.firstaidkit.he.healthy", CL_SUCCESS);

        if(this.amount > 1) {
            this.amount -= 1;
            msg(playerid, "inventory.firstaidkit.use.good.left", [ this.amount ], CL_SUCCESS );
            this.save();
        } else {
            msg(playerid, "inventory.firstaidkit.use.good.empty", CL_SUCCESS );
            inventory.remove(this.slot).remove();
        }
        msg(playerid, "inventory.firstaidkit.healedby", CL_SUCCESS );
        setPlayerHealth( targetid, 720.0 );

        inventory.sync();
    }

    static function getType() {
        return "Item.FirstAidKit";
    }
}
