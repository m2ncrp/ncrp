class Item.Money extends Item.Abstract
{
    static classname = "Item.Money";
    default_decay = 0;
    volume = 0.1345;

    function use(playerid, inventory) {
        inventory.remove(this.slot).remove();
        inventory.sync();
        addPlayerMoney(playerid, this.amount);
        msg(playerid, "inventory.money.added", this.amount, CL_SUCCESS );
    }

    static function getType() {
        return "Item.Money";
    }
}
