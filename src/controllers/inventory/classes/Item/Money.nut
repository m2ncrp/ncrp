class Item.Money extends Item.Abstract
{
    static classname = "Item.Money";
    amount = 350.0;
    volume = 0.05;


    function use(playerid, inventory) {
        inventory.remove(this.slot).remove();
        inventory.sync();
        addMoneyToPlayer(playerid, this.amount);
        msg(playerid, "inventory.money.added", this.amount, CL_SUCCESS );
    }

    static function getType() {
        return "Item.Money";
    }
}
