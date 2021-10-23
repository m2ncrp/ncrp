class Item.Food extends Item.Abstract
{
    static classname = "Item.Food";
    hasAnimation = true;
    model = 1;
    animLen = 3200;

    static function getType() {
        return "Item.Food";
    }

    function use(playerid, inventory) {
        this.animate(playerid, "Use" + this.getType(), this.model);
        msg(playerid, format("Вы съели: %s", plocalize(playerid, this.classname)));
        addPlayerHunger(playerid, randomf(this.amount - 5.0, this.amount + 5.0));
        inventory.remove(this.slot).remove();
        inventory.sync();
    }
    function useGround(playerid) {
      msg(playerid, "You are loser");
    }
}
